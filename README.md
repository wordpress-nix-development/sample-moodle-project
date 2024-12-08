# Sample Moodle Project

This is a sample development repository for Moodle powered by [devenv.sh](https://devenv.sh/).

## Getting started

This project uses [devenv.sh](https://devenv.sh/), which is based on Nix. The first time you use devnev.sh follow the "[Getting started](https://devenv.sh/getting-started/)" instructions for bootstrapping your local environment.

Commands:

- `devnev shell`: launch a shell with Node, PHP, and Composer.
- `devnev up`: starts NGINX, PHP-FPM, MySQL, and Mailpit.

URLs:

- [http://localhost](http://localhost): public website
- [http://localhost:8025](http://localhost:8025): Mailpit GUI

## Installing Moodle

The `config.php.dist` file is copied to `html/config.php` if the latter does not exist. Step through the command line installation to install the database:

```bash
php admin/cli/install_database.php --lang=en_us --adminuser=admin --adminemail=somebody@example.net --agree-license --fullname=TEST --shortname=TEST --supportemail=somebody@example.net --adminpass=password
```

## Managing code

Moodle core is a shallow git clone in the `html` directory. There is a bare bones `composer.json` that can install plugins into that same directory.

## Behat testing

[moodle-browser-config](https://github.com/andrewnicols/moodle-browser-config) is automatically cloned to `moodle-browser-config` in the project root. Add the following to your config.php *before* initializing Behat:

```php
require_once('/path/to/your/project/moodle-browser-config/init.php');
```

Faildumps are stored in the `/behatfaildumps/` directory.