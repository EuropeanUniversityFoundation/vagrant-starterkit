# Full blown list.
alias lh="ls -hAlF"
# List 3 levels using tree; append 's' to enable scrolling inside less.
alias lt='tree -a -F -I '\''.git|.vagrant'\'' -L 3 --dirsfirst'
alias lts='tree -a -F -I '\''.git|.vagrant'\'' -L 3 --dirsfirst -C | less -R'
# List directories only using tree; append 's' to enable scrolling inside less.
alias dt='tree -a -F -I '\''.git|.vagrant'\'' -d'
alias dts='tree -a -F -I '\''.git|.vagrant'\'' -d -C | less -R'
# Specific aliases to run at the root of a Drupal 8+ project.
alias sdf='tree -L 3 -I '\''css|js|php|styles'\'' web/sites/default/ -C | less -R'
alias t8='tree -L 4 -I '\''vendor|node_modules|core'\'' -d -C | less -R'
# Quick access to update-alternatives.
alias alt='sudo update-alternatives --config'
