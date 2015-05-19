"=============================================================================
"     FileName: ajaxminIMiku.vim
"         Desc: Use Microsoft Ajax Minifier 5 for JS/CSS
"       Author: Ryu
"        Email: neko@imiku.com
"     HomePage: http://www.imiku.com/
"      Version: 0.0.3
"   LastChange: 2015-05-19 11:34:54
"      History:
"=============================================================================

if !exists("g:ajaxmin_cmd")
    let g:ajaxmin_cmd = $VIMFILES.'/bin/Microsoft-Ajax-Minifier-4/AjaxMin.exe'
    let g:ajaxmin_cmd_jsopt = '-clobber:true -term'
    let g:ajaxmin_cmd_cssopt = '-clobber:true -term -comments:hacks'
endif

func! g:CompileAjaxMinJsCss(...)

	let s:cur = ""
	"a:000 is the list of arguments
	for nextval in a:000
		if match(nextval,"cur") != -1
			let s:cur = "--cur"
		endif
	endfor

	"step1
	let l:fenc = &fenc
	if (l:fenc=='utf-8')
		let l:fenc = 'utf-8'
	elseif (l:fenc=='cp936')
		let l:fenc = 'gb2312'
	else 
		let l:fenc = 'utf-8'
	endif

	"step2
    let l:type = &filetype

	if empty(l:type)
		echo "No input file! m(_ _)m"
		return
	endif

	"step2
    let l:input = fnameescape(expand("%:p"))
    if match(l:input, '\.js$') != -1
		let l:output = fnameescape(expand("%:p:r") . ".min.js")
		let l:cmd = g:ajaxmin_cmd.' -JS '.l:input.' -enc:in '.l:fenc.' -out '.l:output.' -enc:out '.l:fenc.' '.g:ajaxmin_cmd_jsopt
    elseif match(l:input, '\.css$') != -1
		if !empty(s:cur)
			let l:output = fnameescape(expand("%:p:r") . ".css")
		else
			let l:output = fnameescape(expand("%:p:r") . ".min.css")
		endif
		let l:cmd = g:ajaxmin_cmd.' -CSS '.l:input.' -enc:in '.l:fenc.' -out '.l:output.' -enc:out '.l:fenc.' '.g:ajaxmin_cmd_cssopt
    elseif match(l:input, '\.less$') != -1
		let l:input = fnameescape(expand("%:p:r") . ".css")
		let l:output = l:input
		let l:cmd = g:ajaxmin_cmd.' -CSS '.l:input.' -enc:in '.l:fenc.' -out '.l:output.' -enc:out '.l:fenc.' '.g:ajaxmin_cmd_cssopt
	else
		echo "JS、CSS、LESS only! m(_ _)m"
		return
	endif
	let l:cmd = substitute(l:cmd,'Program Files','Progra~1','g')
	let l:cmd = iconv(l:cmd,"utf-8","gbk")

	echo "Compile Js Minifier >_<"
	let l:errs = system(l:cmd)

	if (!empty(l:errs))
		if has("win32") || has("win64") && exists("iconv") && v:lang == 'zh_CN.utf-8'
			let l:errs = iconv(substitute(l:errs, "^$", "", "g"),"gbk","utf-8")
		else
			let l:errs = substitute(l:errs, "^$", "", "g")
		endif
		" we jsut need the message
		"let l:errs = split(l:errs, "\\n")[1]
		let l:errs = split(l:errs, "Minifying ")[1]

		echo l:errs
	endif
	echo "Compiled! ^_^"
endfunc

"
if executable(g:ajaxmin_cmd)
	map <Leader>mmi <esc>:call g:CompileAjaxMinJsCss()<cr>
endif
" defined command
command! -nargs=* -complete=file -bang Ajaxmin :call g:CompileAjaxMinJsCss(<f-args>)
cabbrev Ajaxmin <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "Ajaxmin" : "ajaxmin"<CR>
