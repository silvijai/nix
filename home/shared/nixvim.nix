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

      # CORRECT SPELLING: avante (not avente!)
      avante = {
        enable = true;
        settings = {
          provider = "claude";
          claude = {
            endpoint = "https://api.anthropic.com";
            model = "claude-3-5-sonnet-20241022";
            temperature = 0;
            max_tokens = 4096;
          };
        };
      };
    };

    keymaps = [
      { mode = "n"; key = "<C-n>"; action = ":Neotree toggle<CR>"; options.desc = "Toggle Explorer"; }
      { mode = "n"; key = "<leader>aa"; action = ":AvanteAsk<CR>"; options.desc = "Avante Ask"; }
      { mode = "v"; key = "<leader>aa"; action = ":AvanteAsk<CR>"; options.desc = "Avante Ask"; }
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }
      { mode = "n"; key = "<leader>w"; action = ":w<CR>"; options.desc = "Save"; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; options.desc = "Quit"; }
    ];

    colorschemes.catppuccin.enable = true;
  };
}
