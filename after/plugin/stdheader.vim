if exists('g:loaded_42header_after') || &cp
  finish
endif
let g:loaded_42header_after = 1

let s:linelen = 80
let s:framelen = 5

let s:asciiart = [
      \'        :::      ::::::::',
      \'      :+:      :+:    :+:',
      \'    +:+ +:+         +:+  ',
      \'  +#+  +:+       +#+     ',
      \'+#+#+#+#+#+   +#+        ',
      \'     #+#    #+#          ',
      \'    ###   ########.fr    '
      \]

let s:types   = {
      \'^c\|cpp\|php\|objc\|objcpp\|cuda\|less$':
      \['/*', '*/', '*'],
      \'^html\|markdown\|xml\|pandoc\|eruby\|jinja$':
      \['<!--', '-->', '*'],
      \'^html.mustache\|html.hbs\|html.handlebars$':
      \['{{!--', '--}}', '*'],
      \'^javascript\|javascript\.jsx\|typescript\|sass\|scss$':
      \['//', '//', '*'],
      \'^rust\|scala\|swift\|go\|java\|groovy':
      \['//', '//', '*'],
      \'^prolog\|lprolog\|tex\|erlang$':
      \['%', '%', '*'],
      \'^ocaml\|omlet\|applescript\|pascal$':
      \['(*', '*)', '*'],
      \'^vim$':
      \['"', '"', '*'],
      \'^lisp\|clojure\|scheme\|llvm\|nasm\|armasm\|gitconfig$':
      \[';', ';', '*'],
      \'^fortran$':
      \['!', '!', '/'],
      \'^sql\|lua\|ada\|vhdl$':
      \['--', '--', '*'],
      \'^haml$':
      \['-#', '#-', '*'],
      \'^pug\|jade$':
      \['//-', '-//', '*'],
      \'^haskell$':
      \['{-', '-}', '*'],
      \'^lhaskell$':
      \['>{-', '-}', '*'],
      \'^man$':
      \['."', '".', '*'],
      \'^python\|ruby\|perl\|julia\|elixir\|r\|sh\|zsh\|snippets\|po$':
      \['#', '#', '*'],
      \'^toml\|yaml\|dockerfile\|puppet$':
      \['#', '#', '*']
      \}

function s:delimiters()
  let l:ft = &filetype

  let s:start = '/*'
  let s:end = '*/'
  let s:fill  = '*'

  if exists('b:fortytwoheader_delimiters') &&
        \exists('b:fortytwoheader_delimiters[0]') &&
        \exists('b:fortytwoheader_delimiters[1]') &&
        \exists('b:fortytwoheader_delimiters[2]')
    let s:start = b:fortytwoheader_delimiters[0]
    let s:end = b:fortytwoheader_delimiters[1]
    let s:fill = b:fortytwoheader_delimiters[2]
  else
    for type in keys(s:types)
      if l:ft =~ type
        let s:start = s:types[type][0]
        let s:end = s:types[type][1]
        let s:fill  = s:types[type][2]
      endif
    endfor
  endif

endfunction

function s:ascii(n)
  return s:asciiart[a:n - 3]
endfunction

function s:textline(left, right)
  let l:leftlen = strpart(a:left, 0, s:linelen - s:framelen * 3 - strlen(a:right))

  return s:start . repeat(' ', s:framelen - strlen(s:start)) . l:leftlen .
        \repeat(' ', s:linelen - s:framelen * 2 - strlen(l:leftlen) -
        \strlen(a:right)) . a:right . repeat(' ', s:framelen - strlen(s:end))
        \. s:end
endfunction

function s:line(n)
  if a:n == 4
    return s:textline(s:filename(), s:ascii(a:n))
  elseif a:n == 9
    return s:textline('Updated: ' . s:date() . ' by ' . s:user(), s:ascii(a:n))
  endif
endfunction

function s:user()
  let l:user = $USER
  if strlen(l:user) == 0
    let l:user = 'marvin'
  endif
  return l:user
endfunction

function s:mail()
  let l:mail = $MAIL
  if strlen(l:mail) == 0
    let l:mail = 'marvin@42.fr'
  endif
  return l:mail
endfunction

function s:filename()
  let l:filename = expand('%:t')
  if strlen(l:filename) == 0
    let l:filename = 'unnamed'
  endif
  return l:filename
endfunction

function s:date()
  return strftime('%Y/%m/%d %H:%M:%S')
endfunction

function s:update()
  call s:delimiters()
  if getline(9) =~ s:start . repeat(' ', s:framelen - strlen(s:start)) .
        \'Updated: '
    if &mod
      call setline(9, s:line(9))
    endif
    call setline(4, s:line(4))
    return 0
  endif
  return 1
endfunction

" Remove stdheader plugin autocmd
autocmd! BufWritePre *

augroup fortytwoheader
  autocmd!
  autocmd BufWritePre * call s:update ()
augroup END
