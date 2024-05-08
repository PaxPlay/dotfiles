CONFIG_HOME="$HOME/.config"

NVIM_CONFIG="$CONFIG_HOME/nvim"
rm "$NVIM_CONFIG/init.vim"
ln nvim/init.vim "$NVIM_CONFIG/"

