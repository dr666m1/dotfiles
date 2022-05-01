" move {{{
noremap! <expr> <c-j> pumvisible() ? "\<c-e><down>" : "\<down>"
tnoremap <c-j> <down>
noremap! <expr> <c-k> pumvisible() ? "\<c-e><up>" : "\<up>"
tnoremap <c-k> <up>
noremap! <c-l> <right>
tnoremap <c-l> <right>
nnoremap <s-g> <s-g>$
vnoremap <s-g> <s-g>g_
nnoremap gg gg0
vnoremap gg gg0
vnoremap <expr> $ mode() ==# "\<c-v>" ? "$" : "g_"
nnoremap <expr> 0 matchend(getline("."), '\v\s*') + 1 <  col(".") ? "^" : "0"
vnoremap <expr> 0 matchend(getline("."), '\v\s*') + 1 <  col(".") ? "^" : "0"
" }}}

" tab {{{
nnoremap <c-n> :tabn<cr>
nnoremap <c-p> :tabp<cr>
" }}}

" yank, put {{{
vnoremap y ygv<esc>
vnoremap <leader>y <esc>:ClipboardYank<cr>
nnoremap <leader>p :ClipboardPut<cr>
" }}}

" quote {{{
inoremap ( )<left>(
tnoremap ( )<left>(
inoremap { }<left>{
tnoremap { }<left>{
inoremap [ ]<left>[
tnoremap [ ]<left>[
inoremap < ><left><
inoremap <<space> <<space>
inoremap <= <=
inoremap " "<left>"
tnoremap " "<left>"
inoremap ' '<left>'
tnoremap ' '<left>'
inoremap ` `<left>`
tnoremap ` `<left>`
inoremap (<cr> ()<left><cr><esc><s-o>
inoremap {<cr> {}<left><cr><esc><s-o>
inoremap [<cr> []<left><cr><esc><s-o>
function! s:Quote(left, ...)
  let right = get(a:000, 0, a:left)
  execute "normal! `>"
  execute "normal! a" . right
  execute "normal! `<"
  execute "normal! i" . a:left
endfunction
vnoremap "  :<c-u>call <SID>Quote('"')<cr>
vnoremap '  :<c-u>call <SID>Quote("'")<cr>
vnoremap `  :<c-u>call <SID>Quote("`")<cr>
vnoremap {  :<c-u>call <SID>Quote("{",     "}")<cr>
vnoremap (  :<c-u>call <SID>Quote("(",     ")")<cr>
vnoremap [  :<c-u>call <SID>Quote("[",     "]")<cr>
vnoremap <  :<c-u>call <SID>Quote("<",     ">")<cr>
vnoremap /* :<c-u>call <SID>Quote("/* ",   " */")<cr>
vnoremap <! :<c-u>call <SID>Quote("<!-- ", " -->")<cr>
" }}}

" other {{{
nnoremap / /\v
noremap! jk <esc>
tnoremap jk <c-\><c-n>
vnoremap v <esc>
inoremap <c-g><c-u> <esc>viw<s-u>ea
" }}}
