{
  sops = {
    defaultSopsFile = ../../.secrets.yaml;
    age.keyFile = "~/.config/sops/age/keys.txt";
  };
}
