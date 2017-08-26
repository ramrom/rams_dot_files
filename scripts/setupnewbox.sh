cd ~
cp rams_dot_files/.bashrc .
cp rams_dot_files/.bash_profile .
ln -s rams_dot_files/.bash_aliases
ln -s rams_dot_files/.bash_functions
cp rams_dot_files/.git_completion.sh .
ln -s rams_dot_files/.vim
ln -s rams_dot_files/.vimrc
ln -s rams_dot_files/.psqlrc
ln -s rams_dot_files/.tmux.conf
ln -s rams_dot_files/.gitconfig

cp rams_dot_files/scripts/base_tmux_env.sh .

sudo apt-get update
sudo apt-get -y install vim tmux tree ack-grep htop exuberant-ctags
