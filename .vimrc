set nocompatible              " be iMproved, required
filetype off                  " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"               vim-plug
"
    call plug#begin()

    " plugins
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-rooter'
    Plug 'altercation/vim-colors-solarized'
    Plug 'brookhong/cscope.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on    " required

syntax enable

let mapleader="\<Space>"
set backspace=indent,eol,start
set hidden
set showcmd

" " Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

let g:loaded_matchparen=1


" Tabs {{{
" Only do this part when compiled with support for autocommands.
    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
    " For everything else
    set expandtab       " Expand TABs to spaces.
    set tabstop=4       " The width of a TAB is set to 4.
    set softtabstop=-1  " if negative, use tabstop
    set shiftwidth=0    " if 0, use tabstop
    set smarttab
    nnoremap zx z<cr>
" }}}

" UI Layout {{{
    set number              " show line numbers
    set relativenumber
    set showcmd             " show command in bottom bar
    set wildmenu
    set showmatch           " higlight matching parenthesis
    set cursorline
    autocmd ColorScheme * hi CursorLineNr cterm=bold
" }}}

" Searching {{{
    set incsearch           " search as characters are entered
"set hlsearch            " highlight all matches
" }}}

" Folding {{{
    set foldmethod=indent   " fold based on indent level
    set foldnestmax=10      " max 10 depth
    set foldenable          " don't fold files by default on open
    set foldlevelstart=10    " start with fold level of 1
" }}}

" Misc {{{
    set signcolumn=yes
    set scrolloff=8
" }}}

