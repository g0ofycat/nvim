--=======================
-- // RETURN
--=======================

return {
    'DrKJeff16/project.nvim',

    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'ibhagwan/fzf-lua',
    },

    config = function()
        require('project').setup({
            lsp = {
                enabled = true
            },
            patterns = { '.git', 'Makefile', 'makefile', 'package.json', '.gitignore', 'CMakeLists.txt', 'README.md' },
        })
    end,
}
