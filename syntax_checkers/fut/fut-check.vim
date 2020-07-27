if exists('g:loaded_syntastic_fut_futhark_checker')
    finish
endif
let g:loaded_syntastic_fut_futhark_checker = 1

let g:syntastic_fut_futhark_exec = 'futhark'

function! StripANSI(errors) abort " {{{2
   
    let errlist = copy(a:errors)
    let out = []

    for e in a:errors
        call add(out, substitute(e, '\e\[[0-9;]\+m', '', 'g'))
    endfor

    return out

endfunction " }}}2

function! SyntaxCheckers_fut_futhark_GetLocList() dict
    let makeprg = self.makeprgBuild({
                \ 'exe': self.getExec(),
                \ 'args': 'check',
                \ 'fname': shellescape(expand('%') )})

    let errorformat =
        \ '%EError at %f:%l:%c-%m,' .
        \ '%m,%Z'

    let loclist = SyntasticMake({
            \ 'makeprg': makeprg,
            \ 'errorformat': errorformat,
            \ 'Preprocess': 'StripANSI' })

    return loclist

endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'fut',
    \ 'name': 'futhark' })
