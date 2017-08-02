cd ~
cp rams_dot_files/.bashrc .
cp rams_dot_files/.bash_profile .
cp rams_dot_files/.gitconfig .
cp rams_dot_files/.git_completion.sh .
cp rams_dot_files/.vimrc .
cp -r rams_dot_files/.vim .
cp rams_dot_files/.tmux.conf .
ln -s rams_dot_files/.bash_aliases
ln -s rams_dot_files/.bash_functions
ln -s rams_dot_files/.psqlrc

cp rams_dot_files/scripts/base_tmux_env.sh .

sudo apt-get update
sudo apt-get -y install tmux tree ack-grep htop exuberant-ctags
