"=============================================================================
"     FileName: css3.vim
"      Language: css3 
"       Creator: Long
"      Version: 1.0
"      $Author: Long $
"        $Date:  $
"   LastChange: 2013-10-21 23:50:38
"      History:
"=============================================================================

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'css'
endif

ru! syntax/css.vim
unlet b:current_syntax

syn match cssImportant contained /\(\s+\)\?-\(webkit\|moz\|o\|ms\)-/

"box
syn match cssBoxProp contained "\<box\(-\(shadow\|reflect\|sizing\|pack\|flex\|align\)\)\=\>"
syn keyword cssAuralAttr contained start end stretch reverse single multiple horizontal vertical

"background
syn match cssBoxProp contained "\<background-\(clip\|size\|repeat\|origin\)\=\>"
syn match cssAuralAttr contained "\<\(repeating-\)\?\(linear\|radial\)-gradient\>"
syn keyword cssAuralAttr contained local space round cover contain

"animation
syn match cssBoxProp contained "\<animation-\(play-state\|timing-function\|iteration-count\|duration\|name\|delay\|direction\)\=\>"
syn keyword cssBoxProp contained animation
syn keyword cssAuralAttr contained alternate forwards backwards infinite running paused linear
syn match cssAuralAttr contained "\<ease-\(in\|out\|in-out\|in-out\)\>"
syn match cssAuralAttr contained "\<cubic-bezier\>"

"border
syn match cssBoxProp contained "\<border-\(radius\|shadow\|image\|reflect\)\=\>"
syn match cssBoxProp contained "\<border-image-\(source\|slice\|width\|outset\|repeat\)\=\>"

"else
syn keyword cssBoxProp contained behavior

"
syn match cssPseudoClassId contained "\<only-child\=\>"
syn match cssPseudoClassId contained "\<\(nth\|nth-last\)-child\=\>"
syn match cssPseudoClassId contained "\<last\-child\=\>"
syn match cssPseudoClassId contained "\<\(nth-last\|last\|first\|only\|nth\)\-of-type\=\>"
syn keyword cssPseudoClassId contained root not empty checked enabled disabled target

syn match cssSelectorOp "[~]"

let b:current_syntax = 'css3'
