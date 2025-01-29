{
  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
    };

    jupyterhub = {
      enable = true;

      extraConfig = ''
        c.Authenticator.allowed_users = {'kubujuss'} 
        c.Authenticator.admin_users = {'kubujuss'}

        c.SystemdSpawner.environment = {
          'LD_LIBRARY_PATH': '/run/opengl-driver/lib:$LD_LIBRARY_PATH',
          'CUDA_HOME': '/run/opengl-driver',

          'SSL_CERT_FILE': '/etc/ssl/certs/ca-bundle.crt',

          'TF_CPP_MIN_LOG_LEVEL': '3',
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 
    11434 # ollama
    8000  # jupyterhub
  ];
}
