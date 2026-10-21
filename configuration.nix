# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).


# DO NOT UPDATE BIOS!!!!!!!!!! you need to be on the older bios to undervolt your pc properly!

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];



# [추가됨] Flake 및 차세대 Nix 명령어 영구 활성화
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  networking.hostName = "nixosBTW"; # Define your hostname.
  # networking.wireless.enable = true;  # NetworkManager와 동시 활성화 시 충돌하므로 주석 처리 유지

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  i18n.defaultLocale = "ko_KR.UTF-8";



i18n.supportedLocales = [

"C.UTF-8/UTF-8"
"en_US.UTF-8/UTF-8"
"ko_KR.UTF-8/UTF-8"


];


 # i18n.extraLocaleSettings = {
   # LC_ADDRESS = "ko_KR.UTF-8";
  #  LC_IDENTIFICATION = "ko_KR.UTF-8";
  #  LC_MEASUREMENT = "ko_KR.UTF-8";
  #  LC_MONETARY = "ko_KR.UTF-8";
  #  LC_NAME = "ko_KR.UTF-8";
 #   LC_NUMERIC = "ko_KR.UTF-8";
 #   LC_PAPER = "ko_KR.UTF-8";
 #   LC_TELEPHONE = "ko_KR.UTF-8";
#    LC_TIME = "ko_KR.UTF-8";
  #  LC_MESSAGES = "en_US.UTF-8"; # 터미널 에러 및 콘솔 메시지는 영어로 고정
  #};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."eugene" = {
    isNormalUser = true;
    description = "eugene";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    shell=pkgs.zsh;
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [

    #brave-origin

    keyd

    #xfce.xfce4-power-manager
    #xfce.xfce4-battery-plugin

    #blueman



  ];






  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "26.05"; # Did you read the comment?

  # =========================================================================
  # system core stuff
  # =========================================================================

  # zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # corecore stuff
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # Broadwell 이상(8세대 Whiskey Lake 포함) iHD 드라이버
    ];
  };

  hardware.bluetooth.enable = true;
  #services.blueman.enable = true;

  # =========================================================================
  # Flatpak & Flathub 기본 저장소 등록
  # =========================================================================
  services.flatpak.enable = true;

  systemd.services.configure-flathub = {
    description = "Configure Flathub repository";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # =========================================================================
  # power management & ThinkPad L390 tuning
  # =========================================================================

# =========================================================================
  # power management & ThinkPad L390 tuning
  # =========================================================================

  services.power-profiles-daemon.enable = false;
  services.thermald.enable = false;


  # throttled: 정확한 키 이름(CORE, CACHE 등) 및 Sysfs 경로 적용
  services.throttled = {
    enable = true;
    extraConfig = ''
      [GENERAL]
      Enabled: True
      Autoreload: True

      [BATTERY]
      Update_Rate_s: 10
      PL1_Tdp_W: 15
      PL1_Duration_s: 28
      PL2_Tdp_W: 20
      PL2_Duration_S: 0.002
      Trip_Temp_C: 75
      cTDP: 0

      [AC]
      Update_Rate_s: 5
      PL1_Tdp_W: 18
      PL1_Duration_s: 28
      PL2_Tdp_W: 22
      PL2_Duration_S: 0.002
      Trip_Temp_C: 80
      cTDP: 0

      # 주의: 키 이름은 반드시 CORE, GPU, CACHE, UNCORE, ANALOGIO 여야 합니다.
      [UNDERVOLT.BATTERY]
      CORE: -70
      GPU: -40
      CACHE: -70
      UNCORE: 0
      ANALOGIO: 0

      [UNDERVOLT.AC]
      CORE: -70
      GPU: -40
      CACHE: -70
      UNCORE: 0
      ANALOGIO: 0
    '';
  };

  # TLP: 배터리 타임 확보를 위한 터보 부스트 차단 및 오디오/PCIe 절전 활성화
 # TLP: 배터리 타임 확보를 위한 터보 부스트 차단 및 오디오/PCIe 절전 활성화
  services.tlp = {
    enable = true;
    settings = {
      # [AC 전원 연결 시]
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_BOOST_ON_AC = 1;
      CPU_MAX_PERF_ON_AC = 90;
      SOUND_POWER_SAVE_ON_AC = 0; # AC 연결 시에는 노이즈 방지를 위해 절전 해제 유지

      # [배터리 사용 시 - 순간 반응성은 AC처럼 빠릿하게, 지속 전력은 throttled가 15W로 제어]
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance"; # 웹사이트 클릭/스크롤 시 즉각 클럭 상승
      CPU_BOOST_ON_BAT = 1;
      CPU_MAX_PERF_ON_BAT = 90;   # AC와 동일한 클럭 상한 부여
      SOUND_POWER_SAVE_ON_BAT = 1; # 1로 켜야 CPU가 깊은 C-State(PC8/PC10)로 진입함
      WIFI_PWR_ON_BAT = "off";    # 와이파이 절전 해제로 웹사이트 응답 지연(버벅임) 제거
      RUNTIME_PM_ON_BAT = "auto";

      # ThinkPad 배터리 수명 보호 임계치 (75% 이하일 때 충전 시작, 80%에서 정지)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  # =========================================================================
  # audio (PipeWire 활성화)
  # =========================================================================


 security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

  };



  # =========================================================================
  # keyd (캡스락 -> 한/영 키 전환 ... 은 그냥 컨픽 따로 만들기)
  # =========================================================================
   # =========================================================================
  # keyd (캡스락 -> 한/영 키 전환 + UK 키보드 레이아웃 보정)
  # =========================================================================
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          # 1. 기존 한/영 키 매핑 (Caps Lock -> Hangul)
          capslock = "hangeul";
        };
      };
    };
  };



  # keyd 가상 장치로 인한 터치패드 팜 리젝션 오작동 방지
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

  # =========================================================================
  # 한국어 입력기 설정 (기본: ibus-hangul 활성화 / 필요 시 주석 전환)
  # =========================================================================

  # --- [선택됨: ibus-hangul (GNOME 공식 기본 호환성 추천)] ---
 # i18n.inputMethod = {
