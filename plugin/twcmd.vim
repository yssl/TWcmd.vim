" File:         plugin/twcmd.vim
" Description:  vim's wincmd-style extended tab / window moving commands.
" Author:       yssl <http://github.com/yssl>
" License:      

if exists("g:loaded_twcmd") || &cp
	finish
endif
let g:loaded_twcmd	= 1
let s:keepcpo           = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""

" global variable
if !exists('g:twcmd_restore_prevfocus')
	let g:twcmd_restore_prevfocus = 1
endif
if !exists('g:twcmd_maxhistory')
	let g:twcmd_maxhistory = 20
endif
if !exists('g:twcmd_push')
	let g:twcmd_push = 1
endif

" commands
command! -nargs=* TWcmd call twcmd#twcmd(<f-args>)

" autocmd
augroup twcmdAutoCmds
	autocmd!
	autocmd WinLeave * call s:OnWinLeave() 
augroup END

" functions
fun! s:OnWinLeave()
	if g:twcmd_push
		call twcmd#PushHistory(tabpagenr(), winnr())
		"echo 'winleave' tabpagenr() winnr()
	endif
endfun

"""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo
