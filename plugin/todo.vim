"vim/_editor.lua:0: /home/lisboa/.config/nvim/init.lua..nvim_exec2() called at /home/lisboa/.config/nvim/init.lua:0../home/lisboa/Documentos/todo.nvim/plugin/todo.vim, line 18: Vim(lua):E5107: Error loading lua [string ":lua"]:1: unexpected symbol near '..'

" Tittle:     todo.nvim
" Maintainer:     @ChrisArthLisboa
" Last Change: 2024-04-17
" Version:    0.1.0
" License:    

" This is a simple todo list plugin for neovim.


if exists('g:loaded_todo_nvim')
  finish
endif

let g:loaded_todo_nvim = 1

let s:todo_file = expand('<sfile>:h:r') . "/../lua/todo_nvim/deps"
exe "lua package.path = package.path .. ';" . s:todo_file . "/lua-?/init.lua'"

command! -nargs=0 FetchTasks lua require('todo_nvim').fetch_tasks()
command! -nargs=0 AddTask lua require('todo_nvim').add_task()
command! -nargs=0 RemoveTask lua require('todo_nvim').remove_task()
command! -nargs=0 CompleteTask lua require('todo_nvim').complete_task()
