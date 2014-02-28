# TWCommand

TWCommand is a set of useful commands for moving & managing a tab or window in vim.

- Move a tab  
![tmv_opt](https://f.cloud.github.com/assets/5915359/2292424/ee3f5c92-a058-11e3-9014-db07bd4dc9dd.gif)

- Move a window  
![wmv_opt](https://f.cloud.github.com/assets/5915359/2292428/f63c2d94-a058-11e3-9c8a-57054a14a333.gif)

- Move a window between tabs  
![wmvt_opt](https://f.cloud.github.com/assets/5915359/2292433/fbd08fb6-a058-11e3-8978-c180054a0333.gif)

- Close a window or tab, then move focus to previously focused one  
![close_opt](https://f.cloud.github.com/assets/5915359/2292436/ffa958f2-a058-11e3-96ac-8be871d8e39f.gif)

## Usage
In vim normal mode, type the following command and press `<Enter>`.  
**:TWCommand {cmd} {arg}**  
- {cmd} : subcommands for tab / window moving & managing
- {arg} : vim `:wincmd`-style single character arguments to indicate a moving direction or desired action

For example,
```
:TWComand tcm l    |" move cursor to the right tab
:TWComand wmv h    |" move current window to left
:TWComand tcm q    |" close current tab
```

It must be more convinient to define key mappings for frequently used subcommands and arguments.  
My recommendation for key mappings are given in the last section of this page.

The descriptions for {cmd} and {arg} are given as follows:

### {cmd}

{cmd}   | description 
---     | ---
tcm     | **t**ab **c**o<b>m</b>mand for cursor moving and managing
tmv     | **t**ab **m**o<b>v</b>ing command
wcm     | **w**indow **c**o<b>m</b>mand for cursor moving and managing
wmv     | **w**indow **m**o<b>v</b>ing command
wmvt    | **w**indow **m**o<b>v</b>ing command between **t**abs

### {arg} for tcm (tab command for cursor moving and managing)

{arg} | description
---   | ---
h     | Go to the left tab page.
l     | Go to the right tab page.
W     | Go to the left tab page. Wraps around from the first to the last one.
w     | Go to the right tab page. Wraps around from the last to the first one.
t     | Go to the first tab page.
b     | Go to the last tab page.
p     | Go to the previous tab page.
q     | Close current tab page and move focus to previously focused one.
n     | Open a new tab page with an empty window, after the current tab page.
o     | Close all other tab pages.

### {arg} for tmv (tab moving command)

{arg} | description
---   | ---
h     | Move current tab to left.
l     | Move current tab to right.
p     | Move current tab to location of previously focused tab.

and all other arguments used with `tcm` subcommand that moves a cursor such as w, W, t, b.

### {arg} for wcm (window command for cursor moving and managing)

{arg} | description
---   | ---
q     | Quit current window and move cursor to previously focused one.
m     | Toggle maximizing current window.

and all other arguments used in `:wincmd`.

### {arg} for wmv (window moving command)

{arg} | description
---   | ---
h     | Move current window to left.
l     | Move current window to right.
j     | Move current window to down.
k     | Move current window to up.
p     | Move current window to location of previously focused window.

and all other arguments used in `:wincmd` that moves a cursor such as w, W, t, b.

### {arg} for wmvt (window moving command between tabs)

{arg} | description
---   | ---
h     | Move current window to left tab. If there is no left tab, new left tab is created.
l     | Move current window to right tab. If there is no right tab, new right tab is created.
p     | Move current window to previously focused tab.

and all other arguments used with `tcm` subcommand that moves a cursor such as w, W, t, b.  

When moving, 
- Current tab will be closed if it has only one window (current window).  
- If target tab has only one window with [No Name] title and empty buffer, current window replaces it.
- Otherwise, current window is located at a new vertical split window of target tab.

## Recommended Key Mappings

TWCommand does not provide default key mappings to keep your key mappings clean.
Instead, I suggest convinient key mappings what I'm using now.
You can add them to your .vimrc and modify them as you want.

```
function! s:nnoreicmap(option, shortcut, command)
	execute 'nnoremap '.a:option.' '.a:shortcut.' '.a:command
	execute 'imap '.a:option.' '.a:shortcut.' <Esc>'.a:shortcut
	execute 'cmap '.a:option.' '.a:shortcut.' <Esc>'.a:shortcut
endfunction

" tab cursor moving and managing
call s:nnoreicmap('','<A-H>',':TWCommand tcm h<CR>')
call s:nnoreicmap('','<A-L>',':TWCommand tcm l<CR>')
call s:nnoreicmap('','<A-P>',':TWCommand tcm p<CR>')
call s:nnoreicmap('','<A-Q>',':TWCommand tcm q<CR>')
call s:nnoreicmap('','<A-N>',':TWCommand tcm n<CR>')

" tab moving
call s:nnoreicmap('','<A-J>',':TWCommand tmv h<CR>')
call s:nnoreicmap('','<A-K>',':TWCommand tmv l<CR>')
call s:nnoreicmap('','<A-)>',':TWCommand tmv p<CR>')

" window cursor moving and managing
call s:nnoreicmap('','<A-h>',':TWCommand wcm h<CR>')
call s:nnoreicmap('','<A-j>',':TWCommand wcm j<CR>')
call s:nnoreicmap('','<A-k>',':TWCommand wcm k<CR>')
call s:nnoreicmap('','<A-l>',':TWCommand wcm l<CR>')
call s:nnoreicmap('','<A-p>',':TWCommand wcm p<CR>')
call s:nnoreicmap('','<A-q>',':TWCommand wcm q<CR>')
call s:nnoreicmap('','<A-n>',':TWCommand wcm n<CR>')
call s:nnoreicmap('','<A-v>',':TWCommand wcm v<CR>')
call s:nnoreicmap('','<A-s>',':TWCommand wcm s<CR>')
call s:nnoreicmap('','<A-m>',':TWCommand wcm m<CR>')

" window moving
call s:nnoreicmap('','<A-y>',':TWCommand wmv h<CR>')
call s:nnoreicmap('','<A-u>',':TWCommand wmv j<CR>')
call s:nnoreicmap('','<A-i>',':TWCommand wmv k<CR>')
call s:nnoreicmap('','<A-o>',':TWCommand wmv l<CR>')
call s:nnoreicmap('','<A-0>',':TWCommand wmv p<CR>')

" window moving between tabs
call s:nnoreicmap('','<A-U>',':TWCommand wmvt h<CR>')
call s:nnoreicmap('','<A-I>',':TWCommand wmvt l<CR>')
call s:nnoreicmap('','<A-(>',':TWCommand wmvt p<CR>')
```

I've define the function `s:nnoreicmap()` to map for normal, insert and command-line modes simultaneously,
and installed ![vim-fixkey](https://github.com/drmikehenry/vim-fixkey) plugin to use alt-key mappings.
`<A-H>` means alt+shift+h.
