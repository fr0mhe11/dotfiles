{ config, pkgs, inputs, ... }:

{
  home.username = "eugene";
  home.homeDirectory = "/home/eugene";

  # [이사 1] configuration.nix에 있던 개인용 프로그램들
  home.packages = with pkgs; [
    librewolf
    fastfetch
    #brave-origin
    wget
    git
  ];

  # [이사 2] Zsh 세부 설정, 플러그인, Powerlevel10k 테마 및 편리한 단축어
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Powerlevel10k 테마 로드 (최신 홈 매니저 initContent 규격)
    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';

    # 일상 관리용 단축어 (터미널에서 세 글자만 치면 작동!)
    shellAliases = {
      nrs = "nixos-rebuild switch --flake ~/dotfiles --sudo"; # 설정적용
      nru = "nix flake update --flake ~/dotfiles && nixos-rebuild switch --flake ~/dotfiles --sudo"; # 업대이트 엔 적용
      ncg = "sudo nix-collect-garbage --delete-older-than 7d"; # 청소
    };
  };

  home.stateVersion = "26.05";
}
