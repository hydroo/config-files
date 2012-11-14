set nocompatible

" ### new ###

" be able to move up/down inside wrapped lines
map <up> g<up>
map <down> g<down>

" enable mouse use in all modes
set mouse=a

" do not use vim's own regex magic value scheme when searching
nnoremap / /\v
vnoremap / /\v

" use more colors than just 16
set t_Co=256

" disable modelines for security reasons
set modelines=0

" when scrolling keep scroll as soon as you are in the fifth line
" from the bottom or the top
set scrolloff=5

" tab completion bash style (not the weird vim style)
set wildmenu
set wildmode=list:longest

set visualbell

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


" ''' old stuff '''

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
set visualbell "do not beep
set tabpagemax=100
set statusline=%F\ %h%m%r%=%l/%L\ \(%-03p%%\)\ %-03c\ 

"use listmode to make tabs visible and make them gray so they are not
"disctrating too much
set listchars=tab:»\ ,eol:¬,trail:.
highlight NonText ctermfg=gray guifg=gray
highlight SpecialKey ctermfg=gray guifg=gray
highlight clear MatchParen
highlight MatchParen cterm=bold
set list


match Todo /@todo/ "highlight doxygen todos


"different tabbing settings for different file types
if has("autocmd")
	autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType scheme setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd FileType make setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

	" doesnt work properly -- revise me
	autocmd CursorMoved * call RonnyHighlightWordUnderCursor()
	autocmd CursorMovedI * call RonnyHighlightWordUnderCursor()

	"jump to the end of the file if it is a logfile
	autocmd BufReadPost *.log normal G
	autocmd BufRead,BufNewFile *.go set filetype=go
endif


highlight Search ctermfg=white ctermbg=gray
highlight IncSearch ctermfg=white ctermbg=gray
highlight RonnyWordUnderCursorHighlight cterm=bold


function! RonnyHighlightWordUnderCursor()
python << endpython
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
if characterUnderCursor.isalpha() or characterUnderCursor.isdigit() or characterUnderCursor is '_':

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
endfunction


function! RonnyEscapeString(s)
python << endpython
import vim

s = vim.eval("a:s")

escapeMap = {
	'"'     : '\\"',
	"'"     : '\\''',
	"*"     : '\\*',
	"/"     : '\\/',
	#'' : ''
}
 
s = s.replace('\\', '\\\\')

for before, after in escapeMap.items() :
	s = s.replace(before, after)

vim.command("return \'" + s + "\'")
endpython
endfunction

" ''' digraphs '''
"
" insert mode + ctrl+k + key 1 + key 2
" 
" -- formula symbols --
" ∀ FA
" ∃ TE
" ◇ Dw
" ○ 0m
" □ OS
" ■ fS
" ¬ NO
" Ø O/
" ø o/
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
" -- other symbols --
" ✓ OK
" ✗ XX
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
" 
