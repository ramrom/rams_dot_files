---------------------------------------------------------------------------
----------- FIRENVIM SETTINGS -----------------------------------------------
------------------------------------------------------------------------------

-- firenvim binstub - $HOME/.local/share/firenvim/firenvim

---------------------------- PLUGINS --------------------------------------
print("firevim config init")
local lazypath = vim.fn.stdpath("data") .. "/firelazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath, })
end
vim.opt.rtp:prepend(lazypath)

---- ONE DARK PRO: https://github.com/olimorris/onedarkpro.nvim
local LoadOneDarkProConfig = function()
    require("onedarkpro").setup()
    vim.cmd.colorscheme("onedark_dark")
end

---------------------- TREE-SITTER CONFIG -------------------------------
LoadTreeSitter = function()
    require('nvim-treesitter').install('all')  -- NOTE: run this first time vim install, or :TSInstall all

    local is_largefile = function(buf)
        local max_filesize = 20 * 1024 * 1024 -- 20 MB 
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end

    -- TODO: feb'26 - maybe check out https://github.com/Corn207/ts-query-loader.nvim plugin instead
        -- or use https://github.com/xaaha/dev-env/blob/main/nvim/.config/nvim/lua/xaaha/plugins/lsp-nvim-treesitter.lua
    vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(event)
            if vim.bo.filetype == 'notify' then return end
            if vim.bo.filetype == 'noice' then return end
            if vim.bo.filetype == 'fzf' then return end

            if os.time() > 1772860228 + 60*60*24*365 then trynotify("TREESITTER CHECK CSV!", "warn") end -- after ~ mar6-27
            if vim.bo.filetype == 'csv' then return end  -- mar26 - syn highlight colorizes columns, treesitter doesnt

            -- print(vim.treesitter.language.get_lang(event.match) or event.match)


            local buf_num = event.buf
            if is_largefile(buf_num) then 
                local filename = vim.api.nvim_buf_get_name(0)
                print(filename .. " is too large, treesitter bypassed") 
                return
            end

            local ok, _ = pcall(vim.treesitter.start)
            if ok then
                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo[0][0].foldmethod = 'expr'

                -- TODO: skip if filetype = groovy, b/c Jenkinsfiles dont work well
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"


                --------------------- INCREMENTAL SELECTION ----------------------
                -- NOTE: old keymap: `gn` init, `<TAB>` node increment, `<c-k>` node decrement, '<CR>' scope increment
                -- TODO: jan'26 - maybe use flash for it https://github.com/folke/flash.nvim
                vim.keymap.set({ 'x' }, '<leader>d', function()
                    require 'vim.treesitter._select'.select_prev(vim.v.count1)
                end, { desc = 'Select previous node' })

                vim.keymap.set({ 'x' }, '<leader>f', function()
                    require 'vim.treesitter._select'.select_next(vim.v.count1)
                end, { desc = 'Select next node' })

                vim.keymap.set({ "n", "x", "o" }, "<TAB>", function()
                    if vim.treesitter.get_parser(nil, nil, { error = false }) then
                        require("vim.treesitter._select").select_parent(vim.v.count1)
                    else
                        vim.lsp.buf.selection_range(vim.v.count1)
                    end
                end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

                vim.keymap.set({ "n", "x", "o" }, "<C-k>", function()
                    if vim.treesitter.get_parser(nil, nil, { error = false }) then
                        require("vim.treesitter._select").select_child(vim.v.count1)
                    else
                        vim.lsp.buf.selection_range(-vim.v.count1)
                    end
                end, { desc = "Select child treesitter node or inner incremental lsp selections" })

            end
        end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        desc = 'highlight hyperlinks in regular paragraph/text of markdown',
        callback = function()
            vim.cmd.highlight("link mkdInlineURL htmlLink")
            vim.cmd.syntax([[match mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/]])
        end,
    })
end

---------------------- FIRENVIM CONFIG -------------------------------
LoadFireNvim = function()
    vim.g.firenvim_config = {
        globalSettings = { alt = "all" },
        localSettings = {
            [".*"] = {
                cmdline  = "neovim",
                content  = "text",
                priority = 0,
                selector = "textarea",
                -- takeover = "always"
                takeover = "never"
            }
        }
    }
end

require("lazy").setup({
    { 'nvim-treesitter/nvim-treesitter', config = LoadTreeSitter, cond = not vim.env.NO_TREESITTER,
        build = ":TSUpdate", lazy = false },
    { "olimorris/onedarkpro.nvim", lazy = false, config = LoadOneDarkProConfig, priority = 1000 },
    'tpope/vim-surround',
    'tpope/vim-repeat',

    --- fuzzy find
    { 'ibhagwan/fzf-lua', config = LoadFzfLua, dependencies = { 'nvim-tree/nvim-web-devicons' }, event = 'VeryLazy' },

    -- https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    { 'glacambre/firenvim',
        -- cond = not not vim.g.started_by_firenvim,  -- not not makes a nil false value, a non-nil value true
        config = LoadFireNvim,
        build = ":call firenvim#install(0)",
    },
},
{
    -- seperate install location to keep sync for firenvim diff from regular neovim
    root = vim.fn.stdpath("data") .. "/firelazy",
    lockfile = vim.fn.stdpath("config") .. "/firenvim-lazy-lock.json",
})

------------------------- SETTINGS ---------------------------------

vim.api.nvim_create_autocmd('BufEnter', { pattern = 'github.com_*.txt', command = 'set filetype=markdown' })
vim.api.nvim_create_autocmd('BufEnter', { pattern = 'json.parser.online.fr_*.txt', command = 'set filetype=json' })

-------- GENERAL
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

--- FOLDING
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false            -- dont fold everything when opening buffers

-- INDENTING
vim.opt.autoindent = true       -- indent on new line for inner scopes in code
vim.opt.shiftwidth=4            -- use 4 spaces for autoindent (cindent)
vim.opt.tabstop=4               -- space 4 columns when reading a <tab> char in file
vim.opt.softtabstop=4           -- complicated, see docs
vim.opt.expandtab = true        -- use spaces when tab is pressed

vim.opt.listchars = {tab = '»_', trail = '.'}

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


------------------------- MAPPINGS ---------------------------------
vim.g.mapleader = " "

vim.keymap.set("i", "<C-l>", "<Esc>")

vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

------ NAVIGATION
vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")

---- SMART QUITTING
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")

------ SMART WRITING
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>", { desc = "write changes staying in insert"})
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")

------- FZF
-- vim.keymap.set("n", "<leader>o", "<cmd>:Files<CR>")
vim.keymap.set('n', '<leader>o',function() require('fzf-lua').files() end, { desc = "fzf files" })
vim.keymap.set('n', '<leader>cm',function() require('fzf-lua').keymaps() end, { desc = "fzf key mappings" })
vim.keymap.set('n', '<leader>;',function() require('fzf-lua').commands() end, { desc = "fzf vim commands" })
vim.keymap.set('n', '<leader><leader>r',function() require('fzf-lua').command_history() end, { desc = "fzf command history" })
vim.keymap.set('n', '<leader><leader>c',function() require('fzf-lua').files({cwd='~/rams_dot_files/cheatsheets/'}) end,
    { desc = "fzf cheatsheet files" })

------ OTHER
vim.keymap.set('n', '<leader>r', 'q:', { desc = "command line history editor" })
vim.keymap.set("n", "<C-Space>", "<cmd>:Lazy<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")
vim.keymap.set('n', '<leader>gT', [[ <cmd>:execute '%s/\s\+$//e' <cr> ]], { desc = "remove trailing whitespace"})


print("firevim config complete")
