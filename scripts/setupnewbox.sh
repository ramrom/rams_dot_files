cd ~
cp RamsEnovaEnvFiles/.bashrc .
cp RamsEnovaEnvFiles/.bash_profile .
cp RamsEnovaEnvFiles/.gitconfig .
cp RamsEnovaEnvFiles/.git_completion.sh .
cp RamsEnovaEnvFiles/.vimrc .
cp -r RamsEnovaEnvFiles/.vim .
cp RamsEnovaEnvFiles/.tmux.conf .
ln -s RamsEnovaEnvFiles/.bash_aliases
ln -s RamsEnovaEnvFiles/.bash_aliases_8b
ln -s RamsEnovaEnvFiles/.bash_functions
ln -s RamsEnovaEnvFiles/.bash_functions_8b
ln -s RamsEnovaEnvFiles/.psqlrc

cp RamsEnovaEnvFiles/scripts/netcredit-tmux-env.sh ~

sudo apt-get update
sudo apt-get -y install tmux tree ack-grep htop exuberant-ctags
