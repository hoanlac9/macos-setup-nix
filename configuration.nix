{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl
  environment.systemPackages = with pkgs; [
    aria
    cargo
    colima
    curl
    direnv
    docker
    fzf
    gh
    git
    gnupg
    go
    jq
    kubectl
    kubernetes-helm
    kustomize
    mosh
    neovim
    nnn
    nodePackages.npm
    nodePackages.yarn
    nodejs
    pinentry
    rbw
    ripgrep
    tmux
    tree
    unzip
    watch
    zoxide

    (pass.withExtensions (ext: with ext; [
      pass-otp
    ]))
  ];

  environment.systemPath = [
    config.homebrew.brewPrefix # TODO https://github.com/LnL7/nix-darwin/issues/596
  ];

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  # Homebrew packages
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      { name = "homebrew/cask"; }
    ];
    brews = [
      # "foobar"
    ];
    casks = [
      "alacritty" # TODO https://github.com/neovim/neovim/issues/3344
      "brave-browser"
      "firefox"
      "kitty"
      "utm"
      "visual-studio-code"
      "zerotier-one"
    ];
  };

  system.defaults = {
    alf = {
      globalstate = 1;
    };
    dock = {
      autohide = true;
      minimize-to-application = true;
      mru-spaces = false;
      showhidden = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    CustomUserPreferences = {
      "com.apple.Safari" = {
        AlwaysRestoreSessionAtLaunch = true;
        AutoOpenSafeDownloads = false;
        EnableNarrowTabs = false;
        IncludeDevelopMenu = true;
        NeverUseBackgroundColorInToolbar = true;
        ShowFullURLInSmartSearchField = true;
        ShowOverlayStatusBar = true;
        ShowStandaloneTabBar = false;
      };
    };
  };

  # TODO clean up
  system.activationScripts.extraUserActivation.text = ''
    sudo pmset -a lowpowermode 1
  '';

  services.karabiner-elements = {
    enable = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    # configureBuildUsers = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [
        "@admin"
      ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    enableBashCompletion = false;
    enableCompletion = false;
    promptInit = "";
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # TODO clean up
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.khuedoan = { pkgs, lib, ... }: {
      home.stateVersion = "22.11";
      programs.home-manager.enable = true;
      home.file.".config/alacritty/alacritty.yml".text = builtins.readFile ./files/alacritty.yml;
      home.file.".config/karabiner/karabiner.json".text = builtins.readFile ./files/karabiner.json;
      home.file.".config/kitty/kitty.d/macos.conf".text = builtins.readFile ./files/kitty.conf;
    };
  };
}
