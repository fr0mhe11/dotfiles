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
    kdePackages.kate  # [추가] KDE 순정 에디터 (내장 Git GUI 포함)
  ];

  # [추가] Git 설치 및 내 이름표 자동 설정
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "eugene";
        email = "eugene@localhost"; # 본인 GitHub 이메일이 있다면 변경 가능
      };
      init.defaultBranch = "main";
    };
  };

  # [추가] GitHub 공식 인증 도우미 (Kate에서 버튼만 누르면 GitHub에 올라가게 해줌!)
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # [이사 2] Zsh 세부 설정, 플러그인, Powerlevel10k 테마 및 편리한 단축어
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

     # Powerlevel10k 테마 로드 + 방금 만든 내 디자인(~/.p10k.zsh) 불러오기!
    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    # 일상 관리용 단축어 (터미널에서 세 글자만 치면 작동!)
    shellAliases = {
      nixrebuild = "nixos-rebuild switch --flake ~/dotfiles --sudo"; # 설정적용
      nixupdate = "nix flake update --flake ~/dotfiles && nixos-rebuild switch --flake ~/dotfiles --sudo"; # 업대이트 엔 적용
      nixgarbage = "sudo nix-collect-garbage --delete-older-than 7d"; # 청소
      nixclean = "sudo nix-collect-garbage -d"; # 청소
    };
  };









  home.stateVersion = "26.05";
}
