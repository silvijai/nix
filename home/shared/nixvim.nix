{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      clipboard = "unnamedplus";
    };

    plugins = {
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 30;
            position = "left";
            mappings = {
              "<space>" = "none";
            };
          };
          filesystem = {
            follow_current_file.enabled = true;
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
            };
          };
        };
      };

      web-devicons.enable = true;

      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          nixd.enable = true;
        };
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      gitsigns.enable = true;
      lualine.enable = true;
      which-key.enable = true;
      indent-blankline.enable = true;
      flash.enable = true;

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = ["prettier"];
            typescript = ["prettier"];
            rust = ["rustfmt"];
            nix = ["alejandra"];
          };
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
        };
      };

      lint = {
        enable = true;
        lintersByFt = {
          javascript = ["eslint"];
          typescript = ["eslint"];
          
        };
      };

      comment.enable = true;
      vim-surround.enable = true;

      avante = {
        enable = true;
        settings = {
          provider = "ollama";
          
          # Disable auto-suggestions to save resources
          behaviour = {
            auto_suggestions = false;
            auto_set_highlight_group = true;
            auto_set_keymaps = true;
            auto_add_current_file = true;
          };

          providers = {
            ollama = {
              endpoint = "http://127.0.0.1:11434";
              model = "qwen2.5-coder:7b";
              
              # Timeout: 5 minutes (Local models can be slow)
              timeout = 300000; 

              extra_request_body = {
                # OLLAMA OPTIONS
                options = {
                  # Safety Limit: 4096 tokens (~6GB VRAM usage). 
                  # Do NOT raise this unless you close your browsers.
                  num_ctx = 4096; 
                  
                  # Robot Mode: strict adherence to instructions
                  temperature = 0.0;
                  
                  # Stop it from rambling endlessly
                  num_predict = 2048;
                };
              };
            };
          };

          # Configure file selector
          selector = {
            provider = "telescope";  # Use telescope for better file selection
          };
        };
      };
    };

    keymaps = [
      # Explorer
      { mode = "n"; key = "<C-n>"; action = ":Neotree toggle<CR>"; options.desc = "Toggle Explorer"; }
      
      # Avante chat
      { mode = "n"; key = "<leader>aa"; action = ":AvanteAsk<CR>"; options.desc = "Avante Ask"; }
      { mode = "v"; key = "<leader>aa"; action = ":AvanteAsk<CR>"; options.desc = "Avante Ask"; }
      { mode = "n"; key = "<leader>ar"; action = ":AvanteRefresh<CR>"; options.desc = "Avante Refresh"; }
      { mode = "n"; key = "<leader>at"; action = ":AvanteToggle<CR>"; options.desc = "Avante Toggle"; }
      { mode = "n"; key = "<leader>af"; action = ":AvanteFocus<CR>"; options.desc = "Avante Focus"; }
      
      # Avante file management (ADDED)
      { mode = "n"; key = "<leader>ac"; action = "<cmd>lua require('avante.api').add_current_file()<CR>"; options.desc = "Add Current File"; }
      { mode = "n"; key = "<leader>aB"; action = "<cmd>lua require('avante.api').add_all_buffers()<CR>"; options.desc = "Add All Buffers"; }
      
      # Window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }
      
      # Save/quit
      { mode = "n"; key = "<leader>w"; action = ":w<CR>"; options.desc = "Save"; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; options.desc = "Quit"; }
    ];

    colorschemes.catppuccin.enable = true;

    extraConfigLua = ''
      -- Minimalist diagnostic icons (nerd font recommended)
      local signs = { Error = "", Warn = "", Hint = "󰛩", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Diagnostic display config
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●', -- (or ▎ or ■ or x)
        },
        severity_sort = true,
        float = {
          source = "always",
          border = "rounded",
          header = "",
          prefix = "",
        },
      })

      -- Diagnostic keymaps
      vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = "Show diagnostic in float" })
      vim.keymap.set('n', '<leader>d[', vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      vim.keymap.set('n', '<leader>d]', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set('n', '<leader>dd', "<cmd>Telescope diagnostics<CR>", { desc = "Telescope diagnostics" })
      -- If you don't want Telescope, use loclist:
      -- vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, { desc = "Set loclist with diagnostics" })
  '';
  };
}
