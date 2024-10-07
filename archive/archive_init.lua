-------- ARCHIVED NEOVIM LUA CODE ------------------

-- july'23 - fully using fzf-lua
{ "junegunn/fzf", build = "./install --bin" }
{ 'junegunn/fzf.vim', config = LoadFZF }

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



----- JOSH DICK ONE DARK COLORSCHEME -----
---- ISSUE: doesnt support highlight groups for noice notifs
LoadOneDarkConfig = function()
    vim.g.onedark_termcolors=256
    vim.g.onedark_terminal_italics=1

    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("Normal", { "bg": { "cterm": "000" } })' })

    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("markdownH1", { "cterm": "underline" })' })
    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("markdownH2", { "cterm": "underline" })' })
    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("markdownH1", { "fg": { "cterm": "196" } })'})
    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("markdownH2", { "fg": { "cterm": "196" } })'})
    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("htmlH2", { "cterm": "underline" })' })
    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("htmlH1", { "cterm": "underline" })' })
    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("htmlH2", { "fg": { "cterm": "196" } })'})
    vim.api.nvim_create_autocmd('ColorScheme',
            { pattern='onedark', command = 'call onedark#extend_highlight("htmlH1", { "fg": { "cterm": "196" } })'})

    vim.cmd.colorscheme('onedark')
    vim.cmd.highlight({'clear','Search'})   -- will set custom search highlight below
    vim.cmd.highlight({'Search','cterm=italic,underline,inverse'})
end

-------------- VIM-MARKDOWN ------------------------
-- lazyvim defintion
{ 'preservim/vim-markdown', enabled = not vim.env.NO_MARK, config = LoadVimMarkdown }

LoadVimMarkdown = function()
    -- plasticboy-md: `ge` command will follow anchors in links (of the form file#anchor or #anchor)
    vim.g.vim_markdown_follow_anchor = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_new_list_item_indent = 0
    vim.g.vim_markdown_edit_url_in = 'tab'
    vim.g.vim_markdown_anchorexpr = "substitute(v:anchor,'-',' ','g')"   -- customize the way to parse an anchor link
end

-- OneDark mods
-- NOTE: vim-markdown uses html*, not markdown*
htmlH1 = { fg = "#FF0000", underline = true }
htmlH3 = { fg = "#ef596f" }, htmlH4 = { fg = "#ef596f" }, htmlH5 = { fg = "#ef596f" }, htmlH6 = { fg = "#ef596f" }
-- mkdInlineURL = { fg = '#61afef', underline = true },


-- LoadTreeSitter code  -----------------------------
-- only disable markdown if vim-markdown plugin is enabled
local disabled_list = {}
if LazyPluginEnabled('vim-markdown') then disabled_list = { "markdown" } end


---- MAPS
vim.keymap.set('n', '<leader>wf', '<cmd>:lua ToggleFoldMethod()<cr>:set foldmethod?<cr>', { desc = "toggle fold method" })

vim.keymap.set('n', '<leader>:', '<cmd>:Commands!<cr>')
vim.keymap.set('n', '<leader>B', '<cmd>:Buffers!<CR>')
vim.keymap.set('n', '<leader><leader>H', '<cmd>:Helptags!<cr>')
vim.keymap.set('n', '<leader><leader>R', '<cmd>:History:<cr>', { desc = "command history" })
vim.keymap.set('n', '<leader>O', '<cmd>:Files!<CR>')
vim.keymap.set('n', '<leader><leader>o', '<cmd>:Files ~<CR>', { desc = 'fzf files on home dir (~)' })
vim.keymap.set('n', '<leader>ex', '<cmd>:RG!<CR>', { desc = "fzf.vim RG! (live grep)" })
vim.keymap.set('n', '<leader>eo', '<cmd>:BLines!<CR>')
vim.keymap.set('n', '<leader>ei', '<cmd>:Lines!<CR>')

vim.keymap.set('n', '<leader>gb', '<cmd>:BCommits<CR>')
vim.keymap.set('n', '<leader>gB', '<cmd>:BCommits!<CR>')
vim.keymap.set('n', '<leader>gm', '<cmd>:Commits<CR>')
vim.keymap.set('n', '<leader>gM', '<cmd>:Commits!<CR>')

vim.keymap.set('n', '<leader>cM', '<cmd>:Maps!<CR>')
vim.keymap.set('n', '<leader>cl', [[:Maps!<cr> space ]])
vim.keymap.set('n', '<leader><leader>c', '<cmd>:Files ~/rams_dot_files/cheatsheets/<cr>')
vim.keymap.set('n', '<leader>cn', '<cmd>:Files $MY_NOTES_DIR<cr>')
vim.keymap.set('n', '<leader>cw', '<cmd>:Files $MY_WORK_DIR<cr>')
