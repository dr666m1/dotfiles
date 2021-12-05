"===== vim-plug =====
call plug#begin('~/.vim/plugged')
" common
Plug 'airblade/vim-gitgutter'
Plug 'dr666m1/vim-bigquery'
Plug 'dr666m1/vim-clipboard'
Plug 'itchyny/lightline.vim'
Plug 'kassio/neoterm'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'prettier/vim-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'yggdroot/indentLine'
" python
Plug 'Vimjas/vim-python-pep8-indent'
" js, ts
Plug 'neoclide/vim-jsx-improve'
call plug#end()

"===== common =====
let mapleader = "\<space>"
set timeoutlen=500
syntax on
autocmd Filetype rust,javascriptreact,bq,sql syntax sync minlines=10000
filetype plugin indent on
set cursorline
let g:python3_host_prog = '$HOME/.pyenv/shims/python'
set expandtab
set tabstop=2
set shiftwidth=2

"===== NERDTree =====
nnoremap <leader>f :NERDTreeFocus<cr>
let NERDTreeCustomOpenArgs = {'file': {'reuse': 'all', 'where': 't'}, 'dir': {}}
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden = 1

"===== bookmarks =====
let g:bookmark_auto_save = 0

"===== theme =====
colorscheme molokai
highlight Comment ctermfg=34

"===== prettier =====
function MyPrettier()
    let current_line = line(".")
    return "o\<esc>dd:%!npx prettier --stdin-filepath %" . current_line . "G"
endfunction
"PrettierAsync may be better but cannot be used with vim-bookmarks
nnoremap <expr><leader>p MyPrettier()

autocmd Filetype bq,sql nnoremap<buffer> <leader>p :call CocAction('format')<cr>
command! -nargs=0 UpdateCache call CocRequestAsync("bigquery", "bq/updateCache")

"===== indentLine =====
autocmd Filetype markdown,json,tex IndentLinesDisable
autocmd Filetype markdown,json,tex set conceallevel=0

"===== neoterm =====
let g:neoterm_default_mod = 'vertical'
let g:neoterm_autoscroll = 1
let g:neoterm_auto_repl_cmd = 0
tnoremap jk <c-\><c-n>
nnoremap <expr><leader>r g:myrepl_current_status == "none" ?
    \ MyRepl() : ":TREPLSendLine\<cr>\<down>0"
"nnoremap :: q:iT<space>
vnoremap <expr><leader>r g:myrepl_current_status == "none" ?
    \ MyRepl() : ":\<c-u>TREPLSendSelection\<cr>:T\<space>\<c-v>\<cr>\<cr>`>"
autocmd Filetype javascript vnoremap <buffer> <expr><leader>r g:myrepl_current_status == "none" ?
    \ MyRepl() : ":\<c-u>T\<space>.editor\<cr>:TREPLSendSelection\<cr>:T\<space>\<c-v>\<c-d>\<cr>`>"
nnoremap <expr><leader>t MyRepl()
let g:myrepl_current_status = "none"
function MyRepl()
    if g:myrepl_current_status == "none"
        if &filetype == "python"
            let g:myrepl_exit_command = ":T \<c-v>\<c-c>exit()\<cr>"
            let g:myrepl_current_status = &filetype
            return ":T ipython --no-autoindent\<cr>"
        elseif &filetype == "javascriptreact" || &filetype == "javascript"
            let g:myrepl_exit_command = ":T \<c-v>\<c-c>.exit\<cr>"
            let g:myrepl_current_status = &filetype
            return ":T node\<cr>"
        else
            let g:myrepl_exit_command = ":T \<c-v>\<c-a>\<c-v>\<c-k>exit\<cr>"
            let g:myrepl_current_status = "shell"
            return ":T echo 'using common repl!'\<cr>"
        endif
    else
        if g:myrepl_current_status == "shell"
            let g:myrepl_exit_command = ":T \<c-v>\<c-a>\<c-v>\<c-k>exit\<cr>"
            let g:myrepl_current_status = "none"
            return g:myrepl_exit_command
        else
            let g:myrepl_current_status = "shell"
            return g:myrepl_exit_command
        endif
    endif
endfunction
nnoremap <expr><leader>w g:myrepl_current_status == "none" ? MyRepl() : ":Ttoggle\<cr>"

