# Linode DNS Updater

Tools to update Linode DNS.
Uses the `linode` gem to sync domains with Linode's DNS service.

I host my own DNS using BIND, but for reliability I want multiple slave DNS servers.
Linode fulfills this need nicely, but when I first set up DNS I needed to create a bunch of slave zones, and I didn't 
want to do it manually.

The only script that currently exists is able to take a list of domain names and ensure that all of them exist as slave 
zones in Linode DNS, and that there are no other slave DNS zones.
It also updates the Master IPs of any already-existing domains.

## Usage

1. Copy `config.example.yml` to `config.yml` and make changes.
2. `rb update-slaves.rb`

## Development

I threw this together for a quick need and will probably use it once a year or so.
I would welcome Pull Requests and improvements to make it more modular.
