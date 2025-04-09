function setup_java()
    local home = os.getenv('HOME')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

    local config = {
        cmd = {
            'jdtls',
            '-Xmx8g',
            '-XX:+UseG1GC',
            '-XX:+UseStringDeduplication',
            '-data', workspace_dir
        },
        root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
        on_attach = on_attach,
        settings = {
            java = {
                maxConcurrentBuilds = 2,
                autobuild = false,
                edit = {
                    validateAllOpenBuffersOnChanges = false,
                },
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-22",
                            path = home .. "/.asdf/installs/java/openjdk-22.0.1/",
                        },
                        {
                            name = "JavaSE-17",
                            path = home .. "/.asdf/installs/java/openjdk-17/",
                        },
                    }
                },
                jdt = {
                    ls = {
                        lombokSupport = {
                            enable = false,
                        },
                    },
                },
            }
        },
        init_options = {
            bundles = {
                vim.fn.glob(
                    home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar", 1),
            },
        },
    }
    require('jdtls').start_or_attach(config)
end

setup_java()
