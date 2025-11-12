{ config, pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    
    # Theme - Catppuccin Mocha
    theme = "Catppuccin-Mocha";
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    
    settings = {
      # Window
      window_padding_width = 10;
      window_margin_width = 0;
      background_opacity = "0.95";
      
      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
      
      # Scrollback
      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
      
      # URLs
      url_style = "curly";
      open_url_with = "default";
      detect_urls = "yes";
      
      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      
      # Tabs
      tab_bar_style = "powerline";
      tab_bar_edge = "top";
      tab_powerline_style = "slanted";
      
      # Colors (Catppuccin Mocha)
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      # Cursor colors
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      
      # Black
      color0 = "#45475A";
      color8 = "#585B70";
      
      # Red
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      
      # Green
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      
      # Yellow
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      
      # Blue
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      
      # Magenta
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      
      # Cyan
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      
      # White
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };
    
    keybindings = {
      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      
      # Windows
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
      
      # Zoom
      "ctrl+shift+equal" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
    };
  };
}
