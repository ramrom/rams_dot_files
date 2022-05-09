set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" lua require('neovim-config')


"""" NEOVIM LUA CONFIG

" older neovim versions dont support vim module and other things
if has('nvim-0.5.0')
lua << EOF
if vim.fn.has('nvim-0.7') == 1 then
    if vim.env.VIM_METALS then
        print("activate metals!")

        metals_config = require("metals").bare_config()

        metals_config.settings = {
          showImplicitArguments = true,
          showInferredType = true
        }

        metals_config.init_options.statusBarProvider = "on"

        metals_config.capabilities = capabilities

        vim.cmd([[augroup lsp]])
        vim.cmd([[autocmd!]])
        vim.cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
        vim.cmd([[autocmd FileType java,scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
        vim.cmd([[augroup end]])

        vim.opt.shortmess:remove('F')   -- Ensure audocmd works for filetype
        vim.opt.shortmess:append('c')   -- Avoid showing extra message when using completion

        -- === Basic Completion Settings ===
        -- menu = use a popup menu to show possible completions
        -- menuone = show a menu even if there is only one match
        -- noinsert = do not insert text for a match until user selects one
        -- noselect = do not select a match from the menu automatically
        vim.opt_global.completeopt = { "menu", "menuone", "noinsert", "noselect" }

        -- Enable completions as you type.
        -- let g:completion_enable_auto_popup = 1

        -- for telescope
        -- vim.keymap.set('n', '<leader>fm', '<cmd>Telescope metals commands<cr>')

        -- Debug settings for nvim-dap
        local dap = require("dap")

        dap.configurations.scala = {
          {
            type = "scala",
            request = "launch",
            name = "RunOrTest",
            metals = {
              runType = "runOrTestFile",
              --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
          },
          {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
              runType = "testTarget",
            },
          },
        }

        metals_config.on_attach = function(client, bufnr)
          require("metals").setup_dap()
        end
    else  -- for all other language servers, use lspconfig
        util = require "lspconfig/util"

        -- Golang gopls LSP setup
        require'lspconfig'.gopls.setup{
            cmd = {"gopls", "serve"},
            filetypes = {"go", "gomod", "gotmpl" },
            root_dir = util.root_pattern("go.mod", ".git"),
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
              },
            },
            single_file_support = true
        }
    end

    -- LSP KEYBINDINGS (many from https://github.com/scalameta/nvim-metals/discussions/39)
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    vim.keymap.set("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
    vim.keymap.set("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
    -- vim.keymap.set("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
    -- vim.keymap.set("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
    -- vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    -- vim.keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    -- vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    -- vim.keymap.set("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
    -- vim.keymap.set("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
    -- vim.keymap.set("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
    -- vim.keymap.set("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
    -- vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
    vim.keymap.set("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
    vim.keymap.set("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")
    -- pgar keybindings LSP key bindings
    -- nnoremap <silent> <leader>q   <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
    -- nnoremap <silent> <leader>e   <cmd>lua vim.lsp.diagnostic.open_float()<CR>

    -- Example mappings for usage with nvim-dap. If you don't use that, you can skip these
    --vim.keymap.set("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
    --vim.keymap.set("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
    --vim.keymap.set("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
    --vim.keymap.set("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
    --vim.keymap.set("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
    --vim.keymap.set("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
    --vim.keymap.set("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])
end
EOF
endif
