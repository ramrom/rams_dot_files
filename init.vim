set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if exists('g:started_by_firenvim')
source ~/rams_dot_files/.firevimrc
else
source ~/.vimrc

" lua require('neovim-config')


"""" NEOVIM LUA CONFIG

" older neovim versions dont support vim module and other things
" and dont configure the plugins is VIM_NOPLUG is set
if has('nvim-0.5.0') && empty($VIM_NOPLUG)
lua << EOF

-- HELPER METHOD - check is module exists before trying to load it
-- from https://stackoverflow.com/questions/15429236/how-to-check-if-a-module-exists-in-lua
local Lua = {}
function Lua.moduleExists(name)
    if package.loaded[name] then
        return true
    else
        -- Package.Searchers was renamed from Loaders in lua5.2, have support for both
        ---@diagnostic disable-next-line: deprecated
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                -- luacheck: ignore
                -- luacheck complains about package.preload being read-only
                package.preload[name] = loader
                return true
            end
        end
        return false
	end
end


if Lua.moduleExists('gitsigns') then
    require('gitsigns').setup{
        signs = {
            add          = { text = '+' },
            change       = { text = '!' },
            delete       = { text = '_', show_count = true },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        linehl = false,
        numhl = false,
        word_diff = false,
    }
end


if Lua.moduleExists('lualine') then
    require('lualine').setup {
        options = {
            icons_enabled = false,
            {'branch', icon = 'ᛘ'},
            theme = 'onedark',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            -- lualine_b = { { 'branch', icons_enabled = true, {'branch', icon = 'ᛘ'} }, 'diff', 'diagnostics' },
            lualine_c = { { 'filename', file_status = true, path = 1 } },
            lualine_x = {'filetype', 'encoding', 'fileformat'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = {
                {
                    'tabs',
                    mode = 2,
                    max_length = vim.o.columns,

                    fmt = function(name, context)
                        -- Show + if buffer is modified in tab
                        local buflist = vim.fn.tabpagebuflist(context.tabnr)
                        local winnr = vim.fn.tabpagewinnr(context.tabnr)
                        local bufnr = buflist[winnr]
                        local mod = vim.fn.getbufvar(bufnr, '&mod')

                        return name .. (mod == 1 and ' +' or '')
                    end
                }
            },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {
                {
                    'buffers',
                    show_modified_status = true,
                    mode = 4,
                    buffers_color = {
                        inactive = { fg = 'grey', bg = 'black' },
                        active = 'grey',
                    },
                    },
                },
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
    end

if Lua.moduleExists('bufferline') then
    require("bufferline").setup{}
end

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
----------------------- LSP CONFIGS ------------------------------------
------------------------------------------------------------------------
if vim.fn.has('nvim-0.6.1') == 1 then

    -- Toggle function to enable and disable LSP diagnostics(virtual text, underline, sign)
    -- NOTE: https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim - decent plugin to do this granularly
    LSPDiagnosticsEnabled = true

    ToggleLSPdiagnostics = function()
        LSPDiagnosticsEnabled = not LSPDiagnosticsEnabled
        if LSPDiagnosticsEnabled then
            vim.diagnostic.enable()
            print("LSP diagnostics enabled")
        else
            vim.diagnostic.disable()
            print("LSP diagnostics disabled")
        end
    end

    -- hooks if LSP client is running
    if vim.fn.has('nvim-0.8') == 1 then   -- LspAttach only available in 0.8
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                ActivateAutoComplete()
                vim.opt.signcolumn="yes:2" -- static 2 columns, at least one for signify and one for lsp diags
            end,
        })
    end

    ------------------ NVIM-CMP AUTOCOMPLETEL -----------------------------
    ActivateAutoComplete = function()
        if Lua.moduleExists('cmp') then
            local cmp = require 'cmp'
            cmp.setup {
                completion = { autocomplete = false, },   -- dont show autocomplete menu be default
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
                    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
                    -- C-b (back) C-f (forward) for snippet placeholder navigation.
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    -- ['<Tab>'] = cmp.mapping(function(fallback)
                    -- ['<C-n>'] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     elseif luasnip.expand_or_jumpable() then
                    --         luasnip.expand_or_jump()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { 'i', 's' }),
                    -- -- ['<S-Tab>'] = cmp.mapping(function(fallback)
                    -- ['<C-p>'] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif luasnip.jumpable(-1) then
                    --         luasnip.jump(-1)
                    --     else
                    --         fallback()
                    --     end
                    -- end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'cmp_buffer' },
                },
            }
        end
    end

    ---------------------- NVIM-BFQ CONFIG -------------------------------
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

    --------------------- fidget (LSP progress) ------------------
    require"fidget".setup{}


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
            pattern = { "scala", "sbt" },
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
            SetMetalsKeymaps()
        end
    end

    ---------------- RUST ---------------------------
    local on_attach = function(client)
        require'completion'.on_attach(client)
    end

    require'lspconfig'.rust_analyzer.setup({
        on_attach=on_attach,
        -- autostart = false,   -- dont automatically start
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true
                },
            }
        }
    })

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

    ------------- Java -------------------------------------

    -- TODO: prolly use jdtls

    ------------- Kotlin-------------------------------------
    -- https://github.com/fwcd/kotlin-language-server

    require'lspconfig'.kotlin_language_server.setup{
        cmd = { "kotlin-language-server" },
        filetypes = { "kotlin", "kt" },
        root_dir = util.root_pattern("settings.gradle")
    }

    ------------ BASH/SHELL bashls LSP ----------------------
    -- https://github.com/mads-hartmann/bash-language-server

    -- require'lspconfig'.bashls.setup{
    --     cmd = {"bash-language-server", "start"},
    --     cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
    --     filetypes = { "sh" },
    --     root_dir = util.find_git_ancestor,
    --     single_file_support = true
    -- }


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
    vim.keymap.set("n", "glc", "<cmd>call ClearLspLog()<CR>")
    vim.keymap.set("n", "gli", "<cmd>LspInfo<CR>")
    vim.keymap.set("n", "glsp", "<cmd>LspStop<CR>")
    vim.keymap.set("n", "glst", "<cmd>LspStart<CR>")

    -- this is called on_attach in the metals lsp config section
    SetMetalsKeymaps = function()
        vim.keymap.set("n", "gjd", "<cmd>MetalsGotoSuperMethod<CR>")
        vim.keymap.set("n", "gll", "<cmd>MetalsToggleLogs<CR>")
        vim.keymap.set("n", "gli", "<cmd>MetalsInfo<CR>")
        vim.keymap.set("n", "glst", "<cmd>MetalsStartServer<CR>")
        vim.keymap.set("n", "glo", "<cmd>MetalsOrganizeImports<CR>")
        vim.keymap.set("n", "gld", "<cmd>MetalsShowSemanticdbDetailed<CR>")
        -- NOTE: in the tree window hit 'r' to navigate to that item
        vim.keymap.set("n", "glt", '<cmd>lua require"metals.tvp".toggle_tree_view()<CR>')
        vim.keymap.set("n", "glr", '<cmd>lua require"metals.tvp".reveal_in_tree()<CR>')
    end

    vim.keymap.set("n", "gjc", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
    vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    vim.keymap.set("n", "gs", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
    vim.keymap.set("n", "gy", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    -- vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    -- vim.keymap.set("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
    vim.keymap.set("n", "gwd", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
    vim.keymap.set("n", "gwe", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
    vim.keymap.set("n", "gww", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
    vim.keymap.set("n", "gwb", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
    vim.keymap.set("n", "gwt", "<cmd>lua ToggleLSPdiagnostics()<CR>") -- buffer diagnostics only
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

-- vim.opt.termguicolors = true
-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

-- vim.opt.termguicolors = true
-- vim.cmd [[highlight IndentBlanklineIndent1 guibg=red gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guibg=green gui=nocombine]]

require("indent_blankline").setup {
    show_end_of_line = true,
    show_current_context = true,
    show_current_context_start = true,

    -- show_end_of_line = true,
    -- char = "",
    -- char_highlight_list = {
    --     "IndentBlanklineIndent1",
    --     "IndentBlanklineIndent2",
    -- },
    -- space_char_highlight_list = {
    --     "IndentBlanklineIndent1",
    --     "IndentBlanklineIndent2",
    -- },
    show_trailing_blankline_indent = false,
    --char_highlight_list = {
    --    "IndentBlanklineIndent1",
    --    "IndentBlanklineIndent2",
    --    "IndentBlanklineIndent3",
    --    "IndentBlanklineIndent4",
    --    "IndentBlanklineIndent5",
    --    "IndentBlanklineIndent6",
    --},
}

EOF
endif

endif
