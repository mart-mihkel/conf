{
  users.users = {
    kubujuss = {
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
    };
  };
}
