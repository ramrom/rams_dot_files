-- NEOVIM CONFIG

-- ISSUES
    -- GH-line not working

--------------------------------------------------------------------------------------------------------
-------------------------------- SETTINGS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.opt.backup = false                 -- no backup files
vim.opt.writebackup = false            -- only in case you don't want a backup file while editing
vim.opt.swapfile = false               -- no swap files

vim.opt.mouse=null                     -- turn off all mouse support by default

--- MAIN
vim.opt.autoread = true                         -- reload file's buffer if file was changed externally
vim.opt.splitbelow = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.splitright = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.wildmenu = true                         -- display command line's tab complete options as menu
vim.opt.wildmode = {'longest', 'list', 'full'}  -- complete longest common, list all matches, complete till next full match
vim.opt.wrap = true                             -- wrap lines longer than width to next line
vim.opt.linebreak = true                        -- avoid wrapping line in middle of a word
vim.opt.scrolloff = 1                           -- always show at least one line above or below the cursor
vim.opt.showcmd = true                          -- show commands i'm process of typing in status bar
vim.opt.number = true                           -- line numbers
vim.opt.updatetime = 1000                       -- default is 4000, used for CursorHold autocmds, swap file writing
vim.opt.backspace= {'indent' ,'eol', 'start'}   -- backspace like most wordprocessors in insert mode
vim.opt.display:append('lastline')              -- display lastline even if its super long
vim.opt.formatoptions:append('j')               -- Delete comment character when joining commented lines

---- SERACHING
vim.opt.hlsearch = true                         -- highlight search
vim.cmd.highlight({'Search','cterm=italic,underline,inverse'})
vim.opt.incsearch = true               -- searching as you type (before hitting enter)
vim.opt.ignorecase = true              -- case-insensitive searches
vim.opt.smartcase = true               -- with ignorecase, search with all lowercase means INsensitive, any uppercase means sensitive

--- FOLDING
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false            -- dont fold everything when opening buffers

-- INDENTING
vim.opt.autoindent = true       -- indent on new line for inner scopes in code
vim.opt.shiftwidth=4            -- use 4 spaces for autoindent (cindent)
vim.opt.tabstop=4               -- space 4 columns when reading a <tab> char in file
vim.opt.softtabstop=4           -- complicated, see docs
vim.opt.expandtab = true        -- use spaces when tab is pressed

--- DEFAULT STATUS LINE
vim.opt.ls=2                    -- line status, two lines for status and command
vim.opt.statusline=[[ %F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\ ]]


--- TRAILING SPACES
vim.opt.list = true
vim.opt.listchars = {tab = '»_', trail = '.'}
vim.cmd.highlight('WhiteSpace', 'ctermfg=8 guifg=DimGrey')

-- use ripgrep for default vi grep
vim.opt.grepprg='rg --vimgrep --follow'

-- layout of files and dir in netrw file explorer
vim.g.netrw_liststyle = 3

-- for jsonc format, which supports commenting, this will highlight comments
-- #FIXME may'23: not working, code in .vimrc not working either
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'json', callback = function() vim.cmd.syntax([[match Comment +\/\/.\+$+]]) end
})

-- any file name starting with Jenkinsfile should be groovy
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = 'Jenkinsfile*', command = 'set filetype=groovy' })

-- disable autocommenting on o and O in normal
vim.api.nvim_create_autocmd('FileType', { pattern = '*', command ='setlocal formatoptions-=o' })

--------------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
-- vim.api.nvim_create_user_command(
--     'SilentRedraw',
--     vim.execute(':silent !'.<q-args> | execute ':redraw!')
-- )

-- if there is one tab, move forward buffer, otherwise forward tabs
TabBufNavForward = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 then vim.cmd(':bn!') else vim.cmd(':tabn') end
end

-- if there is one tab, move back buffer, otherwise back tabs
TabBufNavBackward = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 then vim.cmd(':bp!') else vim.cmd(':tabprevious') end
end

