# Read .bashrc if it exists.
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

# Add scripts directory to executable path.
if [ -d STARTERKIT_ROOT ]; then
  PATH=STARTERKIT_ROOT/scripts:$PATH
fi
