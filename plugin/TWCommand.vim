" File:         plugin/TWCommand.vim
" Description:  A plugin for moving & managing a tab or window.
" Author:       yssl <http://github.com/yssl>
" License:      

if exists("g:loaded_twcommand") || &cp
	finish
endif
let g:loaded_twcommand	= 1
let s:keepcpo           = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""

" global variable
if !exists('g:twcommand_restore_prevfocus')
	let g:twcommand_restore_prevfocus = 1
endif
if !exists('g:twcommand_maxhistory')
	let g:twcommand_maxhistory = 20
endif
if !exists('g:twcommand_push')
	let g:twcommand_push = 1
endif

" commands
command! -nargs=* TWCommand call TWCommand#TWCommand(<f-args>)

" autocmd
augroup TWCommandAutoCmds
	autocmd!
	autocmd WinLeave * call s:OnWinLeave() 
augroup END

" functions
fun! s:OnWinLeave()
	if g:twcommand_push
		call TWCommand#PushHistory(tabpagenr(), winnr())
		"echo 'winleave' tabpagenr() winnr()
	endif
endfun

"""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo
