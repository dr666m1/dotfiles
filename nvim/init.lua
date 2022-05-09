local function key(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- If you map `<leader>x` and `<localleader>x` differently,
-- most recently defined mapping will work.
vim.g.mapleader = key'<space>'
vim.g.maplocalleader = key'<space>'

vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'dr666m1/vim-bigquery'
Plug 'dr666m1/vim-clipboard'
Plug 'itchyny/lightline.vim'
Plug 'kassio/neoterm'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'prettier/vim-prettier', {'do': 'yarn install --frozen-lockfile --production'}
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'yggdroot/indentLine'
" python
Plug 'Vimjas/vim-python-pep8-indent'
" js, ts
Plug 'neoclide/vim-jsx-improve'
call plug#end()


syntax on
filetype plugin indent on

colorscheme molokai
highlight Comment ctermfg=34
highlight Pmenu ctermfg=245

for s:path in glob('~/.config/nvim/settings/*.vim', 0, 1)
  exe 'source ' . s:path
endfor
]])

require('option')
require('mapping')
