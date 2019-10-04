# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

# From https://github.com/TypeStrong/atom-typescript/blob/master/docs/faq.md#i-want-to-use-atom-typescript-with-javascript-too
do (grammarPackageImUsing = "language-javascript") ->
  atom.packages.onDidTriggerActivationHook "#{grammarPackageImUsing}:grammar-used", ->
    atom.packages.triggerActivationHook 'language-typescript:grammar-used'

# ex-mode
atom.packages.onDidActivatePackage (pack) ->
  if pack.name == 'ex-mode'
    Ex = pack.mainModule.provideEx()
    #Ex.registerCommand 's', -> console.log("Zzzzzz...")
