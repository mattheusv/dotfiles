return require('packer').startup(function()
    -- Boostrap packer
    use({ 'wbthomason/packer.nvim' })

    -- Comment stuff
    use({ 'tpope/vim-commentary' })

    -- Git plugins
    use({ 'airblade/vim-gitgutter' })
    use({ 'rhysd/git-messenger.vim' })

    -- Status/tabline
    use({ 'itchyny/lightline.vim' })

    -- UI
    use({"lukas-reineke/indent-blankline.nvim", tag = "v2.20.8" })
    use({ 'nvim-lua/plenary.nvim' })
    use({
        'nvim-lua/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
        },
    })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'preservim/nerdtree' })

    -- Color Theme
    use({ 'morhetz/gruvbox' })
    use({'rafikdraoui/couleurs.vim'})
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })

    -- Surround parentheses, brackets, quotes, XML tags, and more
    use({ 'tpope/vim-surround' })

    -- Markdown preview
    use({ 'euclio/vim-markdown-composer', run = 'cargo build --release --locked' })

    -- Spell checking
    use({'mateusbraga/vim-spell-pt-br'})

    -- LSP
    use({ 'neovim/nvim-lspconfig' })
    use({ "L3MON4D3/LuaSnip" })
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind-nvim",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
        },
    })

    -- Golang
    use({ 'fatih/vim-go', run = ':GoInstallBinaries' })

    -- Zig
    use({ 'ziglang/zig.vim' } )

    -- Java
    use({ 'mfussenegger/nvim-jdtls' })

    use ({
        'renerocksai/telekasten.nvim',
        requires = {'nvim-telescope/telescope.nvim'}
    })

end)
