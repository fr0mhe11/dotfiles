{
  description = "eugene's ThinkPad L390 NixOS Flake";

  inputs = {
    # 26.05 버전에 맞춘 최신 공식 리포
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 홈 매니저 연결 (시스템 nixpkgs와 버전 강제 통일)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # 호스트네임 'nixosBTW'와 이름을 맞춰두어 명령어 입력을 간소화함
    nixosConfigurations.nixosBTW = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        # 홈 매니저 모듈 합체
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.eugene = import ./home.nix;
        }
      ];
    };
  };
}