" Backups {{{
set backup 
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set backupskip=/tmp/*,/private/tmp/* 
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set writebackup
" }}}

" Leader Shortcuts {{{
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader><space> :noh<CR>
" }}}

" Save file {{{
noremap <C-S>          :update<CR>
vnoremap <C-S>         <C-C>:update<CR>
inoremap <C-S>         <C-O>:update<CR>
" }}}

" CSCOPE {{{
if has("cscope")
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=1

    " show msg when any other cscope db added
    set cscopeverbose  

    " a: Find assignments to symbol
    nnoremap  <leader>ca :call CscopeFind('a', expand('<cword>'))<CR>
    " s: Find this C symbol
    nnoremap  <leader>cs :call CscopeFind('s', expand('<cword>'))<CR>
    " g: Find this definition
    nnoremap  <leader>cg :call CscopeFind('g', expand('<cword>'))<CR>
    " d: Find functions called by this function
    nnoremap  <leader>cd :call CscopeFind('d', expand('<cword>'))<CR>
    " c: Find functions calling this function
    nnoremap  <leader>cc :call CscopeFind('c', expand('<cword>'))<CR>
    " t: Find this text string
    nnoremap  <leader>ct :call CscopeFind('t', expand('<cword>'))<CR>
    " e: Find this egrep pattern
    nnoremap  <leader>ce :call CscopeFind('e', expand('<cword>'))<CR>
    " f: Find this file
    nnoremap  <leader>cf :call CscopeFind('f', expand('<cword>'))<CR>
    " i: Find files #including this file
    nnoremap  <leader>ci :call CscopeFind('i', expand('<cword>'))<CR>

    nnoremap <leader>cx :call CscopeFindInteractive(expand('<cword>'))<CR>
    nnoremap <leader>cl :call ToggleLocationList()<CR>
    
endif
" }}}

" Splits are created to the right and bottom
set splitbelow
set splitright

" Color {{{
colorscheme solarized
"if strftime("%H") < 17 && strftime("%H") > 7
"    set background=light
"else
    set background=dark
"endif
" }}}

" Buffers {{{
nnoremap <F5> :buffers<CR>:buffer<Space>
" }}}

set tags=./tags;$HOME

" FZF {{{
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:update_fzf_colors()
  let rules =
  \ { 'fg':      [['Normal',       'fg']],
    \ 'bg':      [['Normal',       'bg']],
    \ 'hl':      [['Comment',      'fg']],
    \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
    \ 'bg+':     [['CursorColumn', 'bg']],
    \ 'hl+':     [['Statement',    'fg']],
    \ 'info':    [['PreProc',      'fg']],
    \ 'prompt':  [['Conditional',  'fg']],
    \ 'pointer': [['Exception',    'fg']],
    \ 'marker':  [['Keyword',      'fg']],
    \ 'spinner': [['Label',        'fg']],
    \ 'header':  [['Comment',      'fg']] }
  let cols = []
  for [name, pairs] in items(rules)
    for pair in pairs
      let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
      if !empty(name) && code > 0
        call add(cols, name.':'.code)
        break
      endif
    endfor
  endfor
  let s:orig_fzf_default_opts = get(s:, 'orig_fzf_default_opts', $FZF_DEFAULT_OPTS)
  let $FZF_DEFAULT_OPTS = s:orig_fzf_default_opts .
        \ empty(cols) ? '' : (' --color='.join(cols, ','))
endfunction

augroup _fzf
  autocmd!
  autocmd ColorScheme * call <sid>update_fzf_colors()
augroup END

let g:fzf_history_dir = '~/.local/share/fzf-history'
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

map <C-p> :FZF<CR>
map <C-h> :FZF ~<CR>
map <leader>fb :Buffers<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fh :History:<CR>
nnoremap <leader>f/ :History/<CR>
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore .ccls-cache -l -g ""'
" }}}

" Airline {{{
" let g:airline_symbols_ascii = 1
let g:airline#extensions#hunks#enabled=1
let g:airline#extensions#whitespace#enabled=0
let g:airline#extensions#branch#enabled=1
" }}}

" vim gitgutter {{{
highlight clear SignColumn
set updatetime=100
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CoC {{{
   inoremap <silent><expr> <TAB>
         \ coc#pum#visible() ? coc#pum#next(1) :
         \ CheckBackspace() ? "\<Tab>" :
         \ coc#refresh()
   inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
   inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

   function! CheckBackspace() abort
       let col = col('.') - 1
       return !col || getline('.')[col - 1]  =~# '\s'
   endfunction

   " Use <c-space> to trigger completion.
   if has('nvim')
       inoremap <silent><expr> <c-space> coc#refresh()
   else
       inoremap <silent><expr> <c-@> coc#refresh()
   endif

   " Use `[g` and `]g` to navigate diagnostics
   " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
   nmap <silent> [g <Plug>(coc-diagnostic-prev)
   nmap <silent> ]g <Plug>(coc-diagnostic-next)

   " GoTo code navigation.
   nmap <silent> gd <Plug>(coc-definition)
   nmap <silent> gy <Plug>(coc-type-definition)
   nmap <silent> gi <Plug>(coc-implementation)
   nmap <silent> gr <Plug>(coc-references)

   " Use K to show documentation in preview window.
   nnoremap <silent> K :call ShowDocumentation()<CR>

   function! ShowDocumentation()
     if CocAction('hasProvider', 'hover')
       call CocActionAsync('doHover')
     else
       call feedkeys('K', 'in')
     endif
   endfunction

   " Highlight the symbol and its references when holding the cursor.
   autocmd CursorHold * silent call CocActionAsync('highlight')

   " Symbol renaming.
   nmap <leader>rn <Plug>(coc-rename)

   " Formatting selected code.
   xmap <leader>f  <Plug>(coc-format-selected)
   nmap <leader>f  <Plug>(coc-format-selected)

   augroup mygroup
     autocmd!
     " Setup formatexpr specified filetype(s).
     autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
     " Update signature help on jump placeholder.
     autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
   augroup end

   " Applying codeAction to the selected region.
   " Example: `<leader>aap` for current paragraph
   xmap <leader>a  <Plug>(coc-codeaction-selected)
   nmap <leader>a  <Plug>(coc-codeaction-selected)

   " Remap keys for applying codeAction to the current buffer.
   nmap <leader>ac  <Plug>(coc-codeaction)
   " Apply AutoFix to problem on the current line.
   nmap <leader>qf  <Plug>(coc-fix-current)

   " Run the Code Lens action on the current line.
   nmap <leader>cl  <Plug>(coc-codelens-action)

   " Map function and class text objects
   " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
   xmap if <Plug>(coc-funcobj-i)
   omap if <Plug>(coc-funcobj-i)
   xmap af <Plug>(coc-funcobj-a)
   omap af <Plug>(coc-funcobj-a)
   xmap ic <Plug>(coc-classobj-i)
   omap ic <Plug>(coc-classobj-i)
   xmap ac <Plug>(coc-classobj-a)
   omap ac <Plug>(coc-classobj-a)

   " Remap <C-f> and <C-b> for scroll float windows/popups.
   if has('nvim-0.4.0') || has('patch-8.2.0750')
     nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
     nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
     inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
     inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
     vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
     vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
   endif

   " Use CTRL-S for selections ranges.
   " Requires 'textDocument/selectionRange' support of language server.
   "nmap <silent> <C-s> <Plug>(coc-range-select)
   "xmap <silent> <C-s> <Plug>(coc-range-select)

   " Add `:Format` command to format current buffer.
   command! -nargs=0 Format :call CocActionAsync('format')

   " Add `:Fold` command to fold current buffer.
   command! -nargs=? Fold :call     CocAction('fold', <f-args>)

   " Add `:OR` command for organize imports of the current buffer.
   command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

   " Add (Neo)Vim's native statusline support.
   " NOTE: Please see `:h coc-status` for integrations with external plugins that
   " provide custom statusline: lightline.vim, vim-airline.
   set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

   " Mappings for CoCList
   " Show all diagnostics.
   nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
   " Manage extensions.
   nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
   " Show commands.
   nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
   " Find symbol of current document.
   nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
   " Search workspace symbols.
   nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
   " Do default action for next item.
   nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
   " Do default action for previous item.
   nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
   " Resume latest coc list.
   nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

   hi link CocFloating Pmenu
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
