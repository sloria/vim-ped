# ped.vim

Quickly open Python modules based on Python import paths.

This is particularly useful for viewing/editing third-party packages in a virtual environment.

## Quickstart

```vim
:Ped <path.to.module>
```

### Examples

```vim
:Ped django.shortcuts
:Ped django.views.generic.TemplateView

" Partial matches work, too
:Ped django.views.generic.Templ
```

## Installation

Requires the [ped](https://pypi.python.org/pypi/ped) Python package (installable with `pip`).

```bash
$ pip install -U ped
```

Then add this plugin using your favorite plugin manager.

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
" ~/.vimrc
Plug 'sloria/vim-ped'
```
## Defining mappings

- `<Plug>PedPrompt`: Shortcut to input `:Ped ` in the command line.
- `<Plug>PedVword`: Input `:Ped pkg` in the command line, where "pkg" is the current visual selection.
- `<Plug>PedVwordExec`: Like `<Plug>PedVword`, but executes immediately.
- `<Plug>PedCword`: Input `:Ped pkg` in the command line, where "pkg" is the current word under the cursor.
- `<Plug>PedCwordExec`: Like `<Plug>PedCword`, but executes immediately.


### Example mappings

```vim
nmap <leader>e <Plug>PedPrompt
nmap <leader>E <Plug>PedCwordExec
vmap <leader>e <Plug>PedVwordExec
```

## Configuration

```vim
" Vim command to open files, defaults to 'edit'
" Examples: 'tabedit', 'split', 'vsplit'
let g:ped_edit_command = 'edit'

" ped executable, defaults to 'ped'
let g:ped_executable = 'ped'
```

## License

[MIT Licensed](http://sloria.mit-license.org).
