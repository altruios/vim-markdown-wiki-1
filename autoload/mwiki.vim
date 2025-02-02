"
" vim markdown wiki plugin
"
"
" Author: h2ero <122750707@qq.com>
" Start Date: 2013-09-09 11:27:11
" Last Change: Y2022-M03-D01 
" Version: 0.0.2
" License: MIT license <http://www.opensource.org/licenses/mit-license>

if exists("g:loaded_mwiki") || &cp
    finish
endif

if ! exists("g:mwikiTableAlign")
    let g:mwikiTableAlign = "left"
endif

function! mwiki#init()
    call mwiki#highlight#init()
endfunction
