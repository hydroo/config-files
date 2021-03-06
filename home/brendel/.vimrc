scriptencoding utf-8
set encoding=utf-8

set nocompatible

if has("win64") || has("win32")
	let g:os = "Windows"
else
	let g:os = substitute(system('uname'), '\n', '', '')
endif

let mapleader=","

" be able to move up/down inside wrapped lines
map <up> g<up>
map <down> g<down>

map <C-K> :py3f ~/.vim/addons/syntax/clang-format.py<cr>
imap <C-K> <c-o>:py3f ~/.vim/addons/syntax/clang-format.py<cr>

if g:os == "Windows"
	noremap <C-΄>  :tabprevious<cr>
	" noremap <C-Îv> :tabnext<cr> " doesn't work
	nnoremap tp    :tabprevious<CR>
	nnoremap tn    :tabnext<CR>
endif

" do not use vim's own regex magic value scheme when searching
nnoremap / /\v
vnoremap / /\v

" use more colors than just 16
if g:os == "Linux"
	set t_Co=256
endif

" vim and tmux need to be on the same page about terminal symbols
if g:os == "Linux"
	set term=xterm-256color
endif

" disable modelines for security reasons
set modelines=0

" when scrolling keep scroll as soon as you are in the fifth line
" from the bottom or the top
set scrolloff=5

" tab completion bash style (not the weird vim style)
set wildmenu
set wildmode=list:longest

set novisualbell " i used to enable this, but it seems to cause a performance problem, and i probably don't want or need it

set ttyfast

" search case-insensitive when typing only lowercase
" search case-sensitive as soon as one upper case letter is present
set ignorecase
set smartcase

set number

" no one needs F1, and chances are you press it by accident
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>


colorscheme default

set backspace=indent,eol,start
set nobackup "do not keep a backup file, use versions instead
set history=10000 "keep 10000 lines of command line history
set ruler "show the cursor position all the time
set showcmd "display incomplete commands
set showmode
set showmatch
set nojoinspaces "do not insert a space, when joining lines
set whichwrap="" "do not jump to the next line when deleting
"set nowrap
filetype plugin indent on
syntax enable
set hlsearch
set incsearch "do incremental searching
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set laststatus=2
set tabpagemax=100
set statusline=%F\ %h%m%r%=%l/%L\ \(%-03p%%\)\ %-03c\ 
set clipboard^=unnamedplus,unnamed "^= prepend string, yank to both clipboards (and to the previously set one), yank from the ctrl+c clipboard

" make gvim similar to the console vim, plus some more settings like lines and columns
set guicursor+=a:blinkon0 " no blinking
highlight Cursor guibg=#00c0c1
highlight iCursor guibg=#00c0c1
set guifont=FreeMono\ 14
if has("gui_running")
	set lines=40 columns=120
endif

"use listmode to make tabs visible and make them gray so they are not
"disctrating too much
set listchars=tab:»\ ,eol:¬,trail:.
if g:os == "Windows" " cmder's theme is dark, so lightgray is bad
	highlight NonText ctermfg=darkgray guifg=darkgray
	highlight SpecialKey ctermfg=darkgray guifg=darkgray
elseif g:os == "Linux"
	highlight NonText ctermfg=gray guifg=lightgray
	highlight SpecialKey ctermfg=gray guifg=lightgray
endif
highlight clear MatchParen
highlight MatchParen cterm=bold
set list

2match Todo /\(TODO\|\ctodo\|@todo\|\ccitation\( \|\)needed\)/

set exrc
set secure

" --- folding ---
set foldmethod=syntax

nnoremap <Space> za
vnoremap <Space> za

function! MyFoldText()
    return getline(v:foldstart) . ' '
endfunction
set foldtext=MyFoldText()

highlight Folded ctermfg=gray ctermbg=none

" zi toggle folding support
" zj move to the top of the next fold (even when everything is unfolded)
" zk move to the bottom of the previous fold
" za toggle the current fold
" zA toggle all folds recursively
" zoO for open, zcC for close
" zr open one more fold leve
" zR open all folds
" zm close one fold level
" zM close all folds in the document
" zv expand folds to reveal cursor (zMzv is useful)