-- close tabs and windows if more than one of either, otherwise closes buffers until one left and then quit vim
TabBufQuit = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 and #tabinfo[1]['windows'] == 1 then
        if #vim.fn.getbufinfo({buflisted = 1}) == 1 then vim.cmd(':q') else vim.cmd(':bd') end
    else
        vim.cmd(':q')
    end
end

-- cycle between line 80, 120, and no colorcolumn
CycleColorColumn = function()
    if vim.o.colorcolumn == "121" then vim.o.colorcolumn = "81"
    elseif vim.o.colorcolumn == '81' then vim.o.colorcolumn = ''
    else vim.o.colorcolumn = '121' end
end

SaveDefinedSession = function()
    if vim.fn.exists(vim.g.DefinedSessionName) == 0 then
        vim.opt.sessionoptions:append('globals')    -- mksession wont save global vars by default
        vim.cmd(":mksession! " .. vim.g.DefinedSessionName)
        print("Saved session: ",vim.g.DefinedSessionName)
    else
        vim.cmd(":mksession! ./MyCurrentVimSession.vim")
        print("NO DEFINED SESSION NAME!, Saved to ./MyCurrentVimSession.vim")
    end
end

ToggleFoldMethod = function()
    if vim.o.foldmethod == "indent" then
        vim.o.foldmethod="expr"
        vim.o.foldexpr="nvim_treesitter#foldexpr()"
    else
        vim.o.foldmethod="indent"
        vim.o.foldexpr=""
    end
end

ToggleGitSignsHighlight = function()
    vim.cmd(':Gitsigns toggle_linehl')
    vim.cmd(':Gitsigns toggle_word_diff')
end

ClearLspLog = function()
    -- TODO: this hardcoded path is for OSX, on ubuntu it's diff path, find programatic way to find location
    -- also metals on osx is diff path
    vim.cmd(':SilentRedraw cat /dev/null > ~/.local/state/nvim/lsp.log')
    vim.cmd(':SilentRedraw cat /dev/null > .metals/metals.log')
end

vim.api.nvim_create_user_command(
    'SilentRedraw',
    [[execute ':silent !'.<q-args> | execute ':redraw!' ]],
    {bang = true, nargs = "*" }
)

-- lazy.vim, if enabled = true module exists, and if cond = false it's not loaded and requiring will fail
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

--------------------------------------------------------------------------------------------------------
-------------------------------- MAPS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.g.mapleader = " "

------ WINDOW RESIZE/MOVE/CREATE
local default_opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Left>", ":vertical resize +1<CR>", default_opts)
vim.keymap.set("n", "<Right>", ":vertical resize -1<CR>", default_opts)
vim.keymap.set("n", "<Up>", ":resize -1<CR>", default_opts)
vim.keymap.set("n", "<Down>", ":resize +1<CR>", default_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set('n', '<leader>v', ':vsplit<CR><leader>w')
vim.keymap.set('n', '<leader>h', ':split<CR><leader>w')

------ TAB MOVE/NAV/CREATE
vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)
vim.keymap.set("n", "<leader>m", ":tabm<Space>")
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")
vim.keymap.set("n", "<leader>z", "<cmd>:tabnew %<CR>")
vim.keymap.set("n", "gb", "<cmd>:tabprevious<CR>")

---- SMART QUITTING
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")

------ SMART WRITING
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>", { desc = "write changes staying in insert"})
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")
vim.keymap.set('n', "<leader>S", SaveDefinedSession)

vim.keymap.set("i", "<C-l>", "<Esc>")
vim.keymap.set({'n', 'x'}, '<leader>k', '%', { desc = "go to matching pair" })
vim.keymap.set("n", "<leader>.", "<cmd>:@:<CR>", { desc = "repeat last command" })
vim.keymap.set("n", "<leader>e", "<cmd>:Explore<CR>")

