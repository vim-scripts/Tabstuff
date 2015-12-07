"Author: Francis Grizzly Smit
" License:  GPLv3
"Created: 2015-12-07

let s:sfile = expand('<sfile>:p')
"call vlutils#Init()
"let s:os = vlutils#os

function! Joinpath(a, ...) "{{{2
    if has('win32') || has('win64') || has('win32unix')
       let pathsep = '\'
    else
       let pathsep = '/'
    endif
    let path = a:a
    for b in a:000
        if b =~# pathsep
            let path = b
        elseif path ==# '' || path =~# pathsep .'$'
            let path .= b
        else
            let path .= pathsep . b
        endif
    endfor
    return path
endfunction
function! PosixPath(sPath) "{{{2
    if has('win32') || has('win64') || has('win32unix')
        return substitute(a:sPath, '\', '/', 'g')
    else
        return a:sPath
    endif
endfunction
let tabstuf_dir = Joinpath(fnamemodify(fnamemodify(s:sfile, ':h'), ':h'), '_tabstuff')
let tabstuff_bitmapsdir = Joinpath(tabstuf_dir, 'bitmaps')

function tabutils#init()
    return 1
endfunction

let rtp_bak = &runtimepath
let &runtimepath = PosixPath(tabstuf_dir) . ',' . &runtimepath
function tabutils#toolbar()
    "let rtp_bak = &runtimepath
    "let &runtimepath = PosixPath(tabstuf_dir) . ',' . &runtimepath

    "anoremenu icon=$HOME/.vim/_tabstuff/bitmaps/open-in-tabs.xpm 1.15 ToolBar.OpenInNewTab :browse tabnew<cr>
    anoremenu <silent>  icon=open-in-tabs 1.15 ToolBar.OpenInNewTab :browse tabnew<cr>
    tmenu ToolBar.OpenInNewTab Open In New Tab
    anoremenu <silent>  icon=create-in-tabs 1.16 ToolBar.CreateInNewTab :call TabNewFile()<cr>
    tmenu ToolBar.CreateInNewTab Create File In New Tab
    anoremenu <silent>  1.281 ToolBar.-TabSep- :
    "anoremenu <silent>  icon=$HOME/.vim/_tabstuff/bitmaps/arrow-left-double.xpm 1.282 ToolBar.TabFirst :tabfirst<cr>
    anoremenu <silent>  icon=arrow-left-double 1.282 ToolBar.TabFirst :tabfirst<cr>
    tmenu ToolBar.TabFirst Goto First Tab
    anoremenu <silent>  icon=arrow-right 1.283 ToolBar.TabNext :tabnext<cr>
    tmenu ToolBar.TabNext Goto Next Tab 
    anoremenu <silent>  icon=arrow-left 1.284 ToolBar.TabPrevious :tabprevious<cr>
    tmenu ToolBar.TabPrevious Goto Previous Tab
    anoremenu <silent>  icon=arrow-right-double 1.285 ToolBar.TabLast :tablast<cr>
    tmenu ToolBar.TabLast Goto Last Tab
    anoremenu <silent>  1.286 ToolBar.-TabSep2- :
    anoremenu <silent>  icon=dialog-close 1.287 ToolBar.TabClose :tabclose<cr>
    tmenu ToolBar.TabClose Close Current Tab
    anoremenu <silent>  1.288 ToolBar.-TabSep3- :
    anoremenu <silent>  icon=tabs 1.289 ToolBar.TabOpenAllInTabs :tab sball<cr>
    tmenu ToolBar.TabOpenAllInTabs Open All Buffers In Tabs
    anoremenu <silent>  icon=tabmove-start 1.290 ToolBar.TabMoveStart :tabmove 0<cr>
    tmenu ToolBar.TabMoveStart Tab Move Start
    anoremenu <silent>  icon=tabmove-left 1.291 ToolBar.TabMoveBack :exe 'tabmove' (tabpagenr()-2)<cr>
    tmenu ToolBar.TabMoveBack Tab Move Back
    anoremenu <silent>  icon=tabmove-right 1.292 ToolBar.TabMoveForward :exe 'tabmove' tabpagenr()<cr>
    tmenu ToolBar.TabMoveForward Tab Move Forward
    anoremenu <silent>  icon=tabmove-end 1.293 ToolBar.TabMove :tabmove<cr>
    tmenu ToolBar.TabMove Tab Move End
    anoremenu <silent>  icon=help 1.294 ToolBar.Tab\ Search\ Help :call Tabhelp()<cr>
    tmenu ToolBar.Tab\ Search\ Help Tab Search Help
    anoremenu <silent>  icon=helpgrep 1.294 ToolBar.Tab\ Search\ HelpGrep :call TabhelpGrep()<cr>
    tmenu ToolBar.Tab\ Search\ HelpGrep Tab Search HelpGrep
    "let &runtimepath = rtp_bak
    return 1
endfunction

function! Tabhelp()
    let search =inputdialog("Search help for: ", "") 
    exe ":tab help " . search
endfunction

function! TabhelpGrep()
    let search =inputdialog("Grep Search help for: ", "") 
    exe ":tab helpgrep " . search
    exe ":cwindow"
endfunction

function TabNewFile()
    if  has("browse") == 0
        let dir = input("directory for new file: ", "", "dir")
        let filename = Joinpath(dir, input("file name: "))
    else
        let dir = browsedir("choose a directory for new file: ", getcwd())
        let filename = Joinpath(dir, inputdialog("Name for new file: ", ""))
    endif
    exe ":tabnew " . filename
endfunction

function tabutils#menus()
    anoremenu Tab.First\ Tab :tabfirst<cr>
    anoremenu Tab.Next\ Tab :tabnext<cr>
    anoremenu Tab.Previous\ Tab :tabprevious<cr>
    anoremenu Tab.Last\ Tab :tablast<cr>
    anoremenu Tab.-Sep0- :
    anoremenu Tab.Close\ Tab :tabclose<cr>
    anoremenu Tab.-Sep1- :
    anoremenu Tab.Open\ All\ Buffers\ In\ Tabs :tab sball<cr>
    anoremenu Tab.-Sep2- :
    anoremenu Tab.Move\ Tab\ to\ Start :tabmove 0<cr>
    anoremenu Tab.Move\ Tab\ Back :exe 'tabmove' (tabpagenr()-2)<cr>
    anoremenu Tab.Move\ Tab\ Forward :exe 'tabmove' tabpagenr()<cr>
    anoremenu Tab.Move\ Tab\ to\ end :tabmove<cr>
    anoremenu Tab.-Sep3- :
    anoremenu Tab.Create\ New\ File\ in\ tab\.\.\. :call TabNewFile()<cr>

    anoremenu Tools.-GrizzlySep0- :
    anoremenu Tools.Toggle\ Tag\ List :TlistToggle<cr>
    return 1
endfunction
