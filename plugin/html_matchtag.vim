" Vim plugin for showing matching html tags.
" Maintainer:  Greg Sexton <gregsexton@gmail.com>
" Credits: Bram Moolenar and the 'matchparen' plugin from which this draws heavily.

if exists("b:did_ftplugin")
    fini
en

aug MatchHtmlTag
	au!
	au CursorMoved,CursorMovedI,WinEnter *.html,*.xml,*.xhtml call g:highlightpair()
aug END

fu! g:highlightpair()
	" Remove any previous match.
	if exists('w:tag_hl_on') && w:tag_hl_on
		2match none
		let w:tag_hl_on = 0
	en

	" Avoid that we remove the popup menu.
	" Return when there are no colors (looks like the cursor jumps).
	if pumvisible() || (&t_Co < 8 && !has("gui_running"))
		retu
	en

	" When not in a string or comment ignore matches inside them.
	let hlgrp = synIDattr(synID(line("."), col("."), 0), "name")
	if hlgrp =~? 'htmlString\|htmlComment\|htmlCommentPart'
		retu
	en

	" Get html tag under cursor
	let tagn = s:currenttag()
	if tagn == ""
		retu
	en

	let pos = tagn[0] == '/' ? s:searchpair(tagn[1:], 0) : s:searchpair(tagn, 1)

    "if pos[0] == [0,0]
        "if match(tagn,'/>$') >= 0
            "cal s:highlight(pos[0],'Visual')
        "else
            "cal s:highlight(pos[0],'Error')
        "endif
    "else
        "cal s:highlight(pos[0],pos[1] ? 'Error' : 'Visual')
    "endif
            cal s:highlight(pos[0],'Visual')

endf

fu! s:currenttag()
	" Returns the tag under the cursor, includes the '/' if on a closing tag.
	let c_col   = col('.')
	let expr    = '\(<[^<>]\{-}\%'.c_col.'c[^<>]\{-}>\)\|\(\%'.c_col.'c<[^<>]\{-}>\)'
	let matched = matchstr(getline('.'), expr)
	if matched == "" || matched =~ '/>$'
		retu matched
	en
	retu matchstr(matched, '<\zs.\{-}\ze[ >]')
endf

fu! s:searchpair(tagn, forw)
	" Returns the position of a matching tag or [[0 0], 1] / [[0 0], 0]
	let starttag = '<'.a:tagn.'[^<>]\{-}/\@<!>'
	let midtag   = ''
	let endtag   = '</'.a:tagn.'[^<>]\{-}'.(a:forw ? '' : '\zs').'>'
	let flags    = 'nW'.(a:forw ? '' : 'b')
	let skip = 'synIDattr(synID(line("."), col("."), 0), "name")'
		\ .' =~? ''htmlString\|htmlComment\|htmlCommentPart'''
	let stopline = a:forw ? line('w$') : line('w0')
	let timeout  = 300
    let doerror = 0

    retu [searchpairpos(starttag, midtag, endtag, flags, skip, stopline, timeout), doerror]
endf

fu! s:highlight(pos, hlgrp)
	let [m_lnum, m_col] = a:pos
	let [lnr, cnr] = [line('.'), col('.')]
	exe '2match' a:hlgrp '/\(\%'.m_lnum.'l\%'.m_col.'c<\zs.\{-}\ze[ >]\)\|'
		\ .'\(\%'.lnr.'l\%'.cnr.'c<\zs.\{-}\ze[ >]\)\|'
		\ .'\(\%'.lnr.'l<\zs[^<> ]*\%'.cnr.'c.\{-}\ze[ >]\)\|'
		\ .'\(\%'.lnr.'l<\zs[^<>]\{-}\ze\s[^<>]*\%'.cnr.'c.\{-}>\)/'
	let w:tag_hl_on = 1
endf
