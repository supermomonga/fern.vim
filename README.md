# 🌿 fern.vim

![Support Vim 8.1 or above](https://img.shields.io/badge/support-Vim%208.1%20or%20above-yellowgreen.svg)
![Support Neovim 0.4 or above](https://img.shields.io/badge/support-Neovim%200.4%20or%20above-yellowgreen.svg)
[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)
[![Powered by vital-Whisky](https://img.shields.io/badge/powered%20by-vital--Whisky-80273f.svg)](https://github.com/lambdalisue/vital-Whisky)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20fern-orange.svg)](doc/fern.txt)
[![Doc (dev)](https://img.shields.io/badge/doc-%3Ah%20fern--develop-orange.svg)](doc/fern-develop.txt)

[![reviewdog](https://github.com/lambdalisue/fern.vim/workflows/reviewdog/badge.svg)](https://github.com/lambdalisue/fern.vim/actions?query=workflow%3Areviewdog)
[![vim](https://github.com/lambdalisue/fern.vim/workflows/vim/badge.svg)](https://github.com/lambdalisue/fern.vim/actions?query=workflow%3Avim)
[![neovim](https://github.com/lambdalisue/fern.vim/workflows/neovim/badge.svg)](https://github.com/lambdalisue/fern.vim/actions?query=workflow%3Aneovim)

General purpose asynchronous tree viewer written in Pure Vim script.

<p align="center">
<img src="https://user-images.githubusercontent.com/546312/73183241-d89aa980-415d-11ea-876f-30bd4d80f0cd.png">
<small><strong>Split windows</strong></small>
</p>
<p align="center">
<img src="https://user-images.githubusercontent.com/546312/73183310-f10ac400-415d-11ea-80c8-af1609294889.png">
<small><strong>Project drawer</strong></small>
</p>

## Concept

- Supports both Vim and Neovim without any external dependencies
- Support _split windows_ and _project drawer_ explained in [this article](http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/)
- Provide features as actions so that user don't have to remember mappings
- Make operation asynchronous as much as possible to keep latency
- User experience is more important than simplicity (maintainability)
- Custamizability is less important than simplicity (maintainability)
- Easy to create 3rd party plugins to support any kind of trees

## Installation

fern.vim has no extra dependencies so use your favorite Vim plugin manager or see [How to install](https://github.com/lambdalisue/fern.vim/wiki/How-to-install) page for detail.

## Usage

### Command (Split windows)

![Screencast of Split windows](https://user-images.githubusercontent.com/546312/73183457-29120700-415e-11ea-8d04-cb959659e369.gif)

Open fern on a current working directory by:

```vim
:Fern .
```

Or open fern on a parent directory of a current buffer by:

```vim
:Fern %:h
```

Or open fern on a current working directory with a current buffer focused by:

```vim
:Fern . -reveal=%
```

![](https://user-images.githubusercontent.com/546312/73183700-9aea5080-415e-11ea-8bca-e1dea78d24ca.png)

The following options are available for fern viewer.

| Option    | Default | Description                                                                         |
| --------- | ------- | ----------------------------------------------------------------------------------- |
| `-opener` | `edit`  | An opener to open the buffer. See `:help fern-opener` for detail.                   |
| `-reveal` |         | Recursively expand branches and focus the node. See `:help fern-reveal` for detail. |
| `-stay`   |         | Stay focus on the window where the command has called.                              |

```
:Fern {url} [-opener={opener}] [-reveal={reveal}] [-stay]
```

### Command (Project drawer)

![Screencast of Project drawer](https://user-images.githubusercontent.com/546312/73184080-324fa380-415f-11ea-8280-e0b6c7a9989f.gif)

All usage above open fern as [*split windows style*][]. To open fern as [*project drawer style*][], use `-drawer` option like:

```vim
:Fern . -drawer
```

A fern window with _project drawer_ style always appeared to the most left side of Vim and behaviors of some mappings/actions are slightly modified (e.g. a buffer in the next window will be used as an anchor buffer in a project drawer style to open a new buffer.)

Note that addtional to the all options available for _split windows_ style, _project drawer_ style enables the follwoing options:

| Option    | Default | Description                                                      |
| --------- | ------- | ---------------------------------------------------------------- |
| `-width`  | `30`    | The width of the project drawer window                           |
| `-keep`   |         | Disable to quit Vim when there is only one project drawer buffer |
| `-toggle` |         | Close existing project drawer rather than focus                  |

```
:Fern {url} -drawer [-opener={opener}] [-reveal={reveal}] [-stay] [-width=30] [-keep] [-toggle]
```

[*split windows style*]: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
[*project drawer style*]: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/

### Actions

To execute actions, hit `a` on a fern buffer and input an action to perform.
To see all actions available, hit `?` or execute `help` action then all available actions will be listed.

![Actions](https://user-images.githubusercontent.com/546312/73184453-c91c6000-415f-11ea-8e6b-f1df4b9284de.gif)

### Window selector

The `open:select` action open a prompt to visually select window to open a node.
This feature is strongly inspired by [t9md/vim-choosewin][].

![Window selector](https://user-images.githubusercontent.com/546312/73605707-090e9780-45e5-11ea-864a-457dd785f1c4.gif)

[t9md/vim-choosewin]: https://github.com/t9md/vim-choosewin

### Renamer action (A.k.a exrename)

The `rename` action open a new buffer with path of selected nodes.
Users can edit that buffer and `:w` applies the changes.
This feature is strongly inspired by [shougo/vimfiler.vim][].

![Renamer](https://user-images.githubusercontent.com/546312/73184814-5d86c280-4160-11ea-9ed1-d5a8d66d1774.gif)

[shougo/vimfiler.vim]: https://github.com/Shougo/vimfiler.vim

## Customize

Use `FileType fern` autocmd to execute initialization scripts for fern buffer like:

```vim
function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
```

The `FileType` autocmd will be invoked AFTER a fern buffer has initialized but BEFORE contents of a buffer become ready.
So avoid accessing actual contents in the above function.

See [Wiki](https://github.com/lambdalisue/fern.vim/wiki) pages to find tips, or write pages to share your tips ;-)

# Plugins

Fern supports the following types of plugins:

| Type            | Description                                                                                                                                                                                                   |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Renderer        | Renderer is used to display a tree in a fern buffer. Changing it affect the visual looks of fern.<br>e.g. [lambdalisue/fern-renderer-devicons.vim](https://github.com/lambdalisue/fern-renderer-devicons.vim) |
| Comparator      | Comparator is used to compare nodes. Changing it affect the order of nodes in a tree.<br>e.g. [lambdalisue/fern-comparator-lexical.vim](https://github.com/lambdalisue/fern-comparator-lexical.vim)           |
| Mapping         | Mapping is used to provide extra mappings. Adding it to provide extra mappings.<br>e.g. [lambdalisue/fern-mapping-project-top.vim](https://github.com/lambdalisue/fern-mapping-project-top.vim)               |
| Scheme provider | Scheme provider is used to generate a tree from URI. Adding it to support extra scheme.<br>e.g. [lambdalisue/fern-bookmark.vim](https://github.com/lambdalisue/fern-bookmark.vim)                             |
| Scheme mapping  | Scheme mapping is used to provide scheme sepcific mappings. Adding it to provide extra scheme mappings.<br>e.g. [lambdalisue/fern-bookmark.vim](https://github.com/lambdalisue/fern-bookmark.vim)             |

Please add a following badge to indicate that your plugin is for fern.

[![fern plugin](https://img.shields.io/badge/🌿%20fern-plugin-yellowgreen)](https://github.com/lambdalisue/fern.vim)

```
[![fern plugin](https://img.shields.io/badge/🌿%20fern-plugin-yellowgreen)](https://github.com/lambdalisue/fern.vim)
```

See [Wiki](https://github.com/lambdalisue/fern.vim/wiki) pages to find more 3rd-party plugins or share yours ;-)

# Contribution

Any contribution including documentations are welcome.

Contributors who change codes should install [thinca/vim-themis][] to run tests before complete a PR.
PRs which does not pass tests won't be accepted.

[thinca/vim-themis]: https://github.com/thinca/vim-themis

# License

The code in fern.vim follows MIT license texted in [LICENSE](./LICENSE).
Contributors need to agree that any modifications sent in this repository follow the license.
