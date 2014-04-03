" Vim file type fle
" Language: Less
" Author: Kohpoll (http://www.cnblogs.com/kohpoll/)
" Licensed under MIT.
" Last Modified: 2012-08-03

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

" Enable LessMake if it won't overwrite any settings.
" if !len(&l:makeprg)
"   compiler less
" endif

" FIXME: can not se the correct errorformat for lessc produce the error string
" with escape character like(echo in console with color): 
" \033[31mParseError: missing closing `}` \033[39m\033[31m in \033[39mD:\PlayGround\x.less\033[90m:152:1\033[39m
" \033[90m151 }\033[39m\033[0m
" so, do not use the compiler, I just substitute all the escape string with empty string and echo it. = =

" compile the curren less file，save it as css with the same file name,echo the error.
func! g:CompileLess(...)

	let s:min = ""
	let s:line = ""

	"a:000 is the list of arguments
	for nextval in a:000
		if match(nextval,"min") != -1
			let s:min = "--min"
            let g:less_opt = 1
		elseif match(nextval,"line") != -1
			let s:min = "--min"
			let s:line = "--line"
            let g:less_opt = 2
        elseif match(nextval,"auto") != -1
            autocmd! BufWritePost,FileWritePost *.less call g:CompileLess()
            echo "Open auto complie less to css succ! ^_^"
            return 
		endif
	endfor

    let l:input = fnameescape(expand("%:p"))
    let l:output = fnameescape(expand("%:p:r") . ".css")

	"a:0 is the nums of arguments
	if a:0 != 0
		let l:cmd = "cscript //nologo " . $VIMFILES ."\\bin\\less-windows-master\\lessc.wsf " . l:input . " " . l:output ." ".s:min." ".s:line
	else
		"--min --mline
		if (g:less_opt == 1)
			let l:cmd = "cscript //nologo " . $VIMFILES ."\\bin\\less-windows-master\\lessc.wsf " . l:input . " " . l:output ." --min"
		elseif(g:less_opt == 2)
			let l:cmd = "cscript //nologo " . $VIMFILES ."\\bin\\less-windows-master\\lessc.wsf " . l:input . " " . l:output ." --min --line"
		else
			let l:cmd = "cscript //nologo " . $VIMFILES ."\\bin\\less-windows-master\\lessc.wsf " . l:input . " " . l:output
		endif
	endif


	let l:cmd = substitute(l:cmd,'Program Files','Progra~1','g')

	echo "Compile LESS to CSS >_<"
	let l:errs = system(l:cmd)

	if (!empty(l:errs))
		" replace the escape string(\%oxxx match the octal character).  e.g: \033[33m
		let l:errs = substitute(l:errs, "\\%o033[\\d\\+m", "", "g")
		" replace the blank lines
		if has("win32") || has("win64") && exists("iconv") && v:lang == 'zh_CN.utf-8'
			let l:errs = iconv(substitute(l:errs, "^$", "", "g"),"gbk","utf-8")
		else
			let l:errs = substitute(l:errs, "^$", "", "g")
		endif
		" we jsut need the error message
		let l:errss = split(l:errs, "\\n")

		echo l:errs
	else 
		echo "Compiled! ^_^"
	endif
endfunc

" compile less when saving.
if(g:less_complie==1)
	autocmd! BufWritePost,FileWritePost *.less call g:CompileLess()
endif

" defined command
command! -nargs=* -complete=file -bang Less :call g:CompileLess(<f-args>)
cabbrev less <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "Less" : "less"<CR>
"manual conv
map <Leader>lss <esc>:call g:CompileLess()<cr>
