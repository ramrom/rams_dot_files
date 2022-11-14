set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" lua require('neovim-config')


"""" NEOVIM LUA CONFIG
if has('nvim-0.5.0')    " older neovim versions dont support vim module and other things
lua << EOF

-------------------------------------------------------------------------
---------------------- TREE-SITTER CONFIG -------------------------------
-------------------------------------------------------------------------
if vim.fn.has('nvim-0.7') == 1 then  -- needs 0.7
    require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        ensure_installed = "all",

        -- ignore_install = { "javascript", "rust" }, -- List of parsers to ignore installing (or "all")

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- oct2022: M1 macs have known issue for phpdoc: https://github.com/claytonrcarter/tree-sitter-phpdoc/issues/15
            -- see also https://www.reddit.com/r/neovim/comments/u3hj8p/treesitter_cant_install_phpdoc_on_m1_mac/
        ignore_install = { "phpdoc" },

        highlight = {
            -- `false` will disable the whole extension
             enable = true,

            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)
            -- list of language that will be disabled
            disable = { "markdown" },

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'gn',
                node_incremental = '<TAB>',
                node_decremental = '<S-TAB>',
                scope_incremental = '<CR>',
            },
        },
    }

    vim.opt.foldmethod='expr'
    vim.opt.foldexpr='nvim_treesitter#foldexpr()'
end

-------------------------------------------------------------------------
---------------------- NVIM-BFQ CONFIG -------------------------------
-------------------------------------------------------------------------
require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        -- border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
        should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
            elseif bufname:match('^fugitive://') then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end
    },
})

-------------------------------------------------------------------------
----------------------- LSP CONFIGS ------------------------------------
------------------------------------------------------------------------
if vim.fn.has('nvim-0.6.1') == 1 then


    ------------------- SCALA METALS -----------------------------
    if vim.fn.has('nvim-0.7') == 1 then
        metals_config = require("metals").bare_config()

        metals_config.settings = {
          showImplicitArguments = true,
          showImplicitConversionsAndClasses = true,
          showInferredType = true
        }

        metals_config.init_options.statusBarProvider = "on"

        metals_config.capabilities = capabilities

        -- Autocmd that will actually be in charging of starting the whole thing
        vim.api.nvim_create_autocmd("FileType", {
            -- NOTE: You may or may not want java included here. You will need it if you
            -- want basic Java support but it may also conflict if you are using
            -- something like nvim-jdtls which also works on a java filetype autocmd.
            pattern = { "scala", "sbt", "java" },
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        })

        vim.opt.shortmess:remove('F')   -- Ensure autocmd works for filetype
        vim.opt.shortmess:append('c')   -- Avoid showing extra message when using completion

        -- === Basic Completion Settings ===
        -- menu = use a popup menu to show possible completions
        -- menuone = show a menu even if there is only one match
        -- noinsert = do not insert text for a match until user selects one
        -- noselect = do not select a match from the menu automatically
        vim.opt_global.completeopt = { "menu", "menuone", "noinsert", "noselect" }

        -- Enable completions as you type.
        -- let g:completion_enable_auto_popup = 1
        -- vim.opt.completion_enable_auto_popup=1

        -- for telescope
        -- vim.keymap.set('n', '<leader>fm', '<cmd>Telescope metals commands<cr>')


        ------ METALS DAP ------------------
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
    end

    ------------------- LSP-Configs -----------------------------
    util = require "lspconfig/util"

    ------------ GOLANG gopls LSP ----------------------
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

    -- golang DAP
    -- lua require('dap-go').setup()

    ------------ BASH/SHELL bashls LSP ----------------------
    -- https://github.com/mads-hartmann/bash-language-server
    require'lspconfig'.bashls.setup{
        cmd = {"bash-language-server", "start"},
        cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
        filetypes = { "sh" },
        root_dir = util.find_git_ancestor,
        single_file_support = true
    }


    ----------- COMMON LSP KEYBINDINGS --------------------------------------------
    -- many taken from https://github.com/scalameta/nvim-metals/discussions/39

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')

    -- `tab split` will open in new tab, default is open in current tab, no opt for this natively
    -- see https://github.com/scalameta/nvim-metals/discussions/381
    vim.keymap.set("n", "gd", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>")
    vim.keymap.set("n", "gD", "<cmd>tab split | lua vim.lsp.buf.type_definition()<CR>")

    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    vim.keymap.set("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
    vim.keymap.set("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
    vim.keymap.set("n", "gll", "<cmd>LspLog<CR>")
    vim.keymap.set("n", "gli", "<cmd>LspInfo<CR>")
    vim.keymap.set("n", "glsp", "<cmd>LspStop<CR>")
    vim.keymap.set("n", "glst", "<cmd>LspStart<CR>")
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
            vim.keymap.set("n", "gjd", "<cmd>MetalsGotoSuperMethod<CR>")
            vim.keymap.set("n", "gll", "<cmd>MetalsToggleLogs<CR>")
            vim.keymap.set("n", "gli", "<cmd>MetalsInfo<CR>")
            vim.keymap.set("n", "glst", "<cmd>MetalsStartServer<CR>")
            vim.keymap.set("n", "glo", "<cmd>MetalsOrganizeImports<CR>")
            vim.keymap.set("n", "gld", "<cmd>MetalsShowSemanticdbDetailed<CR>")
            -- NOTE: in the tree window hit 'r' to navigate to that item
            vim.keymap.set("n", "glt", '<cmd>lua require"metals.tvp".toggle_tree_view()<CR>')
            vim.keymap.set("n", "glr", '<cmd>lua require"metals.tvp".reveal_in_tree()<CR>')
        end,
        group = vim.api.nvim_create_augroup("nvim-metals-maps", { clear = true })
    })
    vim.keymap.set("n", "gjc", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
    vim.keymap.set("n", "gja", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    vim.keymap.set("n", "gs", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
    vim.keymap.set("n", "gy", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    -- vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    -- vim.keymap.set("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
    vim.keymap.set("n", "gwd", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
    vim.keymap.set("n", "gwe", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
    vim.keymap.set("n", "gww", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
    vim.keymap.set("n", "gwb", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
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

-------------------------------------------------------------------------
----------------------- INDENT-BLANKLINE ------------------------------------
------------------------------------------------------------------------
vim.opt.list = true

require("indent_blankline").setup {
    show_end_of_line = true,
}

EOF

endif
