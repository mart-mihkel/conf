{ pkgs, ... }:

{
  time.timeZone = "Europe/Tallinn";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;

    keyMap = "et";

    packages = with pkgs; [ terminus_font ];
    font = "ter-u12n";
  };
}
