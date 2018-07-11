# Meta
alias p="vi ~/.bash_profile; source ~/.bash_profile" #edit user profile
alias log="vi ajk.timesheet"  #edit personal timesheet

#Info
alias version="uname -a; lsb_release -a" #get OS version info

# Settings
alias rm='printf "Be sure to use -i.\n"; rm -i' #to train me to not use rm noninteractively in other environments
alias rmrf='rm -r --interactive=no'  # override the -i above for recursive deletion

# Navigation
alias ls="ls --color"
alias la="ls -A"
alias ll="ls -Alh"
alias zag="cd ~/zagaran"

# Tasks
alias n="nano"
alias v="vim"
alias vls="/usr/share/vim/vim74/macros/less.sh"  #blah | vls is better than blah | less
alias mem="ps aux | head -1; ps aux | grep [p]ython" #memory usage etc. of all running python processes
alias cron="crontab -e" #editor for crontabs for the current user
alias scron="sudo crontab -e" #editor for crontabs for the super user
alias gc='google-chrome --force-device-scale-factor=1'
alias fx='firefox -foreground '
alias fx-s='fx -search '

# Python and Pip
alias py="python"
alias ipy="ipython"
alias del-pyc='find . -type f -name "*.pyc" -delete -print' #deletes all the .pyc files in current directory tree
alias pc-c='pip-compile '
alias pc-s='pip-sync '
alias pc-u='pip-compile --upgrade '
alias pp-i='pip install '
alias pp-p='pip install --upgrade pip'
alias pp-r='pip install -r requirements.txt '
alias pp-u='pip install --upgrade '

# Git functions
function git_store_old {
    _OLD_BRANCH=$(git_parse_branch)
}
function git_checkout_old {
    temp=$_OLD_BRANCH
    git_store_old
    git checkout $temp
}
function git_create_branch {
    git checkout -b $1 && git push -u origin $1
}
function git_diff_staged {
    git reset HEAD $1 1> /dev/null && git diff $1 && git add $1
}
function git_diff_add {
  file_list=$(git status | sed -n 's/^.*\x1B\[31m\(both \)\?modified:   \(.*\)\x1B.*$/\2/p')
  for file in $file_list; do
    clear && git df -- $file
    while true; do
      read -p "Git add $file? (y/n/l/w/e/p) " yn
      case $yn in
        [Yy]* ) git add $file; break;;
        [Nn]* ) break;;
        [Ll]* ) clear && git diff -- $file;;
        [Ww]* ) clear && git df -- $file;;
        [Pp]* ) clear && git add --patch $file; break;;
        [Ee]* ) vim $file && clear && git df -- $file;;
        * ) echo "Please answer yes, no, line, word, edit or patch.";;
      esac
    done
  done; clear && git status
}
function git_is_child {
  # First argument is child commit, second is parent commit
  git merge-base --is-ancestor $1 $2 && echo "$1 is a child of $2" || echo "$1 is not a child of $2"
}
function git_merge_old {
    git merge $_OLD_BRANCH
}

# Git aliases
# gb = branch, gc = commit, gd = diff, gp = repository, gs = stash
alias gb-c="git_store_old && git checkout"
alias gb-cd="gb-c development"
alias gb-cm="gb-c master"
alias gb-co="git_checkout_old"
alias gb-cp='gb-c production'
alias gb-cs="gb-c stable"
alias gb-l="git branch"
alias gb-la='git branch -a'
alias gb-n="ev 'git checkout -b' 'git push -u origin'"
alias gb-rr!="git branch -d"
alias gc-a="git add"
alias gc-am="git add */migrations 2> /dev/null || git add */*/migrations"  # add grandchild or great-grandchild migration directories
alias gc-c="git commit "
alias gc-ca='git commit --amend '
alias gc-h="git reset HEAD"
alias gc-hh="git checkout -- "
alias gc-m="git merge"
alias gc-md="git merge development"
alias gc-mm="git merge master"
alias gc-mo="git_merge_old"
alias gc-p="git add --patch"  # git add by chunks of file
alias gc-q="git_diff_add"
alias gc-r='git rebase '
alias gc-rc='git rebase --continue '
alias gc-rm='git rebase master '
alias gc-rr!="git rm"
alias gd-c="git df --cached"  # displays diff of staged changes
alias gd-d="git df "  # word diff
alias gd-f="git status"
alias gd-i=git_is_child
alias gd-l='git diff '  # line diff
alias gd-o='gd-d master origin/master'
alias gd-os='gd-s master origin/master'
alias gd-s="git df --stat"  # displays diff but files only
alias gd-v="git show --word-diff=color "
alias gd-vl='git show '
alias gd-vs="git show --stat "
alias gp-d="git pull"
alias gp-f='git fetch'
alias gp-r='git pull --rebase'
alias gp-u="git push"
alias gs-l="git stash list"
alias gs-o="git stash pop"
alias gs-p="git stash save --patch"  # git stash by chunks of file
alias gs-rr!="git stash drop"
alias gs-s="git stash save"
alias gs-w="git stash show -u"  # displays diff of stash
alias gs-ws='git stash show '

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
    ls -d ~/.virtualenvs/*/ | rev | cut -f2 -d"/" | rev; return 1;
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
alias sudo="sudo "

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
alias pmp="python manage.py"
alias pmp-w="python -W ignore manage.py"
alias pap="python app.py"
alias psp='pmp shell_plus --print-sql --quiet-load '
alias prp="pmp runserver_plus"
alias tst="pmp test --keepdb --exe --verbosity=3 --with-id "
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
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
PS1="$GREEN\u$YELLOW (\$(git_parse_branch_and_commit))$NO_COLOR: \w\$ "
PSFULL="$GREEN\u$YELLOW (\$(git_parse_branch_and_commit))$NO_COLOR: \w\$ "
PSFAST="$GREEN\u$NO_COLOR: \w\$ "

# PyEnv and RbEnv
if [[ $PATH != *"/home/aaron/.pyenv/bin"* ]]; then
    export PATH="/home/aaron/.pyenv/shims:/home/aaron/.pyenv/bin:$PATH";
    export PATH="/home/aaron/.rbenv/shims:/home/aaron/.rbenv/bin:$PATH";
fi

# Searching
alias grop="grep -in"  # not case-sensitive, display line number
alias ag="ag --ignore=node_modules --ignore=doctor/data/*st.py --ignore=*.min.js* --ignore=*.cache --ignore=development.log"
alias og="ag --pager='less -FRXm' --column "
alias ogu="og -u "
alias ogpy="og -G .py$"
alias ogpy-mig="ogpy --ignore=*/migrations/* "
alias ogv="og --ignore=vendor --ignore=lib "

# PyCharm
alias pch='/home/aaron/applications/pycharm-2017.3.4/bin/pycharm.sh'
function ev {
  lastarg=""
  for arg; do  # implied 'in $@'
    lastarg=$arg
  done
  for arg; do
    if [ "$arg" != "$lastarg" ]; then
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
