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

      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      
      color0 = "#45475A";
      color8 = "#585B70";
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
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
    };
  };
  
  # Force overwrite existing config
  xdg.configFile."kitty/kitty.conf".force = true;
}
