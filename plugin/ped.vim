" ped.vim - Quickly open Python modules in vim
" Author: Steven Loria

if exists('g:loaded_ped')
  finish
endif
let g:loaded_ped = 1

if !exists('g:ped_executable')
  let g:ped_executable = 'ped'
endif

if !exists('g:ped_edit_command')
  let g:ped_edit_command = 'edit'
endif

" Thanks to xolox!
" http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
func! g:PedVisualSelection() abort
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endf

function! s:Echo(msg, ...)
  redraw
  let x=&ruler | let y=&showcmd
  set noruler noshowcmd
  if (a:0 == 1)
    echo a:msg
  else
    echohl WarningMsg | echo a:msg | echohl None
  endif

  let &ruler=x | let &showcmd=y
endfunction

function! s:RunPed(edit_cmd, ipath)
  if (executable(g:ped_executable) == 0)
    call s:Echo('ped executable not found. You may need to run "pip install ped".')
    return
  endif
  let output = system(g:ped_executable . ' --info ' . shellescape(a:ipath))
  let info = split(output)
  if len(info) > 2
    let lineno = info[2]
  else
    let lineno = 0
  endif
  " If error occurred, output it
  if info[0] == 'ERROR:'
    call s:Echo(output)
  else
    " Open file
    execute a:edit_cmd fnameescape(info[1])
    " If we found a line number, go to it
    if lineno
      execute 'normal! ' + lineno + 'G'
    endif
  endif
endfunction

function! s:PedVword(to_exec)
  let keys = '":\<C-U>Ped " . g:PedVisualSelection()'
  let keys .= a:to_exec ? '."\r"' : '." "'
  let cmd = ":\<C-U>call feedkeys(" . keys . ", 'n')\r"
  return cmd
endfunction

function! s:PedCword(to_exec)
  let cmd = ":\<C-U>Ped " . expand('<cword>')
  let cmd .= a:to_exec ? "\r" : " "
  return cmd
endfunction

" Tab-complete Python module names; uses 'ped --complete'
function! s:ModuleComplete(arg_lead, line, position)
  return system(g:ped_executable . ' --complete ' . shellescape(a:arg_lead))
endfunction

" Commands
command! -nargs=1 -bar -complete=custom,s:ModuleComplete Ped call s:RunPed(g:ped_edit_command, <q-args>)
command! -nargs=1 -bar -complete=custom,s:ModuleComplete PedSplit call s:RunPed('split', <q-args>)
command! -nargs=1 -bar -complete=custom,s:ModuleComplete PedVSplit call s:RunPed('vsplit', <q-args>)
command! -nargs=1 -bar -complete=custom,s:ModuleComplete PedTab call s:RunPed('tabedit', <q-args>)

" Maps
nnoremap <Plug>PedPrompt :Ped<Space>
vnoremap <expr> <Plug>PedVword <SID>PedVword(0)
vnoremap <expr> <Plug>PedVwordExec <SID>PedVword(1)
nnoremap <expr> <Plug>PedCword <SID>PedCword(0)
nnoremap <expr> <Plug>PedCwordExec <SID>PedCword(1)
