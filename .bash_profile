# Meta
alias p='vi ~/.bash_profile; source ~/.bash_profile' #edit user profile
alias log='vi ajk.timesheet'  #edit personal timesheet

#Info
alias version='uname -a; lsb_release -a' #get OS version info

# Settings
alias rm='printf "Be sure to use -i.\n"; rm -i' #to train me to not use rm noninteractively in other environments
alias rmrf='rm -r --interactive=no'  # override the -i above for recursive deletion

# Navigation
alias ls='ls --color'
alias la='ls -A'
alias ll='ls -Alh'
alias zag='cd ~/zagaran'

# Tasks
alias n=nano
alias v=vim
alias vls='/usr/share/vim/vim74/macros/less.sh'  #blah | vls is better than blah | less
alias mem='ps aux | head -1; ps aux | grep [p]ython' #memory usage etc. of all running python processes
alias cron='crontab -e' #editor for crontabs for the current user
alias scron='sudo crontab -e' #editor for crontabs for the super user
alias gc='google-chrome --force-device-scale-factor=1'
alias fx='firefox -foreground '
alias fx-s='fx -search '

# Python and Pip
alias py=python
alias ipy=ipython
alias del-pyc='find . -type f -name "*.pyc" -delete -print' #deletes all the .pyc files in current directory tree
alias pc-c='pip-compile '
alias pc-s='pip-sync '
alias pc-u='pip-compile --upgrade '
alias pp-i='pip install '
alias pp-p='pip install --upgrade pip'
alias pp-r='pip install -r requirements.txt '
alias pp-u='pip install --upgrade '

# Show git branch
# The 2> /dev/null is because there is stderr if not in a git repository
function git_parse_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* //"
}
function git_parse_commit() {
  git log --pretty=%h 2> /dev/null | head -n +1
}
function git_parse_branch_and_commit() {
  echo $(git_parse_branch): $(git_parse_commit)
}

# Activate virtual environment
function _curr {
  pwd | rev | cut -f1 -d/ | rev
}
function venv {
  if [ -z $1 ]; then  # -z: has zero length
    venv_name=$(_curr);
  else
    venv_name=$1;
  fi
  if [ -d ~/.virtualenvs/$venv_name/ ]; then  # -d: is a directory
    source ~/.virtualenvs/$venv_name/bin/activate
  else
    # No directory found, so list all the available virtual envs
    echo 'No virtual environment found. Please specify one of the following:'
    ls -d ~/.virtualenvs/*/ | rev | cut -f2 -d'/' | rev; return 1;
  fi
}
# Create new virtual environment
function venv-new {
  if [ -z $1 ]; then
    venv_name=$(_curr)
  else
    venv_name=$1
  fi
  virtualenv -p python ~/.virtualenvs/$venv_name
}
alias sv='venv '
alias dv='deactivate'

# Weird thing Eli told me to do
alias sudo='sudo '

# Database backup and restoration
function bup {
    cp $1 $1.backup
}
function ror {
    cp $1.backup $1
}

# Check for non-ASCII characters
alias ascii='~/ascii '

# Django
alias pmp='python manage.py'
alias pmp-w='python -W ignore manage.py'
alias pap='python app.py'
alias psp='pmp shell_plus --print-sql --quiet-load '
alias prp='pmp runserver_plus'
alias tst='pmp test --keepdb --exe --verbosity=3 --with-id '
alias tst!='tst --failed '

# AWS
alias eb-ssh='echo "source /opt/python/current/env && cd /opt/python/current/app && python manage.py shell_plus --print-sql --quiet-load"; eb ssh '

# AngularJS component generation
function new_component {
    # syntax is new_component directory type subdirectory name
    full_dir=$1'/'$3'/'$4;
    js_file=$full_dir'/'$4'.'$2'.js'
    html_file=$full_dir'/'$4'.view.html'
    mkdir $full_dir  # If directory exists already, we don't care
    ta $js_file && ta $html_file && echo 'Success!'
}

# Define colors for displaying the git branch
RED='\[\033[0;31m\]'
YELLOW='\[\033[0;33m\]'
GREEN='\[\033[0;32m\]'
NO_COLOR='\[\033[0m\]'
PS1="$GREEN\u$YELLOW (\$(git_parse_branch_and_commit))$NO_COLOR: \w\$ "
PSFULL="$GREEN\u$YELLOW (\$(git_parse_branch_and_commit))$NO_COLOR: \w\$ "
PSFAST="$GREEN\u$NO_COLOR: \w\$ "

# PyEnv and RbEnv
if [[ $PATH != *'/home/aaron/.pyenv/bin'* ]]; then
    export PATH='/home/aaron/.pyenv/shims:/home/aaron/.pyenv/bin:$PATH';
    export PATH='/home/aaron/.rbenv/shims:/home/aaron/.rbenv/bin:$PATH';
fi

# Searching
alias grop='grep -in'  # not case-sensitive, display line number
alias ag='ag --ignore=node_modules --ignore=doctor/data/*st.py --ignore=*.min.js* --ignore=*.cache --ignore=development.log'
alias og='ag --pager="less -FRXm" --column '
alias ogu='og -u '
alias ogpy='og -G .py$'
alias ogpy-mig='ogpy --ignore=*/migrations/* '
alias ogv='og --ignore=vendor --ignore=lib '

# PyCharm
alias pch='/home/aaron/applications/pycharm-2017.3.4/bin/pycharm.sh'
function ev {
  lastarg=''
  for arg; do  # implied 'in $@'
    lastarg=$arg
  done
  for arg; do
    if [ $arg != $lastarg ]; then
      eval $arg $lastarg || break  # if this fails, exit
    fi
  done
}
alias ta='ev touch "git add" '
alias tpa='ev touch "git add" pch '
function po {
  for file in $(eval "$@ -l" | sed -n "s/\(.* results begin here:\|.*_\{10\}\)\?/""/p"); do
    pch $file &
  done;
}


if [ -f ~/.bash_aliases/init.sh ]; then
   . ~/.bash_aliases/init.sh
fi
