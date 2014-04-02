"=============================================================================
"     FileName: txt.vim
"         Desc:    
"       Creator: Long
"      Version: 1.0
"      $Author: Long $
"        $Date:  $
"   LastChange: 2013-12-05 21:35:40
"      History:
"=============================================================================
""
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'txt'
endif












"
let b:current_syntax = "txt"
if main_syntax == 'txt'
  unlet main_syntax
endif

" vim: set et fdm=marker ff=dos sts=4 sw=4 ts=4 tw=78 : 