"different tabbing settings for different file types
if has("autocmd")

	autocmd BufRead,BufNewFile *.[pns]m set filetype=prismmodel
	autocmd BufRead,BufNewFile *.prism set filetype=prismmodel
	autocmd BufRead,BufNewFile *.smg set filetype=prismmodel
	autocmd BufRead,BufNewFile *.pctl set filetype=prismproperty
	autocmd BufRead,BufNewFile *.frag,*.vert,*.fp,*.vp,*.glsl set filetype=glsl

	autocmd FileType prismmodel setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd FileType prismproperty setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

	autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType scheme setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType cuda setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd FileType make setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd FileType markdown setlocal expandtab
	autocmd FileType promela setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd FileType tex set spell

	" doesnt work properly -- revise me
	autocmd CursorMoved * call RonnyHighlightWordUnderCursor()
	autocmd CursorMovedI * call RonnyHighlightWordUnderCursor()

	"jump to the end of the file if it is a logfile
	autocmd BufReadPost *.log normal G
	autocmd BufRead,BufNewFile *.go set filetype=go
endif

highlight Search ctermfg=white ctermbg=gray
highlight IncSearch ctermfg=white ctermbg=gray
if g:os == "Windows"
	highlight RonnyWordUnderCursorHighlight ctermbg=darkgray
else
	highlight RonnyWordUnderCursorHighlight cterm=bold
endif

" --- highlight the word under the cursor ---

function! RonnyHighlightWordUnderCursor()
if has('python3')
python3 << endpython
import vim

# get the character under the cursor
row, col = vim.current.window.cursor
characterUnderCursor = ''
try:
	characterUnderCursor = vim.current.buffer[row-1][col]
except:
	pass

# remove last search
vim.command("match RonnyWordUnderCursorHighlight //")

# if the cursor is currently located on a real word, move on and highlight it
if characterUnderCursor.isalpha() or characterUnderCursor.isdigit() or characterUnderCursor == '_':

	# expand cword to get the word under the cursor
	wordUnderCursor = vim.eval("expand(\'<cword>\')")
	if wordUnderCursor is None :
		wordUnderCursor = ""

	# escape the word
	wordUnderCursor = vim.eval("RonnyEscapeString(\"" + wordUnderCursor + "\")")
	wordUnderCursor = "\<" + wordUnderCursor + "\>"

	currentSearch = vim.eval("@/")

	# highlight it, if it is not the currently searched term
	if currentSearch != wordUnderCursor :
		vim.command("match RonnyWordUnderCursorHighlight /" + wordUnderCursor + "/")

endpython
endif
endfunction


function! RonnyEscapeString(s)
if has('python3')
python3 << endpython
import vim

s = vim.eval("a:s")

escapeMap = {
	'"'     : '\\"',
	"'"     : '\\''',
	"*"     : '\\*',
	"/"     : '\\/',
	"["     : '\\[',
	#'' : ''
}
 
s = s.replace('\\', '\\\\')

for before, after in escapeMap.items() :
	s = s.replace(before, after)

vim.command("return \'" + s + "\'")
endpython
endif
endfunction

