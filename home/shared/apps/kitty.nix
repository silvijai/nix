{ config, pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    
    themeFile = "Catppuccin-Mocha";
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    
    settings = {
      window_padding_width = 2;
      background_opacity = "0.95";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
      scrollback_lines = 10000;
      enable_audio_bell = "no";
      tab_bar_style = "powerline";
      tab_bar_edge = "top";
      
      allow_remote_control = "yes";

      # Text & background (softer, more pastel)
      foreground = "#E6E9FF";         # soft lavender-ish text
      background = "#181825";         # slightly softer, still dark
      selection_foreground = "#181825";
      selection_background = "#FCE5F0";  # pastel pink

      cursor = "#FCE5F0";             # pastel pink cursor
      cursor_text_color = "#181825";

      # Trans-inspired pastels:
      # Light blue  ≈ #5BCEFA / #55CDFC
      # Light pink  ≈ #F5A9B8
      # Soft white  ≈ #FFFFFF but dimmed a bit
      # Using them across pairs so some gradients read like the flag.
      color0  = "#3A3B58";  # dark background accent
      color8  = "#505272";  # brighter bg accent

      color1  = "#F5A9B8";  # pink (trans)
      color9  = "#F7BED0";  # lighter pink

      color2  = "#B8F3D1";  # minty green pastel
      color10 = "#CCF7DF";

      color3  = "#F9E2B8";  # warm pastel yellow
      color11 = "#FDECCB";

      color4  = "#5BCEFA";  # blue (trans)
      color12 = "#ABDFFF";  # lighter blue

      color5  = "#D9B2FF";  # lilac
      color13 = "#E8C9FF";  # lighter lilac

      color6  = "#A4E4FF";  # blue-tinted cyan
      color14 = "#C6F0FF";  # very light cyan

      color7  = "#F5F5FF";  # near-white (trans white, slightly dimmed)
      color15 = "#FFFFFF";  # pure white
    };
    
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+equal" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
      "ctrl+shift+y" = "new_tab_with_cwd";
    };
  };
  
  # Force overwrite existing config
  xdg.configFile."kitty/kitty.conf".force = true;
}
