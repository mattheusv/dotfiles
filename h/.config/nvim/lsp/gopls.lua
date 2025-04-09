local cmd = { "gopls" }

if os.getenv("GOPLS_REMOTE") == "1" then
    cmd = { "gopls", "-remote", "localhost:8888" }
end

return {
    cmd = cmd,
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            allExperiments = true,
            analyses = {
                unusedparams = true,
                shadow = false,
            },
            gofumpt = true,
            staticcheck = true,
        },
    },
}
