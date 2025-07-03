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

opt.linebreak = true

-- Tabs
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.cursorline = true
opt.showmatch = true -- set show matching parenthesis

-- Searching
opt.ignorecase = true
opt.smartcase = true

opt.wildignore = '*.swp,*.bak,*.pyc,*.class,.svn,.git'

opt.title = true
opt.visualbell = true

opt.splitright = true
opt.splitbelow = true

opt.nrformats = ''

opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }

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
g.netrw_liststyle = 3
g.netrw_winsize = 35
g.netrw_browse_split = 4
g.netrw_altv = 1

-- telescope
Map('n', '<leader>f', '<cmd>Telescope find_files<cr>')
Map('n', '<leader>b', '<cmd>Telescope buffers<cr>')
Map('n', '<leader>g', '<cmd>Telescope live_grep<cr>')
Map('n', '<leader>h', '<cmd>Telescope help_tags<cr>')
Map('n', '<leader>r', '<cmd>Telescope oldfiles<cr>')
Map('n', '<leader>s', '<cmd>Telescope grep_string<cr>')
Map('n', '<leader>m', '<cmd>Telescope marks<cr>')
Map('n', '<leader>c', '<cmd>Telescope commands<cr>')

Map('n', '<leader>gb', '<cmd>Telescope git_branches<cr>')
Map('n', '<leader>gc', '<cmd>Telescope git_commits<cr>')
Map('n', '<leader>gs', '<cmd>Telescope git_status<cr>')

-- Colors / Display
opt.background = 'dark'
opt.cursorline = true

opt.fillchars = ''
opt.fillchars:append('vert:│', 'stl: ', 'stlnc:-')

opt.termguicolors = true
opt.ttyfast = true -- Faster redrawing.

opt.laststatus = 1
