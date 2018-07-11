# Show git branch
# The 2> /dev/null is because there is stderr if not in a git repository
function git_parse_branch {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* //"
}
function git_parse_commit {
  git log --pretty=%h 2> /dev/null | head -n +1
}
function git_parse_branch_and_commit {
  echo $(git_parse_branch): $(git_parse_commit)
}

# Colors
function make_color {
  # Using -e here means we don't have to use it anywhere else
  echo -e "\033[${1}m"
}
GREEN=$(make_color '0;32')
GREENBOLD=$(make_color '1;32')
NOCOLOR=$(make_color '0')
RED=$(make_color '0;31')
YELLOW=$(make_color '0;33')

# Bash prompt
PS1="${GREEN}\u${YELLOW} (\$(git_parse_branch_and_commit))${NOCOLOR}: \w\$ "
PSFULL="${GREEN}\u${YELLOW} (\$(git_parse_branch_and_commit))${NOCOLOR}: \w\$ "
PSFAST="${GREEN}\u${NOCOLOR}: \w\$ "

# PyEnv and RbEnv
if [[ $PATH != *'/home/aaron/.pyenv/bin'* ]]; then
    export PATH='/home/aaron/.pyenv/shims:/home/aaron/.pyenv/bin:$PATH';
    export PATH='/home/aaron/.rbenv/shims:/home/aaron/.rbenv/bin:$PATH';
fi

# Load aliases
if test -f ~/.bash_aliases/init.sh; then
   source ~/.bash_aliases/init.sh
fi