#    enable = true;
 #   type = "ibus";
#    ibus.engines = with pkgs.ibus-engines; [ hangul ];
#  };

#i18n.inputMethod = {
#    enable = true;
#    type = "kime";
#  };


  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-hangul           # 한글 입력 엔진
        fcitx5-gtk              # GTK 앱 (웹브라우저, VS Code 등) 지원
        kdePackages.fcitx5-qt   # Qt6 / KDE Plasma 6 앱 지원 (Qt5 충돌 방지)
      ];
    };
  };

  # Wayland 환경 변수 보정
    environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "iHD"; # 하드웨어 비디오 가속 강제 (유튜브 배터리 소모 감소)
  };



  # --- [옵션 2: fcitx5 (필요 시 교체 사용)] ---
  # i18n.inputMethod = {
  #   enable = true;
  #   type = "fcitx5";
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-hangul
  #     fcitx5-gtk
  #   ];
  # };

  # 한글 깨짐 방지 폰트 및 코딩용 너드 폰트
  fonts.packages = with pkgs; [
    pretendard
    noto-fonts-cjk-sans
    d2coding

    # 최신 규격 너드 폰트
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  # =========================================================================
  # gnome
  # =========================================================================
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;

 # environment.gnome.excludePackages = with pkgs; [
#  gnome-software
#  atomix # puzzle game
 # cheese # webcam tool
 # epiphany # web browser
 # evince # document viewer
 # geary # email reader
 # hitori # sudoku game
 # iagno # go game
#  tali # poker game
 # totem # video player
#  gnome-terminal
 # gnome-console
#  ];
 #  environment.variables.TERMINAL = "ptyxis";


  # =========================================================================
  # X11 & XFCE 데스크톱 환경
  # =========================================================================
#  services.xserver = {
#	enable = true;
#	desktopManager.xfce.enable = true;
#};




  # Enable Plasma
  services = {
    desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
    # displayManager.plasma-login-manager.enable = true;

    # Optionally enable xserver
    # xserver.enable = true;
  };

environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akonadi
    kmail
    kontact
    akregator
    korganizer
    kaddressbook
    merkuro
    kdepim-addons
    kdepim-runtime



    discover
  ];

  programs.kde-pim.enable = false;


  # =========================================================================
  # Ly 디스플레이 매니저 (Zig 기반 TUI 그리터)
  # =========================================================================
#  services.displayManager.ly = {
#    enable = true;
#    # (선택 사항) Ly 특유의 터미널 애니메이션 설정
#     settings = {
#       animation = "matrix"; # "doom" (유명한 불꽃 애니메이션), "matrix", "colormix"
#       bigclock = true;      # 대형 ASCII 시계 표시
#     };
#  };

services.displayManager.plasma-login-manager.enable = true;







  #for fstrim
  services.fstrim.enable = true;


  # systemd
  systemd.services.NetworkManager-wait-online.enable = false;



  #zsh and starship

programs.zsh = {
    enable = true;

  };

#polkit stuff - sudo pevilage
#  services.gvfs.enable = true;
#  security.polkit.enable = true;
}
