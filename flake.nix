{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      config = ./config;
      neovim = pkgs.writeShellScriptBin "nvim" ''
        export XDG_DATA_HOME="/temp/pyvim"

        ${pkgs.neovim}/bin/nvim -u ${config}/init.lua $@ 
      '';
    in
    {

      packages.x86_64-linux.nvim = neovim;
      packages.x86_64-linux.default = neovim;
    };
}
