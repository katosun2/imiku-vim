"=============================================================================
"     FileName: explorerIMiku.vim
"         Desc: open path for win
"       Author: Ryu
"        Email: neko@imiku.com
"     HomePage: http://www.imiku.com/
"      Version: 0.0.2
"   LastChange: 2015-06-05 11:05:06
"      History:
"=============================================================================
let g:explorer_cmd = 'explorer'

func! g:ExplorerPath(...)
	let l:input = getcwd()
	let l:cmd = g:explorer_cmd . ' "' .l:input . '"'
	"let l:cmd = substitute(l:cmd,'Program Files','Progra~1','g')
	let l:cmd = iconv(l:cmd,"utf-8","gbk")
	let l:errs = system(l:cmd)
endfunc

" defined command
command! -nargs=* -complete=file -bang OpenPath :call g:ExplorerPath(<f-args>)
cabbrev OpenPath <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "OpenPath" : "openpath"<CR>
