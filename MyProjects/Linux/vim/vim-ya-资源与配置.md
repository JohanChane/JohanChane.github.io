# vim 配置

## vim 资源

### Refers

- <https://vimawesome.com/>

    插件查询

- <https://github.com/vim/vim>

    github 的 vim

- <ftp://ftp.vim.org/pub/vim/unix>

    各版本 vim 的源码

- <https://tuxproject.de/projects/vim/>

    别人编译好的 vim

- vimrc 参考

    - <https://www.shortcutfoo.com/blog/top-50-vim-configuration-options/>
    - <https://github.com/amix/vimrc>

- vim cheet sheet

    - <https://vim.rtorr.com/>

- 编译 vim 参考

    - <http://www.pingwu.me/2013/12/gvim-74-x64-for-windows-with-gdi-and-gfw.html>
    - <https://www.cnblogs.com/memset/archive/2013/06/14/3134910.html>
    - <https://www.cnblogs.com/abcat/p/3392727.html>

- markdown

    谷歌插件 Markdown Viewer


## 个人 vimrc

***个人当前 vimrc 配置，仅供参考，不作维护***

```vim
" # neovim user config

" ## References

" https://www.bilibili.com/video/BV1Ka4y1E7AM?from=search&seid=1671103811298760098

" ## 准备工作

" provider-ruby (optional)
" let g:ruby_host_prog = 'rvm system do neovim-ruby-host'

" ### Auto load for first time uses
if empty(glob(stdpath('data') .. '/site/autoload/plug.vim'))
    silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ## basic

" ### basic settings
" ref: <https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file>
set autochdir
" tmp 目录不会 autochdir
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

" 切换 buffer 时不用保存
set hidden

" #### 当文件改变时自动读取
set autoread
autocmd FocusGained,BufEnter * checktime

" #### wildmenu
" set wildmenu
" set wildmode=longest:full

" ### 设置文件编码与格式
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformats=unix,dos

" ### 设置 table 键
filetype plugin indent on
" In Insert mode: Use the appropriate number of spaces to insert a <Tab>. Spaces are used in indents with the '>' and '<' commands and
set expandtab
"set noexpandtab
" Number of spaces that a <Tab> in the file counts for.
set tabstop=4
" 当 noexpandtab 时，空格与 tab 混合使用时，插入 <tab>，会将空格转为 <tab>。
" 当 expandtab 时，有 softtabstop 个空格时，<BS> 会删除 softtabstop 个空格。
set softtabstop=4
" Number of spaces to use for each step of (auto)indent.  Used for 'cindent', '>>', '<<', etc.
set shiftwidth=4

" ### 设置 indent
" 有点像 C 语言的缩进。比如遇到 `{}` 时。
set autoindent
set smartindent

" ### 文本显示效果
set wrap            " 文本过长可折行显示，并没有添加换行符只是换行显示。
set nolinebreak     " linebreak 是防止一个词被折行显示。对于英文来说是好的，但是对于中文，vim 会将一行没有空白符的文字当成一个词。
set textwidth=0     " 如果不为 0，插入模式下，一行如果超过 textwidth 且有空白符时，会在空白符插入一个换行符。如果是中文的话不建议使用，理由与 nolinebreak 一样。

" #### 显示特殊字符
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" ### 设置行号和鼠标
" 设置行号
set number
set relativenumber

" 不用 `set mouse=a`, 因为用 `S-inert` 复制光标选中的行
set mouse=

" ### 搜索
set hlsearch
set ignorecase
set smartcase       " 与 shell 的 'less -i' 相同
set incsearch       " 边搜索可以边添加搜索的字符。添加光标后的一个字符 C-l，添加一个词  `C-r,C-w`。

" ### 快捷键
" #### 选择刚粘贴的文本
nnoremap gp `[v`]

" #### 复制/粘贴（前提是快捷键能传到 vim）
vnoremap Y "+y
" vnoremap <C-Insert> "+y
" nnoremap <S-Insert> "+p
" vnoremap <S-Insert> "+p
" inoremap <S-Insert> <Esc>"+p

" " #### go to the last tab
nmap 0gt :tablast<CR>

" ## 自定义命令
" 将命令的输出结果输出到一个 new buffer
:com! -nargs=* -complete=command MyRedir :tabnew|put =execute('<args>')

" ### session
" Automatically save the session when leaving Vim
nnoremap <leader>ss :mksession! ~/.local/share/nvim/Session.vim<CR>
" Automatically load the session when entering vim
nnoremap <leader>sr :source ~/.local/share/nvim/Session.vim<CR>

" ### neovim Terminal
autocmd TermOpen term://* startinsert
" 进入 normal 模式
" tnoremap <C-N> <C-\><C-N>
" exit terminal
tnoremap <C-O> <C-\><C-N>:bd!<CR>
nmap <leader>t :-1tabnew term://bash<CR>

" ### 用浏览器打开此文件(为了 markdown 文件)
" Evoke a web browser
function OpenFileWithBrowser ()
    let thisFile = expand('%:p')
    " let webBrowser = 'firefox'
    " let webBrowser = 'microsoft-edge-beta'
    let webBrowser = 'brave'
    exec ':!' .. webBrowser .. ' --new-window ''file:///' .. thisFile .. ''' &'
endfunction

" <C-l> 是 refresh window
nnoremap <Leader>bb :call OpenFileWithBrowser ()<CR>\|<C-l>

" ### 将正则表达式的特殊字符转义
" vnoremap ge "zy:let @z=escape(@z, '^$.*\[]/')<CR>
" 用 sno
map gez :let @z=escape(@+, '/')<CR>
map gey :let @y=escape(@+, '/')<CR>

" ## Others
" ### smartindent 中，插入模式输入井号自动缩进到行首的问题。`help smartindent`
inoremap # X#

" ## 插件管理器 vim-plug
call plug#begin(stdpath('data') .. '/plugged')

" ## Basic
Plug 'mbbill/undotree'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
"Plug 'preservim/nerdtree'
Plug 'kevinhwang91/rnvimr'
Plug 'preservim/nerdcommenter'
Plug 'lambdalisue/suda.vim'
Plug 'dkarter/bullets.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

" ### tab and statusline
" tab
" Plug 'mg979/vim-xtabline'
" " Status line
" Plug 'liuchengxu/eleline.vim'

" vim-airline
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" ### tagList
Plug 'liuchengxu/vista.vim'

" ## enhance
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'mzlogin/vim-markdown-toc'
" Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown'}

" ### git
Plug 'airblade/vim-gitgutter'

" colorscheme
Plug 'ajmwagar/vim-deus'

" ### plantuml
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'

" ### thesaurus_query
Plug 'ron89/thesaurus_query.vim'

" ### gtags(global)
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'

" ### devicons
" 一般最后才加载这个插件
" 要安装 nerd font
Plug 'ryanoasis/vim-devicons'

call plug#end()

" ## 插件设置

" ### xtabline
" 依赖(archlinux)：ttf-symbola, powerline-fonts

" ### undotree
nnoremap <F5> :UndotreeToggle<CR>

" ### vim easymotion
" 与 vim 的默认操作类似。比如：`\\ w, \\ b, \\f \\F`
map <leader><leader> <Plug>(easymotion-prefix)

" Move to word
nmap <leader>mw <Plug>(easymotion-overwin-w)

" Move to line
nmap <leader>ml <Plug>(easymotion-overwin-line)

" ### vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" ### vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ### nerdtree
" " 打开/关闭 nerdtree
" nnoremap <Leader>n :NERDTreeToggle<CR>
"
" " 默认显示隐藏文件
" let NERDTreeShowHidden=1
" "默认是 `let NERDTreeIgnore = ['\~$']`
" let NERDTreeIgnore = []
" let NERDTreeQuitOnOpen=1

" ### nerdcommenter
" #### 使用
" <Leader>cc 添加注释
" <Leader>cu 删除注释
" <Leader>c<space> Toggle 注释
" <Leader>ca Toggle 注释风格
" c 语言的另外一种注释风格

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1
let g:NERDAltDelims_c = 1

" Add your own custom formats or override the defaults
" \ 'c': { 'left': '/**', 'right': '*/', 'leftAlt': '////', 'rightAlt': '' },
 let g:NERDCustomDelimiters = {
         \ 'json': { 'left': '//' }
         \ }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" ### suda.vim
" SudaRead <file>
" `w` OR `SudaWrite`

" ### bullets.vim
" cmd: RenamberSelection, RenamberList
let g:bullets_enabled_file_types = [
    \ 'markdown'
    \]

let g:bullets_enable_in_empty_buffers = 0 " default = 1
" 会自动添加序号
" let g:bullets_set_mappings = 0 " default = 1
" let g:bullets_mapping_leader = '<M-b>' " default = ''

" ### fzf.vim
" Preview window on the right with 50% width
" CTRL-/ will toggle preview window.
" 依赖：ctags
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

" #### 默认设置
" " [Buffers] Jump to the existing window if possible
" let g:fzf_buffers_jump = 1
"
" " [[B]Commits] Customize the options used by 'git log':
" let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
"
" " [Tags] Command to generate tags file
" let g:fzf_tags_command = 'ctags -R'
"
" " [Commands] --expect expression for directly executing the command
" let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" #### commands and key bindings
nnoremap <leader>zf :Files 
nnoremap <leader>zh :History<CR>
nnoremap <leader>zb :Buffers<CR>
nnoremap <leader>zt :BTags<CR>
nnoremap <leader>zl :BLines<CR>
nnoremap <leader>zg :Rg<CR>
" nnoremap <leader>zc :Commits<CR>

nnoremap <leader>ztt :Tags<CR>
nnoremap <leader>zw :Windows<CR>
nnoremap <leader>zj :Helptags<CR>
nnoremap <leader>zm :Maps<CR>

" ##### RgP
" 搜索整个项目的内容（如果项目的根目录没有 `.git` 则使用 `git init`）
command! -bang -nargs=* RgP
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': system('git -C '.expand('%:p:h').' rev-parse --show-toplevel 2> /dev/null')[:-2]}, <bang>0)

nnoremap <leader>zgg :RgP<CR>

" " ##### Rg 可指定 path
" function! RgDir(isFullScreen, args)
"     let l:restArgs = [a:args]
"
"     let l:restArgs = split(l:restArgs[0], '-pattern=', 1)
"     let l:pattern = join(l:restArgs[1:], '')
"
"     let l:restArgs = split(l:restArgs[0], '-path=', 1)
"     " Since 8.0.1630 vim has a built-in trim() function
"     let l:path = trim(l:restArgs[1])
"
"     call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " .. shellescape(l:pattern), 1, {'dir': l:path}, a:isFullScreen)
" endfunction
"
" " the path param should not have `-pattern=`
" command! -bang -nargs=+ -complete=dir RgD call RgDir(<bang>0, <q-args>)
" nnoremap <leader>zd :RgD -path= . -pattern=

" ### rnvimr
nnoremap <silent> <M-t> :RnvimrToggle<CR>

" Make Ranger replace Netrw and be the file explorer
let g:rnvimr_enable_ex = 1

" Make Ranger to be hidden after picking a file
let g:rnvimr_enable_picker = 1

" Disable a border for floating window
let g:rnvimr_draw_border = 0

" Hide the files included in gitignore
let g:rnvimr_hide_gitignore = 1

" Change the border's color
let g:rnvimr_border_attr = {'fg': 14, 'bg': -1}

" Make Neovim wipe the buffers corresponding to the files deleted by Ranger
let g:rnvimr_enable_bw = 1

" Add a shadow window, value is equal to 100 will disable shadow
let g:rnvimr_shadow_winblend = 70

" Draw border with both
let g:rnvimr_ranger_cmd = 'ranger --cmd="set draw_borders both"'

" Link CursorLine into RnvimrNormal highlight in the Floating window
highlight link RnvimrNormal CursorLine

" Map Rnvimr action
let g:rnvimr_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ }

" Add views for Ranger to adapt the size of floating window
let g:rnvimr_ranger_views = [
            \ {'minwidth': 90, 'ratio': []},
            \ {'minwidth': 50, 'maxwidth': 89, 'ratio': [1,1]},
            \ {'maxwidth': 49, 'ratio': [1]}
            \ ]

" Customize the initial layout
let g:rnvimr_layout = {
            \ 'relative': 'editor',
            \ 'width': float2nr(round(0.7 * &columns)),
            \ 'height': float2nr(round(0.7 * &lines)),
            \ 'col': float2nr(round(0.15 * &columns)),
            \ 'row': float2nr(round(0.15 * &lines)),
            \ 'style': 'minimal'
            \ }

" Customize multiple preset layouts
" '{}' represents the initial layout
let g:rnvimr_presets = [
            \ {'width': 0.600, 'height': 0.600},
            \ {},
            \ {'width': 0.800, 'height': 0.800},
            \ {'width': 0.950, 'height': 0.950},
            \ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0},
            \ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0.5},
            \ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0},
            \ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0.5},
            \ {'width': 0.500, 'height': 1.000, 'col': 0, 'row': 0},
            \ {'width': 0.500, 'height': 1.000, 'col': 0.5, 'row': 0},
            \ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0},
            \ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0.5}
            \ ]

" ### LeaderF
" " Show icons, icons are shown by default
" let g:Lf_ShowDevIcons = 1
" " For GUI vim, the icon font can be specify like this, for example
" let g:Lf_DevIconsFont = "DroidSansMono Nerd Font Mono"
" " If needs
" set ambiwidth=double
"
" " don't show the help in normal mode
" let g:Lf_HideHelp = 1
" let g:Lf_UseCache = 0
" let g:Lf_UseVersionControlTool = 0
" let g:Lf_IgnoreCurrentBufferName = 1
" " popup mode
" let g:Lf_WindowPosition = 'popup'
" let g:Lf_PreviewInPopup = 1
" let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
" let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

" let g:Lf_ShortcutF = "<leader>ff"
" " 可以搜索隐藏文件
" let g:Lf_ShowHidden = 1
" noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
" noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
" noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

" cache dir 默认是 $HOME, 缓存放在 ~/.LfCache 。
" let g:Lf_CacheDirectory = '$HOME'

" ### 查看项目
" should use `Leaderf gtags --update` first
" noremap <leader>fu :Leaderf gtags --update<CR>

" 如果为 1 时，如果存在 gtags 数据库文件则自动更新。找到 root 时，如果不存在 gtags 时，不会自动更新。
" 对于 C++，leaferf 不会自动查找无后缀的头文件，所以下面的功能可用 ccls 替代。
" let g:Lf_GtagsAutoGenerate = 1
" let g:Lf_Gtagslabel = 'native-pygments'
" noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
" noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
" noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

" ### coc.nvim
" 依赖：nodejs
" CocConfig: refer: https://github.com/theniceboy/nvim/blob/master/coc-settings.json
" coc-sh: npm install -g bash-language-server
let g:coc_global_extensions = [
    \ 'coc-marketplace',
    \ 'coc-vimlsp',
    \ 'coc-diagnostic',
    \ 'coc-syntax',
    \ 'coc-xml',
    \ 'coc-json',
    \ 'coc-pyright',
    \ 'coc-python',
    \ 'coc-java',
    \ 'coc-sh',
    \ 'coc-yaml',
    \ 'coc-translator']

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
" set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" hi SignColumn ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey
" hi SignColumn ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 选中补全信息后，回车选择补全信息，而不是换行
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space> to trigger completion.
if has('nvim')
  "inoremap <silent><expr> <c-space> coc#refresh()
  inoremap <silent><expr> <c-x> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              " \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent><nowait> <LEADER>d :CocList diagnostics<cr>
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
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! Show_documentation()
	call CocActionAsync('highlight')
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)

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

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" ### coc-translator
nmap ts <Plug>(coc-translator-p)

" ### vista.vim
" 依赖：vim-devicons
noremap <leader>v :Vista!!<CR>
"noremap <c-t> :silent! Vista finder coc<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

" ### vim-gutentags
" refer: https://zhuanlan.zhihu.com/p/36279445
" 依赖：global
" 使用：
"   touch .root
"   :GutentagsUpdate!
" 对于 C++ 来说，所以插件不会查找 C++ 无后缀的头文件，但 gtags 可以，所以只能保留这个功能。

" noremap <leader>gu :GutentagsUpdate!<CR>
"
" set tags=./.tags;,.tags
"
" let $GTAGSLABEL = 'native-pygments'
" let $GTAGSCONF = '/usr/share/gtags/gtags.conf'
"
" " gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
" " 当搜索到这些文件时，会自动创建 tags 数据库文件
" let g:gutentags_project_root = ['root', '.ccls', 'compile_commands.json', '.git', '.hg', '.svn', '.project']
"
" " 所生成的数据文件的名称
" let g:gutentags_ctags_tagfile = '.tags'
"
" " 同时开启 ctags 和 gtags 支持：
" let g:gutentags_modules = []
" if executable('ctags')
"     let g:gutentags_modules += ['ctags']
" endif
" if executable('gtags-cscope') && executable('gtags')
"     let g:gutentags_modules += ['gtags_cscope']
" endif
"
" " 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
" let g:gutentags_cache_dir = expand('~/.cache/tags')
"
" " 配置 ctags 的参数，老的 Exuberant-ctags 不能有 --extra=+q，注意
" let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"
" " 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
"
" " 禁用 gutentags 自动加载 gtags 数据库的行为
" let g:gutentags_auto_add_gtags_cscope = 0
"
" " ### gutentags_plus
" " change focus to quickfix window after search (optional).
" let g:gutentags_plus_switch = 1
"
" let g:gutentags_plus_nomap = 1
"
" " 0 or s: Find this symbol
" " 1 or g: Find this definition
" " 2 or d: Find functions called by this function
" " 3 or c: Find functions calling this function
" " 4 or t: Find this text string
" " 6 or e: Find this egrep pattern
" " 7 or f: Find this file
" " 8 or i: Find files #including this file
" " 9 or a: Find places where this symbol is assigned a value
" noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
" noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
" noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
" noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
" noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
" noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
" noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
" noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
" noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>

" ### GitGutter
function AutoEnableGitGutter()
    let project_root = system('git -C ' .. expand('%:p:h') .. ' rev-parse --show-toplevel 2> /dev/null')
    if strlen(project_root) == 0
        let g:gitgutter_enabled = 0
    else
        let g:gitgutter_enabled = 1
    endif
endfunction
autocmd BufEnter * call AutoEnableGitGutter()

nmap ght :GitGutterToggle<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" ### vim-instant-markdown
" 依赖：npm install instant-markdown-d
" filetype plugin on
" "Uncomment to override defaults:
" "let g:instant_markdown_slow = 1
" let g:instant_markdown_autostart = 0
" "let g:instant_markdown_open_to_the_world = 1
" "let g:instant_markdown_allow_unsafe_content = 1
" "let g:instant_markdown_allow_external_content = 0
" let g:instant_markdown_mathjax = 1
" let g:instant_markdown_mermaid = 1
" "let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
" "let g:instant_markdown_autoscroll = 0
" "let g:instant_markdown_port = 8888
" "let g:instant_markdown_python = 1
" let g:instant_markdown_browser = "firefox --new-window"
"
" nnoremap <leader>bp :InstantMarkdownPreview<CR>
" nnoremap <leader>bs :InstantMarkdownStop<CR>

" ### vim-airline
let g:airline#extensions#tabline#enabled = 1
" #### 不显示 buffers
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_close_button = 0
" #### 设置 tabs
let g:airline#extensions#tabline#show_tabs = 1
" 显示 tab 序号
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
" 不显示开头的 `tabs` 字符
let g:airline#extensions#tabline#show_tab_type = 0
" 设置 tab 的文件路径形式
let g:airline#extensions#tabline#formatter = 'default'
" 设置 tab 的分隔符
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" #### Others
let g:airline_powerline_fonts = 1
" let g:airline_theme='simple'

" ### GitGutter

" ### plantuml
" 依赖：
"   pacman -S graphviz plantuml
"   plantuml-syntax 依赖于 graphviz

" ### thesaurus_query
let g:tq_map_keys = 0
nnoremap tc :ThesaurusQueryReplaceCurrentWord<CR>
vnoremap tc y:ThesaurusQueryReplace <C-r>"<CR>

" ## last configs（防止被插件或主题配置覆盖）

" ### dress
" #### vim-deus
set termguicolors " enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set background=dark

colorscheme deus

hi NonText ctermfg=gray guifg=grey10

" ### 设置光标行
set cursorline                      "启用光标行，这样能发现一行长的文本是否是折行显示。
" set cursorcolumn                   "启用光标列
set scrolloff=5

" #### 当前行高亮形式为下划线
" 设置当前行的高亮形式。help highlight-cterm, help highlight-gui
" hi clear CursorLine
" hi CursorLine gui=underline cterm=underline

" #### 当前行高亮形式为 bold。
" 为 blod 时，当前行可能会遮盖文字颜色，所以 color。
"hi clear CursorLine
"hi CursorLine   cterm=NONE ctermbg=234 ctermfg=NONE
"hi CursorLine   cterm=NONE ctermbg=236 ctermfg=NONE

" ### 显示行尾的空白符
" refer: https://github.com/tisyang/docs/blob/master/VIM/%E9%AB%98%E4%BA%AE%E4%B8%8D%E9%9C%80%E8%A6%81%E7%9A%84%E7%A9%BA%E7%99%BD%E5%AD%97%E7%AC%A6.markdown
" 删除未尾的空白符: `:%s/\s\+$//gc`。删除只有空白符的行 `:%s/^\s\+$//gc`
" ExtraWhitespace 为自定义的高度组
highlight ExtraWhitespace ctermbg=red guibg=red
" 第一组匹配末尾的空白符，第二组匹配 tab 前的空格，第三组匹配 tab 后的空格（二三组防止 tab 与空格混合）
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t\+\|\t\+\zs \+/
" 只匹配行未尾的空白符
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

" ## Others
```
