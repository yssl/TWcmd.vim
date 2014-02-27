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
if !exists('g:twcommand_prevtabnr')
	let g:twcommand_prevtabnr = tabpagenr()
endif
if !exists('g:twcommand_prevwinnr')
	let g:twcommand_prevwinnr = tabpagenr()
endif

" commands
command! -nargs=* TWCommand call TWCommand#TWCommand(<f-args>)

" autocmd
augroup TWCommandAutoCmds
	autocmd!
	autocmd TabLeave * call s:OnTabLeave() 
	autocmd WinLeave * call s:OnWinLeave() 
augroup END

" functions
fun! s:OnTabLeave()
	let g:twcommand_prevtabnr = tabpagenr()
endfun
fun! s:OnWinLeave()
	let g:twcommand_prevwinnr = winnr()
endfun

"""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo
