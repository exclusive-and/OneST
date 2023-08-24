
{
    description = "A Monad with Read-After-Write Protection";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }:
    let
        system = "x86_64-linux";

        pkgs = import nixpkgs { inherit system; };
        ghc  = pkgs.haskell.packages.ghc96;

        onest = ghc.callCabal2nix "onest" ./. { };
    in
    {
        packages.${system}.default = onest;

        devShells.${system}.default = ghc.shellFor
        {
            packages = _: [ onest ];

            # Add Haskell Language Server and Cabal as development tools.
            nativeBuildInputs = [
                ghc.cabal-install
                ghc.haskell-language-server
            ];
        };
    };
}
