{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [ 
      openssl
      cacert
    ];

    variables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    };
  };
}
