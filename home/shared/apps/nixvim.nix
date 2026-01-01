{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    # Keep runtime simple; avoid theme/icon plugins for now.
    # Use a built-in colorscheme so startup can't fail due to missing plugins.
    colorscheme = "habamax";

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

      termguicolors = true;
      signcolumn = "yes";
      updatetime = 300;
    };

    # External tools
    extraPackages = with pkgs; [
      # Telescope helpers (even if telescope is off, these are useful)
      ripgrep
      fd

      # LSP servers
      lua-language-server
      nil # Nix LSP (you can switch to nixd later if you prefer)
      nodePackages.typescript-language-server
      nodePackages.eslint
      rust-analyzer

      # Formatters
      alejandra
      prettier
      rustfmt
    ];

    # IMPORTANT: explicitly disable devicons so it doesn't get auto-enabled.
    plugins.web-devicons.enable = false;

    plugins = {
      # Keep which-key because it's pure Lua and usually robust,
      # but if you still see "module not found", disable it too.
      which-key.enable = true;

      # LSP (core)
      lsp = {
        enable = true;
        servers = {
          lua_ls.enable = true;
          nil_ls.enable = true; # If your nixvim uses `nil` server name instead, tell me.
          ts_ls.enable = true;
          eslint.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      # Treesitter (core)
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # Completion (core)
      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      # Git signs (optional but usually safe). If it errors, disable it.
      gitsigns.enable = true;

      # Commenting (optional). If it errors, disable it.
      comment.enable = true;

      # Copilot (keep if it works for you; if it errors, we can gate it with pcall in Lua)
      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = false;
            debounce = 75;
            keymap = {
              accept = "<C-y>";
              next = "<M-]>";
              prev = "<M-[>";
              dismiss = "<C-e>";
            };
          };
          panel = { enabled = false; };
          filetypes = {
            markdown = false;
            text = false;
            gitcommit = false;
            gitrebase = false;
            yaml = false;
          };
        };
      };

      # You can add copilot-chat back later; leave it off while stabilizing.
      # copilot-chat.enable = true;
    };

    keymaps = [
      # Basic
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options.desc = "Save"; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; options.desc = "Quit"; }

      # Diagnostics
      { mode = "n"; key = "<leader>do"; action = "vim.diagnostic.open_float"; options.desc = "Show diagnostic"; }
      { mode = "n"; key = "[d"; action = "vim.diagnostic.goto_prev"; options.desc = "Prev diagnostic"; }
      { mode = "n"; key = "]d"; action = "vim.diagnostic.goto_next"; options.desc = "Next diagnostic"; }
    ];

    extraConfigLua = ''
      -- Keep extra Lua minimal; avoid requiring plugins here.
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
        float = { source = "always", border = "rounded" },
      })
    '';
  };
}
