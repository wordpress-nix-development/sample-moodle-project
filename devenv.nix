{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.MOODLE_VERSION = "v4.5.1";
  env.MOODLE_REPO = "https://github.com/moodle/moodle";

  # https://devenv.sh/packages/
  packages = [ pkgs.git pkgs.selenium-server-standalone pkgs.chromedriver ];

  # https://devenv.sh/languages/
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_20;
    yarn = {
      enable = true;
      install = {
        enable = true;
      };
    };
  };
  languages.php.package = pkgs.php83.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      yaml
    ]));
    extraConfig = ''
      sendmail_path = ${config.services.mailpit.package}/bin/mailpit sendmail
      smtp_port = 1025
      max_input_vars = 5000
    '';
  };
  languages.php.fpm.pools.web = {
    settings = {
      "clear_env" = "no";
      "pm" = "dynamic";
      "pm.max_children" = 10;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 10;
    };
  };
  languages.php.enable = true;

  # https://devenv.sh/processes/
  processes.cron.exec = "while true; do php html/admin/cli/cron.php ; sleep 60; done";
  processes.selenium.exec = "selenium-server";

  # https://devenv.sh/services/
  services.mysql = {
    enable = true;
    initialDatabases = [
      {
        name = "moodle";
      }
    ];
    ensureUsers = [
      {
        name = "moodle";
        password = "moodle";
        ensurePermissions = {
          "moodle.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        listen 80;
        root ${config.devenv.root}/html;
        index index.php index.html;
        server_name localhost;

        location ~ [^/]\.php(/|$) {
          fastcgi_split_path_info  ^(.+\.php)(/.+)$;
          fastcgi_index            index.php;
          fastcgi_pass unix:${config.languages.php.fpm.pools.web.socket};
          include ${pkgs.nginx}/conf/fastcgi.conf;
          fastcgi_param   PATH_INFO       $fastcgi_path_info;
          fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

        proxy_send_timeout 180s;
        proxy_read_timeout 180s;
        fastcgi_send_timeout 180s;
        fastcgi_read_timeout 180s;
        client_max_body_size 50M;
      }
    '';
  };

  services.mailpit = {
    enable = true;
  };

  # https://devenv.sh/scripts/
  enterShell = ''
    test -d html || git clone --depth 1 --branch ${config.env.MOODLE_VERSION} ${config.env.MOODLE_REPO} html
    test -d moodle-browser-config || git clone https://github.com/andrewnicols/moodle-browser-config moodle-browser-config
    composer install
    php --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
