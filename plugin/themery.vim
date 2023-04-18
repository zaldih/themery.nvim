" Prevent load multiple times
if exists('g:loaded_themery')
  finish
endif

command! Themery lua require('themery').themery()

let g:loaded_themery = 1

