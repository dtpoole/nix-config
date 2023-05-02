local g = vim.g
local opt = vim.opt

function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end


-- function InsertTabWrapper()
--     local col = vim.fn.col('.') - 1
--     if not col or not string.match(vim.fn.getline('.')[col - 1], '\k') then
--         return "<tab>"
--     else
--         return "<c-p>"
--     end
-- end

function Preserve(command)
    local save = vim.fn.winsaveview()
    --vim.execute(command)
    vim.api.nvim_command(command)
    vim.fn.winrestview(save)
end

vim.cmd([[command! TrimTrailingWhitespace lua Preserve("%s/\\s\\+$//e")]])
Map('n', '_$', ':TrimTrailingWhitespace<CR>')

vim.cmd([[command! FormatFile lua Preserve("normal gg=G")]])
Map('n', '_=', ':FormatFile<CR>')






-- Editor
g.mapleader = ','

Map('i', 'jj', '<Esc>')
--map('t', 'jj', '<C-\><C-n>', {noremap = true})

opt.linebreak = true

-- Tabs
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.cursorline = true
opt.showmatch = true     -- set show matching parenthesis

-- Searching
opt.ignorecase = true
opt.smartcase = true

opt.wildignore = '*.swp,*.bak,*.pyc,*.class,.svn,.git'

opt.title = true
opt.visualbell = true

opt.splitright = true
opt.splitbelow = true

opt.pastetoggle = '<F2>'

opt.nrformats = ''

opt.listchars = {eol = '↲', tab = '▸ ', trail = '·'}

-- Tab completion
opt.wildmode = 'list:longest,list:full'
opt.complete = '.,w,t'



-- Windows / Splits
-- ctrl-jklm  changes to that split
Map('n', '<c-j>', '<c-w><c-j>')
Map('n', '<c-k>', '<c-w><c-k>')
Map('n', '<c-l>', '<c-w><c-l>')
Map('n', '<c-h>', '<c-w><c-h>')


-- Map("n", "<C-Up>", ":resize -2<CR>")
-- Map("n", "<C-Down>", ":resize +2<CR>")
-- Map("n", "<C-Left>", ":vertical resize -2<CR>")
-- Map("n", "<C-Right>", ":vertical resize +2<CR>")



Map('n', '<leader>/', ':nohlsearch<CR>')

-- switch buffers quickly
Map('n', '<leader><leader>', '<c-^>')
Map('n', '<c-g>', ':bn<CR>')


-- " reselect visual block after indent/outdent
-- vnoremap < <gv
-- vnoremap > >gv

-- improve up/down movement on wrapped lines
Map('n', 'j', 'gj')
Map('n', 'k', 'gk')

-- " Use Q for formatting the current paragraph (or selection)
-- vmap Q gq
-- nmap Q gqap

-- --cmap w!! w !sudo tee % >/dev/null

Map('n', '<leader>l', ':set list!<CR>')
Map('n', '<leader>n', ':set number!<CR>')


--nmap <silent> <leader>v :vsplit $MYVIMRC<CR>
Map('n', '<leader>v', ':vsplit $MYVIMRC<CR>')



-- netrw
Map('', '<C-d>', ':Lexplore<CR>')
g['g:netrw_liststyle'] = 3
g['g:netrw_winsize'] = 35
g['g:netrw_browse_split'] = 4
g['g:netrw_altv'] = 1

-- fzf
opt.runtimepath:append('~/.fzf')
Map('n', '<leader>b', ':Buffers<CR>')
Map('n', '<leader>f', ':<c-u>FZF<CR>')

--- grepper
--let g:grepper = {}
--g['g:grepper'] = {}
g['g:grepper.tools'] = 'rg, grep, git'
--let g:grepper.tools = ['rg', 'grep', 'git']
g['g:grepper.next_tool'] = '<leader>g'
--let g:grepper.next_tool = '<leader>g'
-- Search for the current word
--nnoremap <Leader>* :Grepper -cword -noprompt<CR>
Map('n', '<Leader>*', ':Grepper -cword -noprompt')

-- search for the current selection
Map('n', '<leader>g', ':Grepper')
-- nmap gs <plug>(GrepperOperator)
-- xmap gs <plug>(GrepperOperator)
-- nnoremap <leader>g :Grepper<cr>


--- ale
-- Disable linting for all minified JS files.
--g['g:ale_pattern_options'] = ['rg', 'grep', 'git']
--let g:ale_pattern_options = {'\.min.js$': {'ale_enabled': 0}}

g['g:ale_fix_on_save'] = 1
g['g:ale_lint_on_text_changed'] = 'normal'
g['g:ale_lint_on_insert_leave'] = 1
g['g:let g:ale_lint_delay'] = 0
g['g:let g:ale_set_quickfix'] = 0
g['g:let g:ale_set_loclist'] = 0



-- Colors / Display
opt.background = 'dark'
opt.cursorline = true
--set fillchars=
opt.fillchars = ''
opt.fillchars:append('vert:│', 'stl: ', 'stlnc:-')
--set fillchars=
opt.termguicolors = true
opt.ttyfast = true --                " Faster redrawing.
--opt.lazyredraw = true --             " Only redraw when necessary.
--opt.showmode = true
g['nord_italic'] = 1
g['nord_italic_comments'] = 1
g['nord_underline'] = 1

vim.cmd('colorscheme nord')

opt.laststatus = 1

require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
      disable = {},
    },
    indent = {
      enable = false,
      disable = {},
    },
}