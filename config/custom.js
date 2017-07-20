// Config for jupyter notebook
// Skeleton from https://github.com/lambdalisue/jupyter-vim-binding/README.md

// Configure CodeMirror
require([
    'nbextensions/vim_binding/vim_binding',  // depends on your installation
], function() {
    // Map jk to <Esc>
    CodeMirror.Vim.map("jk", "<Esc>", "insert");
    CodeMirror.Vim.map("JK", "<nop>", "insert");
    // Map ; to :
    CodeMirror.Vim.map(";", ":", "normal");
    CodeMirror.Vim.map(";", ":", "visual");
});

// Disable automatic insertion of matching braces, brackets, and parentheses
IPython.CodeCell.options_default.cm_config.autoCloseBrackets = false;
