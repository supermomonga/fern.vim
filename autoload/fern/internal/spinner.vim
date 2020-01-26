let s:Spinner = vital#fern#import('App.Spinner')
let s:frames = s:Spinner.dots

function! fern#internal#spinner#start(...) abort
  let bufnr = a:0 ? a:1 : bufnr('%')
  if getbufvar(bufnr, 'fern_spinner_timer' , v:null) isnot# v:null
    return
  endif
  let spinner = s:Spinner.new(map(
        \ copy(s:frames),
        \ { k -> printf('FernSignSpinner%d', k) },
        \))
  call setbufvar(bufnr, 'fern_spinner_timer', timer_start(
        \ 50,
        \ { t -> s:update(t, spinner, bufnr) },
        \ { 'repeat': -1 },
        \))
endfunction

function! s:update(timer, spinner, bufnr) abort
  let fern = getbufvar(a:bufnr, 'fern', v:null)
  let winid = bufwinid(a:bufnr)
  if fern is# v:null || winid is# -1
    call timer_stop(a:timer)
    return
  endif
  let frame = a:spinner.next()
  call execute(printf('sign unplace * group=fern buffer=%d', a:bufnr))
  let info = getwininfo(winid)[0]
  for lnum in range(info.topline, info.botline)
    let node = get(fern.visible_nodes, lnum - 1, v:null)
    if node is# v:null
      return
    elseif node.__processing is# 0
      continue
    endif
    call execute(printf(
          \ 'sign place %d group=fern line=%d name=%s buffer=%d',
          \ lnum,
          \ lnum,
          \ frame,
          \ a:bufnr,
          \))
  endfor
endfunction

function! s:define_signs() abort
  for index in range(len(s:frames))
    call execute(printf(
          \ 'sign define FernSignSpinner%d text=%s',
          \ index,
          \ s:frames[index],
          \))
  endfor
endfunction

call s:define_signs()