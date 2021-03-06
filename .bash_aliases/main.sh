# Common
alias be=echo
alias bs=sudo
alias bs!='sudo su'
alias bt=type
alias bw=which
alias bwp='which python'

# File manipulation
alias bk='ln -s'
alias bkh=ln
alias bm=mv
alias br!='rm -i'
alias brr!='rm -ri'
alias brrr!='rm -rI'  # non-interactive

# Navigation
alias bc=cd
alias bcd='cd ~/Documents'
alias bch='cd ~'
alias bcu='cd ..'
alias bcz='cd ~/zagaran'
alias bl='ls --color '
alias bla='ls --color -A '
alias bll='ls --color -Alh '

# Installing (ba)
alias baa='sudo apt-get autoremove'
alias bai='sudo apt-get install '
alias bar='sudo apt-get autoremove '
alias bar!='sudo apt-get remove '
alias baud='sudo apt-get dist-upgrade'
alias baug='sudo apt-get upgrade'
alias baut='sudo apt-get update'
alias bau='baut && baug && baud'

# Copy/Paste (bo)
alias bo='xclip -selection clipboard -in'
alias bop='xclip -selection clipboard -out'

# Tasks
alias mem='ps aux | head -1; ps aux | grep [p]ython' #memory usage etc. of all running python processes
alias cron='crontab -e' #editor for crontabs for the current user
alias scron='sudo crontab -e' #editor for crontabs for the super user

# Database backup and restoration
# TODO: make these work with directories
function bup {
    cp $1 $1.backup
}
function ror {
    cp $1.backup $1
}

# Meta (f)
function edit_aliases {
  if test -f ~/.bash_aliases/${1}.sh; then
    # Argument that is an actual file -> edit that alias file
    gedit ~/.bash_aliases/${1}.sh
  else
    echo -e 'No such alias file found.\nAvailable alias files:'
    for file in $(ls -A ~/.bash_aliases); do
      echo ${file} | sed s/.sh//
    done
  fi
}
alias fa=edit_aliases
alias fe='gedit ~/.bash_profile '
alias fs='source ~/.bash_profile'
alias fu='unalias -a'
alias fur='unalias -a && source ~/.bash_profile'

# Task PID
function find_task_pid {
  ps -e | grep ${1} | head -n1 | cut -d ' ' -f2
}
function kill_task {
  kill $(find_task_pid ${1})
}

# Searching (s)
alias sa='ag --ignore=node_modules --ignore=doctor/data/*st.py --ignore=*.min.js* --ignore=*.cache --ignore=development.log --pager="less -FRXm" --column -i'
alias sap='sa -G .py$'
alias sapm='sap --ignore=*/migrations/* '
alias sar=ag
alias sas='sa -s'  # case-sensitive
alias sau='sa -u '  # all
alias sav='sa --ignore=vendor --ignore=lib '
alias sf='find $(pwd) | grep -in '
alias sg='grep -in'  # not case-sensitive, display line number
alias sr='ps -ef | grep -in '
alias srk='kill_task '

# Cowsay
function random_cow {
  ls /usr/share/cowsay/cows | shuf -n1
}

# Other (o)
alias obc=google-chrome
alias obcc='google-chrome --force-device-scale-factor=1'  # make it small on monitors
alias obf='firefox -foreground '
alias obfd='firefox -foreground -P developer '  # open developer profile
alias obfs='firefox -foreground -search '
alias oo=xdg-open
alias or=ruby
alias orr=rails
alias os=sqlite
alias ov=vim

# Pipes (oi)
alias oic=cowsay
alias oicr='cowsay -f $(random_cow)'
alias oil='less -FRXm '
alias oilr=less
alias oit=tail
alias oith=head
alias oiv=/usr/share/vim/vim80/macros/less.sh  # vim version of less
