# Get current branch and short commit hash
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
function local_version {
  # Get version of python (default) or ruby (in a ruby project)
  if test -f ./Gemfile; then
    echo 'ruby:' $(rbenv version-name)
  else
    echo $(pyenv version-name)
  fi
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
# The [] need to be around the colors so that the bash prompt doesn't count their length, which would cause wrapping issues.
PS1="(\$(local_version)) \[${GREEN}\]\u\[${YELLOW}\] (\$(git_parse_branch_and_commit))\[${NOCOLOR}\]: \w\$ "
PSFULL=${PS1}
PSFAST="\[${GREEN}\]\u[\[${NOCOLOR}\]: \w\$\] "

# Set up autocompletion for bash and git
source /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/completions/git
# Allow branch autocompletion for all checkout-like aliases
CLA='gbb gbc gbi gcb gcm gcp gdd gdl gds gdv gdvl gdvs glc gll glp gls'
for _alias in ${CLA}; do
  __git_complete ${_alias} _git_checkout
done

# PyEnv and RbEnv
if test -z $PYENV_LOADED; then
  export PATH="~/.pyenv/bin:~/.rbenv/bin:${PATH}"
  eval "$(~/.pyenv/bin/pyenv init -)"
  eval "$(~/.pyenv/bin/pyenv virtualenv-init -)"
  eval "$(~/.rbenv/bin/rbenv init -)"
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1  # warning given on activation
  PYENV_LOADED=1
fi

# Load aliases
if test -f ~/.bash_aliases/.init.sh; then
   source ~/.bash_aliases/.init.sh
fi
