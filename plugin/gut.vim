if exists('g:loaded_gut') || &cp
	finish
endif
let g:loaded_gut = 1

function! gut#get_gutfiles_path_by_project_name(name)
  return expand('~/.gut/projects/', ':p') . a:name
endfunction

if !exists('g:gut_gutfiles_path_getter')
  let g:gut_gutfiles_path_getter = 'gut#get_gutfiles_path_by_project_name'
endif

function! gut#get_git_root(...)
  if a:0 > 0 && len(a:1) | let current = a:1
  else | let current = expand('%:p:h')
  endif
  return system('cd ' . current . ' && git rev-parse --show-toplevel')[:-2]
endfunction

function! gut#open_gutfile()
  let current_file =  expand('%:p')
  let path = fnamemodify(current_file, ':h')
  let git_root = gut#get_git_root(path)
  let F = function(g:gut_gutfiles_path_getter) 
  let gutfiles_path = F(fnamemodify(git_root, ':t'))
  let relative_path = strpart(current_file, len(git_root) + 1)
  let gutfile = gutfiles_path . '/.gut/' . relative_path . '.tnt'

  let gutfile_path = fnamemodify(gutfile, ':p:h')
  if !isdirectory(gutfile_path)
    call mkdir(gutfile_path, 'p')
  endif
  exe 'edit ' gutfile 
endfunction

nnoremap <silent> <C-G> :<C-U>call gut#open_gutfile()<CR>