" search online
nmap <leader>s :call Duck('')<CR>
" instantly browse to first search result
nmap <leader>l :call Duck('\')<CR>
function! Duck(prefix)
	let keyword = expand("<cword>")
	let url = "https://duckduckgo.com/?q=" . a:prefix . keyword
	if g:os == "Windows"
		let browser = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
	elseif g:os == "Linux"
		let browser = 'firefox'
	endif
	silent exec '!"' . browser . '" "' . url . '"'
	redraw! " silent exec requires redrawing vim
endfunction

" --- local vimrc ---
let b:dir=resolve(expand('%:p:h'))
let b:dirprev=b:dir
let b:home=resolve($HOME)

while b:dir != $HOME && b:dir != '/' && b:dir != b:dirprev
	echo b:dir
	if (filereadable(b:dir.'/.vimrc'))
		" echo '  loaded'
		execute 'source '.b:dir.'/.vimrc'
	endif
	let b:dirprev=b:dir
	let b:dir=fnamemodify(b:dir, ':h')
endwhile

" --- digraphs ---
"
" insert mode + ctrl+k + key 1 + key 2
" 
" -- formula symbols --
" ∀ FA
" ∃ TE
" ◇ Dw
" ○ 0m
" ␣ Vs
" □ OS
" ■ fS
" ¬ NO
" Ø O/
" ø o/
dig -T 8868 " ⊤ new
dig _T 8869 " ⊥ new remapped from -T
" ⊥ -T
" ∈ (-
" ∋ -)
" ∞ 00
" ∧ AN
" ∨ OR
" ∩ (U
" ∪ )U
" ⊂ (C
" ⊃ )C
" ⊆ (_
" ⊇ )_
" ÷ -:
" ∓ -+
" √ RT
" ∘ Ob
" ∙ Sb
dig o+ 8853 " ⊕ new
dig o- 8854 " ⊖ new
dig ox 8855 " ⊗ new
" ⊙ 0.
" ⊚ 02
" ≃ ?- asymptotically equal to
" ≅ ?= approximately equal to
" ≈ ?2 almost equal to
" ≠ != not equal to
" ≡ =3 identical to
" ≤ =< less-than or equal to
" ≥ >= greater-than or equal to
" ≪ <* much less-than
" ≫ *> much greater-than
"
" ⌈ <7 LEFT CEILING
" ⌉ >7 RIGHT CEILING
" ⌊ 7< LEFT FLOOR
" ⌋ 7> RIGHT FLOOR
" 《<+ LEFT DOUBLE ANGLE BRACKET
" 》>+ RIGHT DOUBLE ANGLE BRACKET
" 〔(' LEFT TORTOISE SHELL BRACKET
" 〕)' RIGHT TORTOISE SHELL BRACKET
" 〉</ left-pointing angle bracket " buggy brackets!
" 〈 >/ right-pointing angle bracket " buggy brackets!
" 
" -- other symbols --
" ✓ OK
" ✗ XX
"
dig NN 8469 " ℕ new
dig QQ 8474 " ℚ new
dig ZZ 8484 " ℤ new
dig RR 8477 " ℝ new
dig CC 8450 " ℂ new
" 
" -- superscript --
" ⁰ 0S superscript 0-9
" ⁺ +S superscript plus sign
" ⁻ -S superscript minus
" ⁼ =S superscript equals sign
" ⁽ (S superscript left parenthesis
" ⁾ )S superscript right parenthesis
" ⁿ nS superscript small n
" 
" -- superscript --
" ₀ 0s subscript 0-9
" ₊ +s subscript plus sign
" ₋ -s subscript minus
" ₌ =s subscript equals sign
" ₍ (s subscript left parenthesis
" ₎ )s subscript right parenthesis
" 
" -- arrows --
" ← <-
" ↑ -!
" → ->
" ↓ -v
" ↔ <>
" ↕ UD
" ⇐ <=
" ⇒ =>
" ⇔ ==
"
" -- calligraphic letters
"
" 𝓐-𝓩 MA - MZ new (unicode 1D4D0 ff)
dig MA 120016
dig MB 120017
dig MC 120018
dig MD 120019
dig ME 120020
dig MF 120021
dig MG 120022
dig MH 120023
dig MI 120024
dig MJ 120025
dig MK 120026
dig ML 120027
dig MM 120028
dig MN 120029
dig MO 120030
dig MP 120031
dig MQ 120032
dig MR 120033
dig MS 120034
dig MT 120035
dig MU 120036
dig MV 120037
dig MW 120038
dig MX 120039
dig MY 120040
dig MZ 120041
"
" -- greek letters --
" Γ G* capital gamma
" Δ D* capital delta
" Θ H* capital theta
" Λ L* capital lamda
" Ξ C* capital xi
" Π P* capital pi
" Σ S* capital sigma
" Φ F* capital phi
" Ψ Q* capital psi
" Ω W* capital omega
" 
" α a* small alpha
" β b* small beta
" γ g* small gamma
" δ d* small delta
" ε e* small epsilon
" ζ z* small zeta
" η y* small eta
" θ h* small theta
" ι i* small iota
" κ k* small kappa
" λ l* small lamda
" μ m* small mu
" ν n* small nu
" ξ c* small xi
" π p* small pi
" ρ r* small rho
" σ s* small sigma
" τ t* small tau
" φ f* small phi
" χ x* small chi
" ψ q* small psi
" ω w* small omega
"
" -- hebrew --
" א A+ alef
"
" -- roman numerals --
" Ⅰ 1R one
" Ⅱ 2R two
" Ⅲ 3R three
" Ⅳ 4R four
" Ⅴ 5R five
" Ⅵ 6R six
" Ⅶ 7R seven
" Ⅷ 8R eight
" Ⅸ 9R nine
" Ⅹ aR ten
" Ⅺ bR eleven
" Ⅻ cR twelve
" ⅰ 1r small one
" ⅱ 2r small two
" ⅲ 3r small three
" ⅳ 4r small four
" ⅴ 5r small five
" ⅵ 6r small six
" ⅶ 7r small seven
" ⅷ 8r small eight
" ⅸ 9r small nine
" ⅹ ar small ten
" ⅺ br small eleven
" ⅻ cr small twelve
