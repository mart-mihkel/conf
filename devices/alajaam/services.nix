{
  services = {
    soft-serve = {
      enable = true;

      settings = {
        ssh = {
          public_url = "ssh://git.risuhunnik.xyz";
        };

        initial_admin_keys = [ 
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9gAe8X398YBgMrHoRIPjnEiDoTRMg0VMM3Ll/MxSYh kubujuss@uss''
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 
    23231 # soft-serve ssh
  ];
}
