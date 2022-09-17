# TT-RSS on Fly.io

At the time of writing, this works in Fly.io free tier (as we're using only 2 apps and 2 GB of storage), which requires adding a valid credit card.
DO NOT go this route if you don't want to experiment on the platform and/or pay accidentally.
These are just my notes, you can follow along at your own risk.

## Quick start

Supposing you have already a Fly.io account and you have the CLI installed:

```sh
PREFIX=your-name

# Create a db instance, if you don't have one already. Select "Development" to stay on free tier.
flyctl postgres create --name $PREFIX-db

# Create the tt-rss application
flyctl launch --name $PREFIX-ttrss --no-deploy

# Attach the database to the app
flyctl postgres attach --app $PREFIX-ttrss $PREFIX-db

# Create a persistent volume to store the application data (favicons, plugins, sessions, ...)
fly volumes create data --size 1

# Customize fly.toml
envsubst '$PREFIX' <fly.toml.tmpl >fly.toml

# Create your admin password (you can use the same command to change it later)
flyctl secrets set ADMIN_USER_PASS=use-a-very-strong-password

# Launch and open the app! Note: on the first start, you'll may need to wait a couple of minutes for the installation.
flyctl deploy
flyctl open
```

## Install a plugin

```sh
# Connect to the running application
flyctl ssh console

# Change to the plugins directory
cd /var/www/html/tt-rss/plugins.local

# Follow the install instructions
# For example, for https://community.tt-rss.org/t/favicon-badge-plugin/1441:
git clone https://github.com/ctag/favicon_badge
```

## Local setup

The original TT-RSS on Docker install uses multiple containers running in parallel, which would not work in Fly.io free tier.
In order to have it go inside a single container, I had to add some moving parts which might need some smoke test from time to time.

That's why there is a `docker-compose.yaml` file, but you are probably not interested in using that, unless you're contributing, of course!
