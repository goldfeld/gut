if exists('g:loaded_gut') || &cp
	finish
endif
let g:loaded_gut = 1

function! gut#get_current_root()
  let current = expand('%:p')
  return system('cd ' . current .
    \ ' && git rev-parse --show-toplevel')
endfunction

nnoremap <silent> <C-G> :<C-U>echo gut#get_current_root()<CR>
