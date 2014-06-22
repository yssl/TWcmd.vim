# TWCommand

TWCommand is a set of useful commands for moving & managing tabs and windows in vim.

- Move a tab / window
![twmove_opt](https://cloud.githubusercontent.com/assets/5915359/3352085/b4d72c90-fa31-11e3-81bd-be7ed57d6e70.gif)

- Stack visited windows and recover them when closing
![twhistory_opt](https://cloud.githubusercontent.com/assets/5915359/3351949/c7c4c2d6-fa27-11e3-816a-f448657a5dba.gif)

## Usage
In vim normal mode, type the following command and press `<Enter>`.  
**:TWCommand {cmd} {arg}**  
- {cmd} : sub-commands for tabs or windows
- {arg} : vim's `:wincmd`-style single character arguments 

For example,
```
:TWComand tcm l    |" go to the right tab
:TWComand tmv l    |" move the current tab right
:TWComand wmv h    |" move the current window left
:TWComand tcm q    |" close current tab
```

It must be much more convenient to define key mappings for frequently used commands.  
My key mapping recommendation is given in [the last section](#recommended-key-mappings) of this page.

## Commands

{cmd}   | description 
---     | ---
tcm     | <b>t</b>ab <b>c</b>o<b>m</b>mands
tmv     | <b>t</b>ab <b>m</b>o<b>v</b>ing commands
wcm     | <b>w</b>indow <b>c</b>o<b>m</b>mands
wmv     | <b>w</b>indow <b>m</b>o<b>v</b>ing commands
wmvt    | <b>w</b>indow <b>m</b>o<b>v</b>ing commands between <b>t</b>abs
twh     | <b>t</b>ab-<b>w</b>indow <b>h</b>istory commands

## Arguments

<table>
  <tr>
    <th>{cmd}</th>
    <th>{arg}</th>
    <th>description</th>
  </tr>
  <tr>
    <td align="center" rowspan="13"><i>tcm</i> / <i>wcm</i><br></td>
    <th><b>h</b></th>
    <td>Go to the <b>left</b> <i>tab</i> / <i>window</i>.<br></td>
  </tr>
  <tr>
    <th><b>l</b></th>
    <td>Go to the <b>right</b> <i>tab</i> / <i>window</i>.</td>
  </tr>
  <tr>
    <th><b>j</b></th>
    <td>Go to the <b>below</b> <i>window</i>. (<i>wcm</i> only)</td>
  </tr>
  <tr>
    <th><b>k</b></th>
    <td>Go to the <b>above</b> <i>window</i>. (<i>wcm</i> only)</td>
  </tr>
  <tr>
    <th><b>W</b></th>
    <td>Go to the <b>left</b> <i>tab</i> / <b>left or above</b> <i>window</i>. Wraps around from the first to the last one.<br></td>
  </tr>
  <tr>
    <th><b>w</b></th>
    <td>Go to the <b>right</b> <i>tab</i> / <b>right or below</b> <i>window</i>. Wraps around from the last to the first one.<br></td>
  </tr>
  <tr>
    <th><b>t</b></th>
    <td>Go to the <b>first</b> <i>tab</i> / <b>top-left</b> <i>window</i>.<br></td>
  </tr>
  <tr>
    <th><b>b</b></th>
    <td>Go to the <b>last</b> <i>tab</i> / <b>bottom-right</b> <i>window</i>.<br></td>
  </tr>
  <tr>
    <th><b>p</b></th>
    <td>Go to the <b>previous</b> <i>tab</i> / <b>previous</b> <i>window</i> in the current tab.<br></td>
  </tr>
  <tr>
    <th><b>q</b></th>
    <td><b>Close</b> the current <i>tab</i> / <i>window</i> and go to the latest one in the tab-window history.<br></td>
  </tr>
  <tr>
    <th><b>n</b></th>
    <td><b>Open</b> a new <i>tab</i> / <i>window</i>.<br></td>
  </tr>
  <tr>
    <th><b>o</b></th>
    <td><b>Close all other</b> <i>tabs</i> / <i>windows</i> except the current one.</td>
  </tr>
  <tr>
    <th><b>m</b></th>
    <td><b>Toggle maximizing</b> the current <i>window</i>. (<i>wcm</i> only)</td>
  </tr>
</table>

- *wcm* can be used with all other arguments that used in the vim's `:wincmd` command.

----

<table>
  <tr>
    <th>{cmd}</th>
    <th>{arg}</th>
    <th>description</th>
  </tr>
  <tr>
    <td align="center" rowspan="9"><i>tmv</i> / <i>wmv</i> / <i>wmvt</i><br></td>
    <th>h</th>
    <td>Move the current <i>tab</i> <b>left</b> / <i>window</i> <b>left</b> / <i>window to the</i> <b>left</b> <i>tab</i>.</td>
  </tr>
  <tr>
    <th>l</th>
    <td>Move the current <i>tab</i> <b>right</b> / <i>window</i> <b>right</b> / <i>window to the</i> <b>right</b> <i>tab</i>.</td>
  </tr>
  <tr>
    <th>j</th>
    <td>Move the current <i>window</i> <b>below</b>. (<i>wmv</i> only)</td>
  </tr>
  <tr>
    <th>k</th>
    <td>Move the current <i>window</i> <b>above</b>. (<i>wmv</i> only)</td>
  </tr>
  <tr>
    <th>W</th>
    <td>Move the current <i>tab</i> <b>left</b> / <i>window</i> <b>left or above</b> / <i>window to the</i> <b>left</b> <i>tab</i>.
    Wraps around from the first to the last one.<br></td>
  </tr>
  <tr>
    <th>w</th>
    <td>Move the current <i>tab</i> <b>right</b> / <i>window</i> <b>right or below</b> / <i>window to the</i> <b>right</b> <i>tab</i>.
    Wraps around from the last to the first one.<br></td>
  </tr>
  <tr>
    <th>t</th>
    <td>Move the current <i>tab</i> to <b>first</b> position / <i>window</i> to <b>top-left</b> position / <i>window to the</i> <b>first</b> <i>tab</i>.<br></td>
  </tr>
  <tr>
    <th>b</th>
    <td>Move the current <i>tab</i> to <b>last</b> position / <i>window</i> to <b>bottom-right</b> position / <i>window to the</i> <b>last</b> <i>tab</i>.<br></td>
  </tr>
  <tr>
    <th>p</th>
    <td>Move the current <i>tab</i> to <b>previous</b> position / <i>window</i> to <b>previous</b> position / <i>window to the</i> <b>previous</b> <i>tab</i>.<br></td>
  </tr>
</table>

For *wmvt*,
- The current tab will be closed after moving its window if it is the only one.
- If the target tab has only one window with [No Name] title and empty buffer, the moved window will replace it.
- Otherwise, the moved window will be located as a new vertical split window in the target tab.

----

<table>
  <tr>
    <th>{cmd}</th>
    <th>{arg}</th>
    <th>description</th>
  </tr>
  <tr>
    <td align="center" rowspan="9"><i>twh</i><br></td>
    <th>h</th>
    <td>Move <b>forward</b> in the tab-window history stack.</td>
  </tr>
  <tr>
    <th>l</th>
    <td>Move <b>backward</b> in the tab-window history stack.</td>
  </tr>
</table>

## Tab-Window History

When you leave a window in vim, TWCommand pushes [tab_id, window_id] information of the window into its *tab-window history stack*.

TWCommand sequentially moves the cursor to the last accessed windows using the history when closing a sequence of windows or tabs.
You can also walk through windows in the history with *twh* sub-command.

## Recommended Key Mappings

TWCommand does not provide default key mappings to keep your key mappings clean.
Instead, I suggest convenient one what I'm using now.
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
