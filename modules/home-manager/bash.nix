{ lib, ... }:

{
  programs.bash = {
    enable = lib.mkForce true;

    shellAliases = {
      bshm = "home-manager switch --flake ~/.dotfiles";
      bsnix = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      bbnix = "sudo nixos-rebuild boot --flake ~/.dotfiles";
      btnix = "sudo nixos-rebuild test --flake ~/.dotfiles";
    };

    initExtra = ''
      if command -v pokeget &> /dev/null; then
              rand=$((RANDOM % 100))              
              case $rand in
                0)
                  pokeget pikachu --hide-name -g -s
                ;;
                [1-4])
                  pokeget pikachu --hide-name -g
                ;;
                [5-9])
                  pokeget random --hide-name --shiny
                ;;
                *)
                  pokeget random --hide-name
                  ;;
                esac
      else
        echo "You hadn't set up pokeget."
      fi
    '';
  };
}
