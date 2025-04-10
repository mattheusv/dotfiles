return require('packer').startup(function()
    -- Bootstrap packer
    use({ 'wbthomason/packer.nvim' })

    -- Comment stuff
    use({ 'tpope/vim-commentary' })

    -- Git plugins
    use({ 'airblade/vim-gitgutter' })
    use({ 'rhysd/git-messenger.vim' })

    -- Status/tabline
    use({ 'nvim-lualine/lualine.nvim' })

    -- UI
    use({ "lukas-reineke/indent-blankline.nvim", tag = "v2.20.8" })
    use({ 'nvim-lua/plenary.nvim' })
    use({
        'nvim-lua/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
        },
    })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'preservim/nerdtree' })

    -- Color Theme
    use({ 'morhetz/gruvbox' })
    use({ 'rafikdraoui/couleurs.vim' })
    use({ 'wincent/base16-nvim' })
    use({ 'zenbones-theme/zenbones.nvim', requires = {"rktjmp/lush.nvim"} })
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })

    -- Surround parentheses, brackets, quotes, XML tags, and more
    use({ 'tpope/vim-surround' })

    -- Markdown preview
    use({ 'euclio/vim-markdown-composer', run = 'cargo build --release --locked' })

    -- Spell checking
    use({ 'mateusbraga/vim-spell-pt-br' })

    -- Manage global and project-local settings
    use({
        "folke/neoconf.nvim",
    })

    -- Notes
    use({
        'renerocksai/telekasten.nvim',
        requires = { 'nvim-telescope/telescope.nvim' }
    })

    use({ 'nvimtools/none-ls.nvim' })

    -- LSP
    use({ 'neovim/nvim-lspconfig', opts = { autoformat = false } })
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
    use({ 'nvimdev/lspsaga.nvim' })

    -- LSP servers management
    use({
        "williamboman/mason.nvim",
        requires = {
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        config = function()
            require('mason').setup {
                registries = {
                    'github:mason-org/mason-registry',
                },
            }
        end
    })

    -- Golang
    use({ 'fatih/vim-go', run = ':GoInstallBinaries' })

    -- Zig
    use({ 'ziglang/zig.vim' })

    -- Java
    use({ 'mfussenegger/nvim-jdtls' })
end)
