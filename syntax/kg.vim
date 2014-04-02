" Vim syntax file
" Language:     Kg
" Maintainer:   Long
" Last Change:  2013-10-21
" Remark:       Included by the JavaScript syntax.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'javascript'
endif

ru! syntax/javascript.vim
unlet b:current_syntax

syn match javaScriptFunction /Kg$/
syn match javaScriptType /Kg\.\$/
syn match javaScriptType /Kg\.\($I\|$T\|$C\|$A\|UA\)/
syn match javaScriptFunctionKeys /Kg\+.*\(Ajax\|get\|getJSON\|loadScript\|post\|postJSON\|flash\)/
syn match javaScriptFunctionKeys /Kg\+.*\(index\|attr\|addClass\|removeClass\|eq\|toggleClass\|html\|val\)/
syn match javaScriptFunctionKeys /Kg\+.*\(parent\|next\|prev\|find\|bubbleSort\|placeholder\|remove\|show\|hide\|request\)/
syn match javaScriptFunctionKeys /Kg\+.*\(getStyle\|getBodySize\|getXY\|addEvent\|removeEvent\|stopEvent\|inArray\)/
syn match javaScriptFunctionKeys /Kg\+.*\(each\|hasClass\|indexOf\|setOpacity\|fadein\|fadeout\|slide\|Cookie\|Param\|JSON\)/
syn match javaScriptFunctionKeys /Kg\+.*\(append\|prepend\|insertBefore\|extend\|css\)/
syn match javaScriptFunctionKeys /Kg\+.*UA\.\(Ie\(6\|7\|8\)\|FF\|Opera\|Chrom\)/

let b:current_syntax = 'kg'
