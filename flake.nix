{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }: 
  flake-utils.lib.eachDefaultSystem(system: 
  let 
    overlays = [ (import rust-overlay) (final: prev: {
      gleam = prev.gleam.overrideAttrs(oldAttrs: rec {
        src = prev.fetchFromGitHub {
          owner = "gleam-lang";
          repo = "gleam";
          rev = "refs/tags/v1.7.0";
          hash = "sha256-Nr8OpinQ1Dmo6e8XpBYrtaRRhcX2s1TW/5nM1LxApGg=";
        };
        cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
          name = "gleam-lang-vendor.tar.gz";
          inherit src;
          outputHash = "sha256-+TjzRb72EXgo2Fs7QdLYfK2JYyv4Xs7c/sZOTO4pLl8=";
        });
      });
    }) ];

    rust = pkgs.rust-bin.beta.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
    };
    pkgs = import nixpkgs {
      inherit system overlays;
    };
  in
  {
    devShells.default = with pkgs; mkShell {
      buildInputs = [
        rust
        gleam
        inotify-tools
        erlang_27
        mermaid-cli
      ];
    };
  });
}
