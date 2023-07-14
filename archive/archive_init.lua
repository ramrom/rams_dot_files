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

---- MAPS
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
