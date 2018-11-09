# 42header.vim

Add and update the [42](http://42.fr/) comment header at the top of your files

## Installation

The `$USER` and `$MAIL` environment variables must be set (in your `zshrc` or
`bashrc` file), unless `b:fortytwoheader_user` and/or `b:fortytwoheader_mail`
are defined, in which case they are used instead.

### Install with [vim-plug](https://github.com/junegunn/vim-plug)

Add to `vimrc` file:

``` vim
Plug 'pandark/42header.vim'
```

And install it:

``` sh
vim +PlugInstall +qall
```

### Install with [pathogen](https://github.com/tpope/vim-pathogen)

``` sh
git clone https://github.com/pandark/42header.vim.git ~/.vim/bundle/42header.vim
```

## Stdheader plugin desactivation

42header.vim removes the autocomand set on `BufWritePre` by `stdheader.vim`
plugin so that the header is not updated if the file has not been modified.

You can optionally add this line to also remove the command `Stdheader` from
the same plugin:

``` vim
delcommand Stdheader
```

## Usage

- Type `:FortyTwoHeader` or use the key mapping you've assigned to it.
- Make some change to the file, then save it. The header will update
    automatically.

## Key mapping

Add the following line to your `vimrc` file so you can add the
header by pressing <kbd>F1</kbd> key:

``` vim
nmap <f1> :FortyTwoHeader<CR>
```

## User-defined delimiters

You can use `b:fortytwoheader_delimiters` to set or override the characters
used in the header borders. E.g. add support for Django templates by
adding the following line to your `vimrc` file:

``` vim
autocmd FileType htmldjango let b:fortytwoheader_delimiters=['{#', '#}', '*']
```

## Credits

Author: [Adrien "Pandark" Pachkoff](https://github.com/pandark)

Original plugin: [zaz](https://github.com/zazard)

Some ideas stolen from [pbondoer](https://github.com/pbondoer).

## Contributing

Pull requests welcome!

## Bug Reports

Report a bug on [GitHub Issues](https://github.com/pandark/42header.vim/issues).

## License

Distributed under the MIT license. See the LICENSE file.
