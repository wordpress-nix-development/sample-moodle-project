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

Default MySQL credentials are defined in `devenv.nix`. If the `moodle` database does not exist on `devenv up` it will create it. Cron is enabled by default.

## Managing code

Moodle core is a shallow git clone in the `html` directory. There is a bare bones `composer.json` that can install plugins into that same directory.