{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.ocf.suites.auth;

  mergedMap = fn: l:
    builtins.foldl' lib.trivial.mergeAttrs {}
      (map fn l);
in
{
  options.ocf.suites.auth = {
    enable = mkEnableOption "common auth fragments";

    pamServices = mkOption {
      type = types.listOf types.string;
    };
  };

  config = mkIf cfg.enable {
    ocf.suites.auth.pamServices = [ "login" "su" "sudo" "sshd" ];

    users.ldap = {
      enable = true;
      server = "ldaps://ldap.ocf.berkeley.edu";
      base = "dc=OCF,dc=Berkeley,dc=EDU";
      daemon.enable = true;
      extraConfig = ''
        tls_reqcert hard
        tls_cacert /etc/ssl/certs/ca-certificates.crt

        nss_base_passwd ou=People,dc=OCF,dc=Berkeley,dc=EDU
        nss_base_group  ou=Group,dc=OCF,dc=Berkeley,dc=EDU
      '';
    };

    krb5 = {
      enable = true;

      kerberos = pkgs.heimdal;

      realms = {
        "OCF.BERKELEY.EDU" = {
          admin_server = "kerberos.ocf.berkeley.edu";
          kdc = [ "kerberos.ocf.berkeley.edu" ];
        };
      };
      domain_realm = {
        "ocf.berkeley.edu" = "OCF.BERKELEY.EDU";
        ".ocf.berkeley.edu" = "OCF.BERKELEY.EDU";
      };

      libdefaults = {
        default_realm = "OCF.BERKELEY.EDU";
      };
    };

    security.pam.makeHomeDir = {
      skelDirectory = "/etc/skel";
    };

    security.pam.services = mergedMap
      (f: 
        { "${f}" = {
          makeHomeDir = true;
        }; }
      )
      cfg.pamServices;

    # Login shells need to exist at /bin
    # Hack using systemd-tmpfiles to make the links
    systemd.tmpfiles.rules = map (shell:
      "L /bin/${shell} - - - - ${pkgs."${shell}"}/bin/${shell}"
    ) ["bash" "zsh" "fish" "ksh"];
  };
}
