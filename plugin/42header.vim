" 42header.vim - Add and update the 42 comment header at the top of your files

" Maintainer:   Adrien Pachkoff <https://adrien.pachkoff.com/>
" Version:      1.1

if exists('g:loaded_42header') || &cp
  finish
endif
let g:loaded_42header = 1

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
      \'^make\|toml\|yaml\|dockerfile\|puppet$':
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
  if a:n == 1 || a:n == 11
    return s:start . ' ' . repeat(s:fill, s:linelen - strlen(s:start) -
          \strlen(s:end) - 2) . ' ' . s:end
  elseif a:n == 2 || a:n == 10
    return s:textline('', '')
  elseif a:n == 3 || a:n == 5 || a:n == 7
    return s:textline('', s:ascii(a:n))
  elseif a:n == 4
    return s:textline(s:filename(), s:ascii(a:n))
  elseif a:n == 6
    return s:textline('By: ' . s:user() . ' <' . s:mail() . '>', s:ascii(a:n))
  elseif a:n == 8
    return s:textline('Created: ' . s:date() . ' by ' . s:user(), s:ascii(a:n))
  elseif a:n == 9
    return s:textline('Updated: ' . s:date() . ' by ' . s:user(), s:ascii(a:n))
  endif
endfunction

function s:user()
  if exists('b:fortytwoheader_user')
    let l:user = b:fortytwoheader_user
  else
    let l:user = $USER
  endif
  if strlen(l:user) == 0
    let l:user = 'marvin'
  endif
  return l:user
endfunction

function s:mail()
  if exists('b:fortytwoheader_mail')
    let l:mail = b:fortytwoheader_mail
  else
    let l:mail = $MAIL
  endif
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

function s:insert()
  let l:line_num = 11

  " from the last line to the first
  call append(0, '') " empty line
  while l:line_num > 0
    call append(0, s:line(l:line_num))
    let l:line_num = l:line_num - 1
  endwhile
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

function s:fortytwoheader()
  if s:update()
    call s:insert()
  endif
endfunction

command! FortyTwoHeader call s:fortytwoheader ()

" This part has moved to ../after/plugin/stdheader.vim
"augroup fortytwoheader
"  autocmd!
"  autocmd BufWritePre * call s:update ()
"augroup END
