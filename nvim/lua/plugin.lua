-- bootstrapping
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PackerBootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use) -- `use` satisfies language server
  use 'wbthomason/packer.nvim'

  use {
    'chentau/marks.nvim',
    config = function ()
      require'marks'.setup {
        default_mappings = false,
        bookmark_0 = {
          sign = '*',
        },
        mappings = {
          set_bookmark0 = 'mm',
          delete_bookmark = 'md',
          next_bookmark0 = 'm]',
          prev_bookmark0 = 'm[',
        }
      }
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function ()
      vim.g.nvim_tree_show_icons = {
        folders = 0,
        files = 0,
        git = 0,
        folder_arrows = 0,
      }
      require'nvim-tree'.setup{}
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>')
    end
  }

  use {
    "EdenEast/nightfox.nvim",
    config = function()
      vim.cmd("colorscheme terafox")
    end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function ()
      require'lualine'.setup{options = {
        icons_enabled = false,
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''},
      }}
    end
  }

  use {
    "hrsh7th/nvim-cmp",
    after = "nvim-lspconfig",
    config = function()
      local cmp = require'cmp'
      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          {name = 'buffer'}
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<cr>'] = cmp.mapping.confirm({ select = false }),
          ['<c-space>'] = cmp.mapping.complete(),
          ['<c-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
          ['<c-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
        })
      })

      local ls = require"luasnip"
      local s = ls.snippet
      local t = ls.text_node
      local c = ls.choice_node
      ls.add_snippets("all", {
        s("today", c(1, {t(vim.fn.strftime('%Y%m%d')), t(vim.fn.strftime('%Y-%m-%d'))}))
      })

      vim.keymap.set(
        {"i", "s"},
        "<tab>",
        function() return
          ls.expand_or_jumpable()
          and "<plug>luasnip-expand-or-jump"
          or "<tab>"
        end,
        {expr = true}
      )
      vim.keymap.set({"i", "s"}, "<c-e>", "<plug>luasnip-next-choice")

      local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require'lspconfig'
      -- See :h lspconfig-adding-servers
      local configs = require'lspconfig.configs'
      if not configs.bqls then
        configs.bqls = {
          default_config = {
            cmd = {'bq-language-server', '--stdio'},
            filetypes = {'bigquery'},
            root_dir = function(fname) return
              lspconfig.util.find_git_ancestor(fname)
              or vim.fn.fnamemodify(fname, ':h')
            end,
            settings = {bqExtensionVSCode = {
              diagnostic = {forVSCode = false}
            }},
          },
        }
      end
      local servers = {
        "pyright",
        "tsserver",
        "sumneko_lua",
        "bqls",
        "rust_analyzer"
      }
      for _, server in ipairs(servers) do
        if server == "sumneko_lua" then
          lspconfig[server].setup {
            capabilities = capabilities,
            settings = {
              Lua = {diagnostics = {globals = {'vim'}}}
            }
          }
        else
          lspconfig[server].setup {capabilities = capabilities}
        end
      end
    end,
    requires = {
      {'hrsh7th/cmp-buffer'},
      {'saadparwaiz1/cmp_luasnip'},
      {"L3MON4D3/LuaSnip"},
      {"hrsh7th/cmp-nvim-lsp"},
    },
  }

  use "williamboman/nvim-lsp-installer"

  use {
    "neovim/nvim-lspconfig",
    after = "nvim-lsp-installer",
    config = function()
      require("nvim-lsp-installer").setup {}
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
      vim.keymap.set('n', '<leader>b', ':Gitsigns toggle_current_line_blame<cr>')
      vim.cmd([[highlight link GitSignsCurrentLineBlame Comment]])
    end
  }

  use 'dr666m1/vim-clipboard'

  use 'dr666m1/vim-bigquery'

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function ()
      require("indent_blankline").setup {
        show_end_of_line = true,
      }
    end
  }

  use {
    "dr666m1/toggleterm.nvim", branch = 'fix/shade_color', config = function()
      require("toggleterm").setup{
        open_mapping = [[<c-\>]],
      }
    end,
    as = 'toggleterm.fork',
    after='nightfox.nvim',
  }
  use {
    "akinsho/toggleterm.nvim", tag = 'v1.*', config = function()
      require("toggleterm").setup{
        open_mapping = [[<c-\>]],
      }
    end,
    disable = true,
    after='nightfox.nvim',
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function ()
      require"null-ls".setup({
        sources = {
          require"null-ls".builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
          }),
        },
      })
    end,
    requires = {
      {"nvim-lua/plenary.nvim"}
    }
  }

  if PackerBootstrap then
    require('packer').sync()
  end
end)
