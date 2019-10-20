#!/bin/bash
apt-get update
apt-get install -y git htop dstat vim curl wget inotify-tools \
    openssl dos2unix ntp libpq-dev nodejs npm postgresql-11
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb && rm -rf erlang-solutions_1.0_all.deb
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'postgres';"
ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
apt-get update
apt-get -y install esl-erlang elixir
