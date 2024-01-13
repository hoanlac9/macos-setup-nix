{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    # more stuff
  };
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl
  environment.systemPackages = with pkgs; [
    argocd
    awscli2
    bat
    docker
    eksctl
    go
    inetutils
    jq
    k9s
    kubectl
    kubectl
    kubectx
    kubelogin
    kubent
    kustomize
    neovim
    packer
    pkgs.aws-iam-authenticator
    pkgs.docker-buildx
    pkgs.docker-credential-helpers
    pkgs.fzf-zsh
    pkgs.kubernetes-helm
    pkgs.ssm-session-manager-plugin
    pyenv
    python313
    ripgrep
    terraform
    terragrunt
    tree
    virtualenv
    vscode
    zoxide
    # (pass.withExtensions (ext: with ext; [
    #   pass-otp
    # ]))
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
    # taps = [
    #   { name = "homebrew/cask"; }
    # ];
    brews = [
      "azure-cli"
      # m1-terraform-provider-helper
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

  services = {
    karabiner-elements.enable = true;
    tailscale.enable = true;
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
}
