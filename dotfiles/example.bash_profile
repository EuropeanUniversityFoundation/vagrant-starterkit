# Read .bashrc if it exists.
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

# Add scripts directory to executable path.
if [ -d VAGRANT_ROOT ]; then
  PATH=VAGRANT_ROOT/scripts:$PATH
fi
