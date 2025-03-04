let s:self = {}


let s:self.begin = '^<!-- wsdjeg repos start -->$'
let s:self.end = '^<!-- wsdjeg repos end -->$'
let s:self.content_func = ''
let s:self.autoformat = 0


function! s:self._find_position() abort
  let start = search(self.begin,'bwnc')
  let end = search(self.end,'bnwc')
  return sort([start, end], 'n')
endfunction


function! s:self.update(...) abort
  let [start, end] = self._find_position()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, call(self.content_func, a:000))
  endif
endfunction


function! s:generate_content() abort
        let repos = ['flygrep.nvim', 'nvim-plug', 'tasks.nvim', 'code-runner.nvim', 'tabline.nvim', 'statusline.nvim', 'todo.nvim']
        let lines = []
        for repo in repos
                call add(lines, '<a href="https://github.com/wsdjeg/' . repo . '">')
                call add(lines, '  <img align="center" src="https://github-readme-stats.vercel.app/api/pin/?username=wsdjeg&repo=' . repo . '" />')
                call add(lines, '</a>')
                call add(lines, '')
        endfor
        return lines
endfunction

let s:self.content_func = function('s:generate_content')

call s:self.update()
