scriptencoding utf-8

" Plugin specification and lua stuff
lua require('plugins')

" Use short names for common plugin manager commands to simplify typing.
" To use these shortcuts: first activate command line with `:`, then input the
" short alias, e.g., `pi`, then press <space>, the alias will be expanded to
" the full command automatically.
call utils#Cabbrev('pi', 'PackerInstall')
call utils#Cabbrev('pud', 'PackerUpdate')
call utils#Cabbrev('pc', 'PackerClean')
call utils#Cabbrev('ps', 'PackerSync')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      configurations for vim script plugin                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""UltiSnips settings"""""""""""""""""""
" Trigger configuration.
let g:UltiSnipsExpandTrigger='<tab>'

" Do not look for SnipMate snippets
let g:UltiSnipsEnableSnipMate = 0

" Shortcut to jump forward and backward in tabstop positions
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

" Configuration for custom snippets directory, see
" https://jdhao.github.io/2019/04/17/neovim_snippet_s1/ for details.
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'my_snippets']

""""""""""""""""""""""""""""open-browser.vim settings"""""""""""""""""""
if g:is_win || g:is_mac
  " Disable netrw's gx mapping.
  let g:netrw_nogx = 1

  " Use another mapping for the open URL method
  nmap ob <Plug>(openbrowser-smart-search)
  xmap ob <Plug>(openbrowser-smart-search)
endif

""""""""""""""""""""""""""" vista settings """"""""""""""""""""""""""""""""""
let g:vista#renderer#icons = {
      \ 'member': '',
      \ }

" Do not echo message on command line
let g:vista_echo_cursor = 0
" Stay in current window when vista window is opened
let g:vista_stay_on_open = 0

nnoremap <silent> <leader>t :<C-U>Vista!!<CR>

""""""""""""""""""""""""vim-mundo settings"""""""""""""""""""""""
let g:mundo_verbose_graph = 0
let g:mundo_width = 80

nnoremap <silent> <leader>u :MundoToggle<CR>

""""""""""""""""""""""""""""better-escape.vim settings"""""""""""""""""""""""""
let g:better_escape_interval = 200

"""""""""""""""""""""""""""""" neoformat settings """""""""""""""""""""""
let g:neoformat_enabled_python = ['black', 'yapf']
let g:neoformat_cpp_clangformat = {
      \ 'exe': 'clang-format',
      \ 'args': ['--style="{IndentWidth: 4}"']
      \ }
let g:neoformat_c_clangformat = {
      \ 'exe': 'clang-format',
      \ 'args': ['--style="{IndentWidth: 4}"']
      \ }

let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']

"""""""""""""""""""""""""vim-markdown settings"""""""""""""""""""
" Disable header folding
let g:vim_markdown_folding_disabled = 1

" Whether to use conceal feature in markdown
let g:vim_markdown_conceal = 1

" Disable math tex conceal and syntax highlight
let g:tex_conceal = ''
let g:vim_markdown_math = 0

" Support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

" Let the TOC window autofit so that it doesn't take too much space
let g:vim_markdown_toc_autofit = 1

"""""""""""""""""""""""""markdown-preview settings"""""""""""""""""""
" Only setting this for suitable platforms
if g:is_win || g:is_mac
  " Do not close the preview tab when switching to other buffers
  let g:mkdp_auto_close = 0

  " Shortcuts to start and stop markdown previewing
  nnoremap <silent> <M-m> :<C-U>MarkdownPreview<CR>
  nnoremap <silent> <M-S-m> :<C-U>MarkdownPreviewStop<CR>
endif

""""""""""""""""""""""""unicode.vim settings""""""""""""""""""""""""""""""
nmap ga <Plug>(UnicodeGA)

""""""""""""""""""""""""""""vim-sandwich settings"""""""""""""""""""""""""""""
" Map s to nop since s in used by vim-sandwich. Use cl instead of s.
nmap s <Nop>
omap s <Nop>

""""""""""""""""""""""""""""vimtex settings"""""""""""""""""""""""""""""
"  if executable('latex')
"    " Hacks for inverse search to work semi-automatically,
"    " see https://jdhao.github.io/2021/02/20/inverse_search_setup_neovim_vimtex/.
"    function! s:write_server_name() abort
"      let nvim_server_file = (has('win32') ? $TEMP : '/tmp') . '/vimtexserver.txt'
"      call writefile([v:servername], nvim_server_file)
"    endfunction

"    augroup vimtex_common
"      autocmd!
"      autocmd FileType tex call s:write_server_name()
"      autocmd FileType tex nmap <buffer> <F9> <plug>(vimtex-compile)
"    augroup END

"    let g:vimtex_compiler_latexmk = {
"          \ 'build_dir' : 'build',
"          \ }

"    " TOC settings
"    let g:vimtex_toc_config = {
"          \ 'name' : 'TOC',
"          \ 'layers' : ['content', 'todo', 'include'],
"          \ 'resize' : 1,
"          \ 'split_width' : 30,
"          \ 'todo_sorted' : 0,
"          \ 'show_help' : 1,
"          \ 'show_numbers' : 1,
"          \ 'mode' : 2,
"          \ }

"    " Viewer settings for different platforms
"    if g:is_win
"      let g:vimtex_view_general_viewer = 'SumatraPDF'
"      let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
"    endif

"    if g:is_mac
"      " let g:vimtex_view_method = "skim"
"      let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
"      let g:vimtex_view_general_options = '-r @line @pdf @tex'

"      augroup vimtex_mac
"        autocmd!
"        autocmd User VimtexEventCompileSuccess call UpdateSkim()
"      augroup END

"      " The following code is adapted from https://gist.github.com/skulumani/7ea00478c63193a832a6d3f2e661a536.
"      function! UpdateSkim() abort
"        let l:out = b:vimtex.out()
"        let l:src_file_path = expand('%:p')
"        let l:cmd = [g:vimtex_view_general_viewer, '-r']

"        if !empty(system('pgrep Skim'))
"          call extend(l:cmd, ['-g'])
"        endif

"        call jobstart(l:cmd + [line('.'), l:out, l:src_file_path])
"      endfunction
"    endif
"  endif

"""""""""""""""""""""""""" asyncrun.vim settings """"""""""""""""""""""""""
" Automatically open quickfix window of 6 line tall after asyncrun starts
let g:asyncrun_open = 6
if g:is_win
  " Command output encoding for Windows
  let g:asyncrun_encs = 'gbk'
endif

""""""""""""""""""""""""""""""nvim-gdb settings""""""""""""""""""""""""""""""
nnoremap <leader>dp :<C-U>GdbStartPDB python -m pdb %<CR>