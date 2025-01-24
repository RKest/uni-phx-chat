{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${system}";
  in {
    devShells.${system}.default = pkgs.stdenv.mkDerivation {
      name = "uni-elixir";
      nativeBuildInputs = [
        pkgs.beamPackages.elixir
        pkgs.postgresql
        pkgs.inotify-tools
      ];

      shellHook = ''
         export MIX_HOME=$(pwd)/.nix-mix
         export HEX_HOME=$(pwd)/.nix-hex
         mkdir -p $MIX_HOME
         mkdir -p $HEX_HOME
         export PATH=$MIX_HOME/bin:$PATH
         export PATH=$HEX_HOME/bin:$PATH
         export LANG=en_US.UTF-8

         export PGDIR=$(pwd)/postgres
         export PGHOST=$PGDIR
         export PGDATA=$PGDIR/data
         export PGLOG=$PGDIR/log
         export DATABASE_URL="postgresql:///postgres?host=$PGDIR"

         if test ! -d $PGDIR; then
           mkdir $PGDIR
         fi

        if [ ! -d $PGDATA ]; then
          echo 'Initializing postgresql database...'
          initdb $PGDATA --auth=trust >/dev/null
        fi
      '';
    };
  };
}