---- COPY/PASTE to clipboard
vim.keymap.set({"n","v"}, "<leader>y", [["+y]])
vim.keymap.set({"n","v"}, "<leader>p", [["+p]])
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")

--------- FZF STUFF
vim.keymap.set('n', '<leader>;', '<cmd>:Commands<cr>')
vim.keymap.set('n', '<leader><leader>h', '<cmd>:Helptags!<cr>')
vim.keymap.set('n', '<leader>r', '<cmd>:History:<cr>', { desc = "command history" })
vim.keymap.set('n', '<leader>o', '<cmd>:Files<CR>')
vim.keymap.set('n', '<leader>O', '<cmd>:Files!<CR>')
vim.keymap.set('n', '<leader>b', '<cmd>:Buffers<CR>')
vim.keymap.set('n', '<leader>B', '<cmd>:Buffers!<CR>')
vim.keymap.set('n', '<leader>x', '<cmd>:Rg<CR>')
vim.keymap.set('n', '<leader>X', '<cmd>:Rg!<CR>')
vim.keymap.set('n', '<leader>i', '<cmd>:FZFMru<CR>')
vim.keymap.set('n', '<leader>l', '<cmd>:Lines<CR>')
vim.keymap.set('n', '<leader>L', '<cmd>:Lines!<CR>')

--------- GIT STUFF
vim.keymap.set('n', '<leader><leader>g', '<cmd>:G<CR>')
vim.keymap.set('n', '<leader>gd', '<cmd>:tab Gvdiffsplit<cr>', {desc = "diff from HEAD"})
vim.keymap.set('n', '<leader>gD', '<cmd>:tab Gvdiffsplit master<cr>', {desc = "diff from master branch"})
vim.keymap.set('n', '<leader>g<c-d>', '<cmd>:tab Gvdiffsplit HEAD^<cr>', {desc = "diff since last commit"})
vim.keymap.set('n', '<leader>gb', '<cmd>:BCommits<CR>')
vim.keymap.set('n', '<leader>gB', '<cmd>:BCommits!<CR>')
vim.keymap.set('n', '<leader>gc', '<cmd>:Commits<CR>')
vim.keymap.set('n', '<leader>gC', '<cmd>:Commits!<CR>')
vim.keymap.set('n', '<leader>gs', '<cmd>:Gitsigns toggle_signs<cr>')
vim.keymap.set('n', '<leader>gh', '<cmd>:lua ToggleGitSignsHighlight()<cr>')

vim.keymap.set('n', '<leader>N', '<cmd>:NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>:NvimTreeFindFileToggle<CR>')

vim.keymap.set('n', '<leader>cc', [[:Maps!<cr> space ]])
vim.keymap.set('n', '<leader>cm', '<cmd>:Maps!<CR>')
vim.keymap.set('n', '<leader>cg', '<cmd>:map g<CR>')
vim.keymap.set('n', '<leader><leader>c', '<cmd>:Files ~/rams_dot_files/cheatsheets/<cr>')
vim.keymap.set('n', '<leader>cl', '<cmd>:Files $MY_NOTES_DIR<cr>')
vim.keymap.set('n', '<leader>cw', '<cmd>:Files $MY_WORK_DIR<cr>')
vim.keymap.set('n', '<leader>cj', '<cmd>:tabnew $MY_WORK_TODO<cr>')
vim.keymap.set('n', '<leader>cA', '<cmd>:vsplit ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>ca', '<cmd>:tabnew ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>co', '<cmd>:Files ~<cr>')

vim.keymap.set('n', '<leader>gi', '<cmd>:IndentBlanklineToggle<cr>')
vim.keymap.set('n', '<leader>gm', '<cmd>:MarkdownPreviewToggle<cr>')
vim.keymap.set('n', '<leader>gT', [[ <cmd>:execute '%s/\s\+$//e' <cr> ]], { desc = "remove trailing whitespace"})
vim.keymap.set('n', '<leader>gn', '<cmd>:set number!<cr>')
vim.keymap.set('n', '<leader>gf', '<cmd>:lua ToggleFoldMethod()<cr>:set foldmethod?<cr>')
vim.keymap.set('n', '<leader>go', CycleColorColumn)
vim.keymap.set('n', [[<C-\>]], ':tab split<CR>:exec("tag ".expand("<cword>"))<CR>', {desc =" open a tag in a new tab"})

vim.api.nvim_create_autocmd(
    "Filetype",
    { pattern = 'markdown',
      callback = function()
        vim.keymap.set('n', '<leader>gg', [[<cmd>:w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>]])
      end,
})

-- Quickly switch between up to 9 vimtabs
for i=0,9,1 do vim.keymap.set('n',"g"..i,"<cmd>:tabn "..i.."<CR>") end

----------------------------------------------------------------------------------------------------------
---------------------------------- PLUGIN CONFIG ----------------------------------------------------------
------------------------------------- -------------------------------------------------------------------

----- ONE DARK COLORSCHEME -----
LoadOneDarkConfig = function()
    vim.g.onedark_termcolors=256
    vim.g.onedark_terminal_italics=1
    vim.cmd('autocmd ColorScheme onedark call onedark#extend_highlight("Normal", { "bg": { "cterm": "000" } })')
    vim.cmd.colorscheme('onedark')
    vim.cmd.highlight({'clear','Search'})   -- will set custom search highlight below
end


----------------------------------- FZF -------------------------------------------------------
LoadFZF = function()
    -- default implementation of Rg greps over filename, this will just do contents
        -- see https://github.com/junegunn/fzf.vim/issues/714
    vim.api.nvim_create_user_command( 'Rg',
        [[command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0) ]],
          { bang = true, nargs = '*' }
    )
end

-- TODO: above ugly, try to get below to work
    -- https://www.reddit.com/r/neovim/comments/105zsco/help_with_converting_a_vimscript_command_to_lua/

-- local function vim_grep(qargs, bang)
--   local query = '""'
--   if qargs ~= nil then
--     query = vim.fn.shellescape(qargs)
--   end

--   local sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' .. query
--   vim.call('fzf#vim#grep', sh, 1, vim.call('fzf#vim#with_preview', 'right:50%', 'ctrl-/'), bang)
-- end

-- vim.api.nvim_create_user_command('Rg',
--     function(arg) vim_grep(arg.qargs, arg.bang) end,
--     { bang = true, nargs = '*' }
-- )

----------------------------- FZF MRU --------------------------------------------------
LoadFzfMRU = function()
    vim.g.fzf_mru_no_sort = 1
end

----------------------------- VIM-MARKDOWN --------------------------------------------------
LoadVimMarkdown = function()
    -- plasticboy-md: `ge` command will follow anchors in links (of the form file#anchor or #anchor)
    vim.g.vim_markdown_follow_anchor = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_new_list_item_indent = 0
    vim.g.vim_markdown_edit_url_in = 'tab'
    vim.g.vim_markdown_anchorexpr = "substitute(v:anchor,'-',' ','g')"   -- customize the way to parse an anchor link
end

----------------------------- GH-line(github line) --------------------------------------------------
LoadGHLine = function()
    vim.g.gh_line_map_default = 0
    vim.g.gh_line_blame_map_default = 1
    vim.g.gh_line_map = '<leader>wh'
    vim.g.gh_line_blame_map = '<leader>wb'
    vim.g.gh_repo_map = '<leader>wo'
    vim.g.gh_open_command = 'fn() { echo "$@" | pbcopy; }; fn '
end

---------------------------------- GIT SIGNS ----------------------------------------------
LoadGitSigns = function()
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

--------------------------------- LUALINE -------------------------------------------------------
LoadLuaLine = function()
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

---------------------- TREE-SITTER CONFIG -------------------------------
LoadTreeSitter = function()
    require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",   -- A list of parser names, or "all"
        sync_install = false,       -- Install parsers synchronously (only applied to `ensure_installed`)

        -- oct2022: M1 macs have known issue for phpdoc: https://github.com/claytonrcarter/tree-sitter-phpdoc/issues/15
            -- see also https://www.reddit.com/r/neovim/comments/u3hj8p/treesitter_cant_install_phpdoc_on_m1_mac/
        ignore_install = { "phpdoc" },
        highlight = {
             enable = true,     -- `false` will disable the whole extension
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
        indent = { enable = true },
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

------------------------- indent blankline -----------------------------------------------
LoadIndentBlankLine = function()
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
    vim.g.indent_blankline_enabled=0
end

--------------------------------------------------------------------------------------------------------
-------------------------------- LSP CONFIG ----------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
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

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        ActivateAutoComplete()
        SetLSPKeymaps()
        vim.opt.signcolumn="yes:2" -- static 2 columns, at least one for signify and one for lsp diags
    end,
})

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

---------------- BFQ ---------------------------------------
LoadBQF = function()
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
end

------------------- SCALA METALS -----------------------------
LoadScalaMetals = function()
    metals_config = require("metals").bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      showInferredType = true
    }

    metals_config.init_options.statusBarProvider = "on"

    metals_config.capabilities = capabilities
    -- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Autocmd that will actually be in charging of starting the whole thing
    vim.api.nvim_create_autocmd("FileType", {
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

    -- for telescope
    -- vim.keymap.set('n', '<leader>fm', '<cmd>Telescope metals commands<cr>')

    metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
        SetMetalsKeymaps()
    end
end

------------------------ DAP ------------------
LoadDAP = function()
    local dap = require("dap")
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            runType = "runOrTestFile",
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
end

---------------- RUST ---------------------------
LoadRustLSP = function()
    local rust_on_attach = function(client)
        require'completion'.rust_on_attach(client)
    end

    require'lspconfig'.rust_analyzer.setup({
        on_attach=rust_on_attach,
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
end

------------ GOLANG gopls LSP ----------------------
LoadGolangLSP = function()
    require'lspconfig'.gopls.setup{
        cmd = {"gopls", "serve"},
        filetypes = {"go", "gomod", "gotmpl" },
        root_dir = require("lspconfig/util").root_pattern("go.mod", ".git"),
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
end

------------- Kotlin-------------------------------------
-- https://github.com/fwcd/kotlin-language-server

LoadKotlinLSP = function()
    require'lspconfig'.kotlin_language_server.setup{
        cmd = { "kotlin-language-server" },
        filetypes = { "kotlin", "kt" },
        root_dir = require("lspconfig/util").root_pattern("settings.gradle")
    }
end

------------ BASH/SHELL bashls LSP ----------------------
-- https://github.com/mads-hartmann/bash-language-server

-- require'lspconfig'.bashls.setup{
--     cmd = {"bash-language-server", "start"},
--     cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
--     filetypes = { "sh" },
--     root_dir = util.find_git_ancestor,
--     single_file_support = true
-- }

LoadLSPConfig = function()
    LoadRustLSP()
    LoadGolangLSP()
    LoadKotlinLSP()
end


----------- LSP KEYBINDINGS --------------------------------------------
-- many taken from https://github.com/scalameta/nvim-metals/discussions/39
SetLSPKeymaps = function()
    vim.keymap.set('n', 'K', vim.lsp.buf.hover)

    -- `tab split` will open in new tab, default is open in current tab, no opt for this natively
        -- see https://github.com/scalameta/nvim-metals/discussions/381
    vim.keymap.set("n", "gd", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>")
    vim.keymap.set("n", "gD", "<cmd>tab split | lua vim.lsp.buf.type_definition()<CR>")

    vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
    vim.keymap.set("n", "gr", vim.lsp.buf.references)
    vim.keymap.set("n", "gds", vim.lsp.buf.document_symbol)
    vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol)
    vim.keymap.set("n", "gll", "<cmd>LspLog<CR>")
    vim.keymap.set("n", "glc", ClearLspLog)
    vim.keymap.set("n", "gli", "<cmd>LspInfo<CR>")
    vim.keymap.set("n", "glsp", "<cmd>LspStop<CR>")
    vim.keymap.set("n", "glst", "<cmd>LspStart<CR>")

    vim.keymap.set("n", "gjc", vim.lsp.codelens.run)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help)
    vim.keymap.set("n", "gy", vim.lsp.buf.formatting)
    vim.keymap.set("n", "gR", vim.lsp.buf.rename)
    vim.keymap.set("n", "gwd", vim.diagnostic.setqflist) -- all workspace diagnostics
    vim.keymap.set("n", "gwe", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
    vim.keymap.set("n", "gww", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
    vim.keymap.set("n", "gwb", vim.diagnostic.setloclist) -- buffer diagnostics only
    vim.keymap.set("n", "gwt", ToggleLSPdiagnostics) -- buffer diagnostics only
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
    -- vim.keymap.set("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
end

--------------------------------------------------------------------------------------------------------
-------------------------------- PLUGINS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- print(lazypath)
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath, })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { 'nvim-lualine/lualine.nvim', config = LoadLuaLine },
    { 'nvim-tree/nvim-tree.lua', config = function() require("nvim-tree").setup() end },
    'nvim-tree/nvim-web-devicons',
    { 'joshdick/onedark.vim', init = LoadOneDarkConfig, lazy=false, priority = 1000 },
    -- { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { 'nvim-treesitter/nvim-treesitter', config = LoadTreeSitter,
        build = function() require("nvim-treesitter.install").update({ with_sync = true }) end },
    'nvim-lua/plenary.nvim',
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'tpope/vim-repeat',

    --- GIT
    'tpope/vim-fugitive',
    { 'ruanyl/vim-gh-line', config = LoadGHLine },       -- generate github url links from current file
    { 'lewis6991/gitsigns.nvim', config = LoadGitSigns },

    --- fuzzy find
    { 'junegunn/fzf', run = ":call fzf#install()" },
    { 'junegunn/fzf.vim', config = LoadFZF },
    { 'pbogut/fzf-mru.vim', config = LoadFzfMRU },       -- fzf.vim is missing a most recently used file search

    -- MARKDOWN
    { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end },
    { 'preservim/vim-markdown', config = LoadVimMarkdown },

    ----- LSP STUFF
    { 'neovim/nvim-lspconfig', config = LoadLSPConfig },
    { 'scalameta/nvim-metals',
        config = LoadScalaMetals, ft = { 'scala', 'sbt' }, dependencies = { "nvim-lua/plenary.nvim" } },
    { 'kevinhwang91/nvim-bqf', config = LoadBQF, ft = 'qf' },
    { 'j-hui/fidget.nvim', config = function() require"fidget".setup{} end },
    'hrsh7th/nvim-cmp',
    { 'hrsh7th/cmp-nvim-lsp', dependencies = { 'hrsh7th/nvim-cmp' } }, -- LSP completions
    { 'hrsh7th/cmp-buffer', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'hrsh7th/cmp-path', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'mfussenegger/nvim-dap', config = LoadDAP },
    -- 'leoluz/nvim-dap-go',

    'glacambre/firenvim',
        cond = not not vim.g.started_by_firenvim,  -- not not makes a nil false value, a non-nil value true
        build = function()
            require("lazy").load({ plugins = "firenvim", wait = true })
            vim.fn["firenvim#install"](0)
        end,

    { 'lukas-reineke/indent-blankline.nvim', config = LoadIndentBlankLine },
    'chrisbra/unicode.vim',     -- unicode helper
    'godlygeek/tabular',
})
