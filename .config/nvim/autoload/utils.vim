" Do something and preserve the state (i.e., not change the search history and
" cursor position)
" Ref: http://vimcasts.org/episodes/tidying-whitespace/
" @Param: command - the cmdline command to be executed
" @Param: ... - visual mode type, i.e., the return of visualmode()
function! utils#Preserve(command, ...) abort
  " Pre-processing: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  if a:0 == 2
    if a:1 ==# 'V'
      execute "normal! `<V`>:" . a:command . "\<CR>"
    elseif a:1 ==# 'v'
      execute "normal! `<v`>:" . a:command . "\<CR>"
    endif
  else
    execute a:command
  endif
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Search for the current selection
" Reference: http://vimcasts.org/episodes/search-for-the-selected-text/
function! utils#VSetSearch(cmdtype) abort
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Grep operator
" Reference: https://learnvimscriptthehardway.stevelosh.com/chapters/32.html
" function! utils#GrepOperator(type) abort
"   let saved_unnamed_register = @@
"   if a:type ==# 'v'
"     normal! `<v`>y
"   elseif a:type ==# 'char'
"     normal! `[v`]y
"   else
"     return
"   endif
"   silent execute "grep! " . shellescape(@@) . " ."
"   copen
"   let @@ = saved_unnamed_register
" endfunction

" Operator for grep_string of Telescope
function! utils#TelescopeGrepOperator(type) abort
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  silent execute "lua require('telescope.builtin').grep_string({search = " . shellescape(@@) . "})"
  let @@ = saved_unnamed_register
endfunction

" Delete all the other unmodified buffers
function! utils#BufsDel() abort
  for buf in getbufinfo({'buflisted':1})
    if (buf.hidden && !buf.changed)
      execute buf.bufnr . 'bdelete'
    endif
  endfor
endfunction

" Change indentation for the current buffer
" It needs two arguments, one is the curren indentation and the other is the new
" indentation
function utils#Reindent(...)
  if a:0 != 2
    echoerr "Two arguments are required"
  endif
  let save_et = &et
  let save_ts = &ts
  try
    let &ts = a:1
    set noet
    retab!
    let &ts = a:2
    set et
    retab!
    let &l:sw = a:2
  finally
    let &et = save_et
    let &ts = save_ts
  endtry
endfunction

" Save session
" When we save a session with some floating windows open, this windows will be
" also recorded in the session file. Later when we load the session, we will
" have a weird window layout (disordered size and position). To avoid this, we
" should close all floating windows before saving a session. Because some
" floating windows belongs to some plugins, thus after saving, we should
" reenable such plugins.
function utils#SaveSession() abort
  lua require('utils').close_all_floating_wins()
  call startify#session_save(0)
  TSContextEnable
  ScrollViewEnable
endfunction