"===== coc.nvim =====
inoremap <silent><expr> <tab> coc#expandableOrJumpable() ? "\<c-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<cr>" : "\<tab>"
vmap <tab> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'
nnoremap <leader>s :CocCommand snippets.openSnippetFiles<cr>
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nnoremap <silent> K :call <SID>show_documentation()<CR>
inoremap <silent><expr> <c-space> coc#refresh()
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

"===== move cursor =====
noremap! <c-j> <down>
tnoremap <c-j> <down>
noremap! <c-k> <up>
tnoremap <c-k> <up>
noremap! <c-l> <right>
tnoremap <c-l> <right>
nnoremap <s-g> <s-g>$
vnoremap <s-g> <s-g>g_
nnoremap gg gg0
vnoremap gg gg0
vnoremap $ g_
function My0()
    let myzero_next_col = strchars(matchstr(getline("."), "^\\s*"))+1
    let myzero_current_col = col(".")
    if 1 < myzero_next_col && myzero_next_col < myzero_current_col
        return "^"
    else
        return "0"
        "!... ignore mapping
    endif
endfunction
nnoremap <expr>0 My0()
vnoremap <expr>0 My0()

"===== tab =====
nnoremap <leader>n :tabe<cr>
nnoremap <c-]> :tabn<cr>
nnoremap <c-[> :tabp<cr>

"===== window =====
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"===== quote & bracket =====
inoremap ( )<left>(
tnoremap ( )<left>(
inoremap { }<left>{
tnoremap { }<left>{
inoremap " "<left>"
tnoremap " "<left>"
inoremap ' '<left>'
tnoremap ' '<left>'
inoremap [ ]<left>[
tnoremap [ ]<left>[
inoremap ` `<left>`
tnoremap ` `<left>`
inoremap < ><left><
inoremap <<space> <<space>
inoremap <= <=
inoremap {<cr> {}<left><cr><esc><s-o>
inoremap (<cr> ()<left><cr><esc><s-o>
inoremap [<cr> []<left><cr><esc><s-o>
command! -nargs=* MyQuote call MyQuote(<f-args>)
function MyQuote(l, ...)
    let r = get(a:000, 0, a:l)
    execute "normal! `>"
    execute "normal! a" . r
    execute "normal! `<"
    execute "normal! i" . a:l
endfunction
vnoremap "  :<c-u>call<space>MyQuote('"')<cr>
vnoremap '  :<c-u>call<space>MyQuote("'")<cr>
vnoremap {  :<c-u>call<space>MyQuote("{",     "}")<cr>
vnoremap (  :<c-u>call<space>MyQuote("(",     ")")<cr>
vnoremap [  :<c-u>call<space>MyQuote("[",     "]")<cr>
vnoremap <  :<c-u>call<space>MyQuote("<",     ">")<cr>
vnoremap /* :<c-u>call<space>MyQuote("/* ",   " */")<cr>
vnoremap <! :<c-u>call<space>MyQuote("<!-- ", " -->")<cr>
vnoremap q <esc>:MyQuote<space>

"===== yank & paste =====
autocmd InsertLeave * set nopaste
vnoremap y y`>
vnoremap <leader>y <esc>:ClipboardYank<cr>
nnoremap <leader>v :ClipboardPut<cr>

"===== other =====
cabbrev vrc $MYVIMRC
inoremap <c-u> <esc>viw<s-u>ea
nnoremap <leader><cr> <c-]>

nnoremap / /\v
noremap! jk <esc>
set number
set list
set listchars=tab:»\ ,trail:•,eol:↲,extends:»,precedes:«,nbsp:.

" This function should be used in visual mode
function InVisualBlockMode()
    let mode = mode()
    if mode == ""
        return "1"
    else
        return "0"
    endif
endfunction
vnoremap <expr>i InVisualBlockMode() ? "\<s-i>" : "i"
vnoremap <expr>a InVisualBlockMode() ? "\<s-a>" : "a"
" useful to exit from visual block mode.
vnoremap v <esc>

"===== local_setting =====
for s:path in split(glob('~/.config/nvim/rc/*.vim'), "\n")
  exe 'source ' . s:path
endfor
