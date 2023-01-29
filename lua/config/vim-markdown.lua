-------------------------------------------------------------------------------
------------------------ { markdown } -----------------------------------------
-------------------------------------------------------------------------------

-- Disable header folding
vim.g.vim_markdown_folding_disabled = 1

-- Whether to use conceal feature in markdown
vim.g.vim_markdown_conceal = 1

-- Disable math tex conceal and syntax highlight
vim.g.tex_conceal = ''
vim.g.vim_markdown_math = 0

-- Support front matter of various format
vim.g.vim_markdown_frontmatter = 1  -- for YAML format
vim.g.vim_markdown_toml_frontmatter = 1  -- for TOML format
vim.g.vim_markdown_json_frontmatter = 1  -- for JSON format

-- Let the TOC window autofit so that it doesn't take too much space
vim.g.vim_markdown_toc_autofit = 1
