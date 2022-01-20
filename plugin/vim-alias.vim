" Vim-Alias
" Edit 2022/1/19 12:50:52
" 插件修改自 https://github.com/tomarrell/vim-npr
" Max number of directory levels gf will traverse upwards
" to find a .vim-alias file.
" .vim-alias格式 { "resolve": [["@", "src"], ["ALIAS", "DIST"]]}
if !exists("g:vim_alias_max_levels")
  let g:vim_alias_max_levels = 6
endif

" Default file names to try if gf is run on a directory rather than a specific file.
" Checked in order of appearance. Empty string to check for exact file match first.
" The final two are specifically for matching libraries which define their UMD
" module resolution in their .vim-alias, and these are the most common.
if !exists("g:vim_alias_file_names")
  let g:vim_alias_file_names = ["", ".js", ".jsx", "/index.js", "/index.jsx", "/src/index.js", "/lib/index.js", "/src/main.ts"]
endif

" A list of file extensions that the plugin will actively work on.
if !exists("g:vim_alias_file_types")
  let g:vim_alias_file_types = ["js", "jsx", "css", "coffee", "vue", "ts", "scss", "d.ts"]
endif

" Default resolution directories if 'resolve' key is not found in package.json.
if !exists("g:vim_alias_default_dirs")
  let g:vim_alias_default_dirs = ["src", "lib", "test", "public", "node_modules"]
endif

function! VimAliasFindFile(cmd) abort
  " Get file path pattern under cursor
  let l:cfile = expand("<cfile>")

  " 判断是否是标识中的后缀名，否则直接打开
  if index(g:vim_alias_file_types, expand("%:e")) == -1
    "return s:print_error("(Error) VimAlias: incorrect file type for to perform resolution within. Please raise an issue at github.com/tomarrell/vim-npr.") " Don't run on filetypes that we don't support
    return s:edit_file(l:cfile, a:cmd)
  endif

  " Iterate over potential directories and search for the file
  for filename in g:vim_alias_file_names
    let l:possiblePath = expand("%:p:h") . '/' . l:cfile . filename

    if filereadable(l:possiblePath)
      return s:edit_file(l:possiblePath, a:cmd)
    endif
  endfor

  let l:foundAlias = 0
  let l:levels = 0
  let l:aliasJSON = '.vim-alias'

  " Traverse up directories and attempt to find .vim-alias
  " 向上查找 .vim-alias
  while l:foundAlias != 1 && l:levels < g:vim_alias_max_levels
    let l:levels = l:levels + 1
    let l:foundAlias = filereadable(expand('%:p'.repeat(':h', l:levels)) . '/' . l:aliasJSON)
  endwhile

  if l:foundAlias == 0
    if filereadable(l:cfile)
      return s:edit_file(l:cfile, a:cmd)
    endif
    return s:print_error("(Error) VimAlias: Failed to find " . l:aliasJSON . ", try increasing the levels by increasing g:vim_alias_max_levels variable.")
  endif

  " Handy paths to package.json and parent dir
  let l:packagePath = globpath(expand('%:p'.repeat(':h', l:levels)), l:aliasJSON)
  let l:packageDir = fnamemodify(l:packagePath, ':h')

  try
    let l:resolveDirs = json_decode(join(readfile(l:packagePath))).resolve
  catch
    echo "Couldn't find 'resolve' key in " . l:aliasJSON
    let l:resolveDirs = g:vim_alias_default_dirs
  endtry

  " Iterate over potential directories and search for the file
  for dir in l:resolveDirs
    let l:tmpcfile = substitute(l:cfile, "^" . dir[0] . "/", dir[1] . "/", 'g')

    if l:cfile =~ '^\~'
      let l:possiblePath = substitute(l:cfile, '\~', l:packageDir . "/" . l:tmpcfile, 'g')
    else
      let l:possiblePath = l:packageDir . "/" . l:tmpcfile
    endif

    for filename in g:vim_alias_file_names
      if filereadable(possiblePath . filename)
        return s:edit_file(possiblePath . filename, a:cmd)
      endif
    endfor
  endfor

  " Nothing found, print resolution error
  return s:print_error("(Error) VimAlias: Failed to sensibly resolve file in path. If you believe this to be an error, please log an error at github.com/tomarrell/vim-npr.")
endfunction

function! s:edit_file(path, cmd)
  exe "edit" . a:cmd . " " . a:path
endfunction

function! s:print_error(error)
  echohl ErrorMsg
  echomsg a:error
  echohl NONE
  let v:errmsg = a:error
endfunction

" Unmap any user mapped gf functionalities. This is to restore gf
" when hijacked by another plugin e.g. vim-node
autocmd FileType javascript,vue,typescript silent! unmap <buffer> gf
autocmd FileType javascript,vue,typescript silent! unmap <buffer> <C-w>f
autocmd FileType javascript,vue,typescript silent! unmap <buffer> <C-w><C-f>

" Automap gf when entering JS/css file types
autocmd BufEnter *.js,*.jsx,*.css,*.coffee nmap <buffer> gf :call VimAliasFindFile("")<CR>
