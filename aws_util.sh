#!/usr/bin/env bash

# Utilities for simple operation (connect, restart, stop) of AWS EC2 instances.
# Must install aws CLI
# Must populate aws CLI credentials
# -> saved into ~/.aws
# Must populate ec2 instance config and credentials
# -> export AWS_EC2_USER_NAME="ec2-user"            # for example
# -> export AWS_EC2_SSH_KEY="$HOME/.ssh/my-key.pem" # for example.
# In the above, use '$HOME' instead of '~'. Trust me.

# Exports here
export connect_to_instance

function get_instance_id {
    local name_tag=$1
    aws ec2 describe-instances --filter "Name=tag:Name,Values=$name_tag" \
        | jq '.Reservations[0].Instances[0].InstanceId' \
        | tr -d '"'
}

function get_instance_status {
    local name_tag=$1
    aws ec2 describe-instances --filter "Name=tag:Name,Values=$name_tag" \
        | jq '.Reservations[0].Instances[0].State.Name' \
        | tr -d '"'
}

function is_instance_stopped {
    local name_tag=$1
    if [ "$(get_instance_status ${name_tag})" = "stopped" ]; then
        return 0
    else
        return 1
    fi
}

function get_instance_public_dns_name {
    local name_tag=$1
    aws ec2 describe-instances --filter "Name=tag:Name,Values=$name_tag" \
        | jq '.Reservations[0].Instances[0].PublicDnsName' \
        | tr -d '"'
}

function get_security_group_groupid {
    local name_tag=$1
    echo "Getting security group id for instance name: ${name_tag}" >&2
    aws ec2 describe-instances --filter "Name=tag:Name,Values=$name_tag" \
        | jq '.Reservations[0].Instances[0].SecurityGroups[0].GroupId' \
        | tr -d '"'
}

function get_my_ip {
    wget -q -O - checkip.amazonaws.com
}

function get_my_cidr {
    # TODO - just adds /32 mask to everything instead of getting mask correctly
    echo "$(get_my_ip)/32"
}

function update_security_group_my_ip {
    local name_tag=$1
    local group_id="$(get_security_group_groupid ${name_tag})"

    # revoke all existing ssh cidrs
    declare -a existing_cidrs=(\
        $(\
             aws ec2 describe-security-groups --group-ids "${group_id}" \
                 | jq '.SecurityGroups[].IpPermissions | map(select(.FromPort==22)) | .[].IpRanges[].CidrIp' \
                 | tr -d '"'
         )\
    )
    for cidr in ${existing_cidrs[@]};
    do
        echo "Revoking existing ssh access for cidr: $cidr" >&2
        aws ec2 revoke-security-group-ingress --group-id "${group_id}" \
            --protocol tcp --port 22 --cidr $cidr
    done

    # authorize new ssh cidrs
    local cidr=$(get_my_cidr)
    echo "Authorizing new ssh access for cidr: $cidr" >&2
    aws ec2 authorize-security-group-ingress --group-id $group_id \
        --protocol tcp --port 22 --cidr $cidr
}

function restart_instance {
    local name_tag=$1
    local instance_id=$(get_instance_id ${name_tag})
    echo "Restarting instance: $instance_id" >&2
    aws ec2 start-instances --instance-ids $instance_id >/dev/null 2>&1
}

function stop_instance {
    local name_tag=$1
    local instance_id=$(get_instance_id ${name_tag})
    echo "Stopping instance: $instance_id" >&2
    aws ec2 stop-instances --instance-ids $instance_id
}

function connect_to_instance {
    if [ "$#" != "1" ]; then
        echo "usage: connect_to_instance instance_tag_name"
        return 1
    fi

    eval '_USER_NAME="${AWS_EC2_USER_NAME}"'
    eval '_SSH_KEY="${AWS_EC2_SSH_KEY}"'
    if [ "${_USER_NAME}" = "" ] \
       || [ "${_SSH_KEY}" = "" ] \
       || [ ! -f "${_SSH_KEY}" ]; then
        echo "Error: populate AWS_EC2_USER_NAME and AWS_EC2_SSH_KEY variables"
        return 1
    fi

    local name_tag=$1
    local instance_id=$(get_instance_id ${name_tag}) || { echo "Error: Could not get instance id"; return 1; }

    # Restart instance is status is "stopped"
    if is_instance_stopped $name_tag; then
        restart_instance $name_tag || { echo "Error: Could not restart instance."; return 1; }
        echo -n "Instance $instance_id is restarting" >&2
        while [ "$(get_instance_status $name_tag)" != "running" ];
        do
            sleep 5
            echo -n '.' >&2
        done
        echo " done" >&2
    fi

    # Connect, using updated PublicDnsName and updated security group settings
    local dns_name=$(get_instance_public_dns_name ${name_tag}) || { echo "Error: Could not get instance PublicDnsName"; return 1; }
    update_security_group_my_ip "${name_tag}" || { echo "Error: Could not update security group my ip"; return 1; }
    echo "Connecting to ${_USER_NAME}@${dns_name}" >&2
    ssh -i ${_SSH_KEY} ${_USER_NAME}@${dns_name}
}
