#!/bin/bash


template_config_file="$HOME/dotfiles/config/mopidy/mopidy.conf"

user="bartek.taczala@gmail.com"
pass=$(pass private/spotify.com/bartek.taczala@gmail.com)
client_id=$(pass private/spotify.com/client_id)
client_secret=$(pass private/spotify.com/client_secret)

config_file=$(mktemp)
trap 'rm -f "$config_file"' EXIT
cp $template_config_file $config_file

sed -i -e "s/{{SPOTIFY_USERNAME}}/$user/g" $config_file
sed -i -e "s/{{SPOTIFY_PASSWORD}}/$pass/g" $config_file
sed -i -e "s/{{SPOTIFY_CLIENT_ID}}/$client_id/g" $config_file
sed -i -e "s/{{SPOTIFY_CLIENT_SECRET}}/$client_secret/g" $config_file

mopidy --config $config_file
