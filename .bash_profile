# Meta
alias p="vi ~/.bash_profile; source ~/.bash_profile" #edit user profile
alias log="vi ajk.timesheet"  #edit personal timesheet

#Info
alias version="uname -a; lsb_release -a" #get OS version info

# Settings
alias rm='printf "Be sure to use -i.\n"; rm -i' #to train me to not use rm noninteractively in other environments

# Navigation
alias ls="ls --color"
alias la="ls -A"
alias ll="ls -Alh"
alias zag="cd ~/Zagaran"

# Tasks
alias n="nano"
alias v="vim"
alias vls="/usr/share/vim/vim74/macros/less.sh"  #blah | vls is better than blah | less
alias py="python"
alias ipy="ipython"
alias del-pyc='find . -type f -name "*.pyc" -delete -print' #deletes all the .pyc files in current directory tree
alias mem="ps aux | head -1; ps aux | grep [p]ython" #memory usage etc. of all running python processes
alias cron="crontab -e" #editor for crontabs for the current user
alias scron="sudo crontab -e" #editor for crontabs for the super user

# Git functions
function git_store_old {
    _OLD_BRANCH=$(parse_git_branch)
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
for file in $(git status $1 | sed -n "s/\t\(both \)\?modified:   /""/p"); do
    diff=$(git diff $file)
    if [ -z "$diff" ]
        then continue
        else clear; git diff $file
    fi
    while true; do
        read -p "Git add $file? (Y/N/E) " yn
        case $yn in
            [Yy]* ) git add $file; break;;
            [Nn]* ) break;;
            [Ee]* ) clear; git add --patch $file; break;;
            * ) echo "Please answer yes, no or edit.";;
        esac
    done
done; clear; git status
}

# Git aliases
# gb = branch, gc = commit, gd = diff, gp = repository, gs = stash
alias gb-c="git_store_old && git checkout"
alias gb-cd="gb-c development"
alias gb-cm="gb-c master"
alias gb-co="git_checkout_old"
alias gb-cs="gb-c stable"
alias gb-l="git branch"
alias gb-n="git_create_branch"
alias gb-rr="git branch -d"
alias gc-a="git add"
alias gc-am="git add */migrations 2> /dev/null || git add */*/migrations"  # add grandchild or great-grandchild migration directories
alias gc-c="git commit"
alias gc-h="git reset HEAD"
alias gc-hh="git checkout --"
alias gc-m="git merge"
alias gc-md="git merge development"
alias gc-mm="git merge master"
alias gc-p="git add --patch"  # git add by chunks of file
alias gc-q="git_diff_add"
alias gc-rr="git rm"
alias gd-c="git diff --cached"  # displays diff of staged changes
alias gd-d="git diff"
alias gd-f="git status"
alias gd-ff="git status | sed -e \"s+git add+gc-a+\" -e \"s+git checkout+gc-hh+\" -e \"s+git reset HEAD+gc-h+\" -e \"s+git commit+gc-c+\""  # yes I know it's weird
alias gd-g="git_diff_staged"
alias gd-s="git diff --stat"  # displays diff but files only
alias gp-d="git pull"
alias gp-u="git push"
alias gs-l="git stash list"
alias gs-o="git stash pop"
alias gs-p="git stash --patch"  # git stash by chunks of file
alias gs-rr="git stash drop"
alias gs-s="git stash"
alias gs-w="git stash show -u"  # displays diff of stash

# Show git branch
function parse_git_branch() {
   git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* //"
}

# Activate virtual environment
function venv {
   test "$1" || {
       curr=$(pwd | rev | cut -f1 -d"/" | rev)
       [ -d ~/.virtualenvs/"$curr"/ ] && source ~/.virtualenvs/"$curr"/bin/activate && return 1;
   } || {
       ls -d ~/.virtualenvs/*/ | rev | cut -f2 -d"/" | rev; return 1;
   }
   source ~/.virtualenvs/"$1"/bin/activate
}
# Create new virtual environment
function venv-new {
   dir=$(pwd);
   test "$1" && python="$1" || python="python"
   test "$2" && envname="$2" || { envname=$(pwd | rev | cut -f1 -d"/" | rev); }
   virtualenv -p $(which $python) ~/.virtualenvs/$envname
   cd $dir
}
# Alias to deactivate virtual environment
alias dv="deactivate"

# Weird thing Eli told me to do
alias sudo="sudo "

# Database backup and restoration
function bup {
    cp $1 $1.backup
}
function ror {
    cp $1.backup $1
}

# Define colors for displaying the git branch
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
PS1="$GREEN\u$YELLOW (\$(parse_git_branch))$NO_COLOR: \w\$ "
PSFULL="$GREEN\u$YELLOW (\$(parse_git_branch))$NO_COLOR: \w\$ "
PSFAST="$GREEN\u$NO_COLOR: \w\$ "

# Django
alias pmp="python manage.py"
alias pmp-w="python -W ignore manage.py"
alias pap="python app.py"
alias psp="pmp shell_plus"
alias prp="pmp runserver_plus"
alias tst="pmp test --keepdb --with-specplugin --exe --nologcapture --verbosity=3"

# PyEnv
#if [[ $PATH != *"/home/AaronK/.pyenv/bin"* ]]; then
#    export PATH="/home/AaronK/.pyenv/plugins/pyenv-virtualenv/shims:/home/AaronK/.pyenv/shims:/home/AaronK/.pyenv/bin:$PATH"
#fi
#alias pe-prep='eval "$(pyenv init -)"; eval "$(pyenv virtualenv-init -)"'
if [[ $PATH != *"/home/AaronK/python_bin"* ]];
    then export PATH="/home/AaronK/.pyenv/shims:/home/AaronK/.pyenv/bin:/home/AaronK/python_bin:$PATH"
fi

# Searching
alias grop="grep -in"  # not case-sensitive, display line number
alias ag="ag --ignore=node_modules --ignore=doctor/data/*st.py --ignore=*.min.js "
alias og="clear; printf '_%.0s' {1..100}; echo ''; echo 'Silver results begin here:'; ag --column "
alias ogu="og -u "
alias ogpy="og -G .py$"
alias ogpy-mig="ogpy --ignore=*/migrations/* "

# PyCharm
alias pch='"/mnt/c/Program Files/JetBrains/PyCharm 2017.2.3/bin/pycharm64.exe"'
function ev {
  lastarg=""
  for arg; do  # implied 'in $@'
    lastarg=$arg
  done
  for arg; do
    if [ "$arg" != "$lastarg" ]; then
      eval $arg $lastarg
    fi
  done
}
alias ta='ev touch "git add" '
alias tpa='ev touch "git add" pch '
function po {
  for file in $(eval "$@ -l" | sed -n "s/\(.* results begin here:\|.*_\{10\}\)\?/""/p"); do
    pch $file;
  done;
}
