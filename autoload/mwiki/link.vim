"
" link function 
"
" Last Change: 2013-09-10 10:50:44

function! mwiki#link#Action(bool)
    let g:cursorStr = mwiki#function#GetCursorString("true")
    if mwiki#link#Is(g:cursorStr) == 1
        let path = mwiki#link#GetLocation(g:cursorStr)
        if match(path,'md$') != -1
            call mwiki#link#Enter(path)
        else
            echo "this link not end with .md"
        endif
    else
        if(a:bool==1)
            let link = mwiki#link#Create(g:cursorStr)
            call mwiki#common#ReplaceCursorStr(link)
        else
            let link = mwiki#link#CreateFolder(g:cursorStr)
            call mwiki#common#ReplaceCursorStr(link)
	endif
    endif
endfunction

" check cursor string is a link
function! mwiki#link#Is(str)
    if a:str == ""
        let str = mwiki#function#GetCursorString("true")
    else
        let str = a:str
    endif
    if match(str, '\[.*\](.*)') != -1
        return 1
    endif
    return 0
endfunction

" create link
function! mwiki#link#Create(word)
    let linkName = a:word
    if mwiki#link#IsUrl(a:word)
        let link = "[".linkName."](".a:word.")"
    else
        let link = "[".linkName."](".a:word.".md)"
    endif
    return link
endfunction

function! mwiki#link#CreateFolder(word)
   let linkLink = a:word."/index" 
   let linkName = a:word
   echo "linkLink and linkName".linkLink." ".linkName
   if mwiki#link#IsUrl(linkLink)
	   echo "link is url".linkLink." ".linkName
       let link = "[".linkName."](".linkLink.")"

   else
   	   echo "link is not url".linkLink." ".linkName

       let link = "[".linkName."](".linkLink.".md)"

	endif
	return link
endfunction    

" jump link locate file
function! mwiki#link#Enter(path)

    if match(a:path,'.*/.*') != -1
        let path = matchlist(a:path, '\(.*\)/')[1]
        call mwiki#common#CreateDir(path)
    endif

    " when editing cursor  wiki is needed push now wiki into path
    if ! exists("g:mwikiEnterLinkStack")
        let g:mwikiEnterLinkStack = []
    endif
    let g:mwikiEnterLinkStack = add(g:mwikiEnterLinkStack, expand("%:p")."@pos".join(getpos("."),","))

    execute "edit ".escape(a:path, " ")
	:lcd %:p:h

endfunction

" get link location
function! mwiki#link#GetLocation(link)
    return matchlist(a:link, '(\(.*\))')[1]
endfunction

" 
function! mwiki#link#GoToLast()
    if exists("g:mwikiEnterLinkStack") && len(g:mwikiEnterLinkStack) != 0
        let res = split(g:mwikiEnterLinkStack[len(g:mwikiEnterLinkStack)-1], "@pos")
        execute "edit ".res[0]
        call setpos(".",split(res[1], ","))
        unlet g:mwikiEnterLinkStack[len(g:mwikiEnterLinkStack)-1]
    else
        echo "this is a last you enter item file."
    endif
endfunction

"the text is url
function! mwiki#link#IsUrl(word)
    if match(a:word,'https\?://.*') != -1
        return 1
    else
        return 0
    endif
endfunction
