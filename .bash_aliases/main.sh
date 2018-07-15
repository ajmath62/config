# Common
alias be=echo
alias bs=sudo
alias bs!='sudo su'
alias bt=type
alias bw=which
alias bwp='which python'

# File manipulation
alias bk=ln
alias bm=mv
alias br!='rm -i'
alias brr!='rm -ri'
alias brr!!='rm -r'  # non-interactive

# Navigation
alias bc=cd
alias bch='cd ~'
alias bcu='cd ..'
alias bcz='cd ~/zagaran'
alias bl='ls --color '
alias bla='ls --color -A '
alias bll='ls --color -Alh '

# Installing (ba)
alias baa='sudo apt-get autoremove'
alias bai='sudo apt-get install '
alias bar!='sudo apt-get remove '
alias baud='sudo apt-get update'
alias baug='sudo apt-get upgrade'
alias bau='baud && baug'

# Tasks
alias mem='ps aux | head -1; ps aux | grep [p]ython' #memory usage etc. of all running python processes
alias cron='crontab -e' #editor for crontabs for the current user
alias scron='sudo crontab -e' #editor for crontabs for the super user
alias gc='google-chrome --force-device-scale-factor=1'
alias fx='firefox -foreground '
alias fx-s='fx -search '

# Database backup and restoration
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

# Searching (s)
alias sa='ag --ignore=node_modules --ignore=doctor/data/*st.py --ignore=*.min.js* --ignore=*.cache --ignore=development.log --pager="less -FRXm" --column'
alias sap='sa -G .py$'
alias sapm='sap --ignore=*/migrations/* '
alias sar=ag
alias sau='sa -u '  # all
alias sav='sa --ignore=vendor --ignore=lib '
alias sg='grep -in'  # not case-sensitive, display line number

# Cowsay
function random_cow {
  ls /usr/share/cowsay/cows | shuf -n1
}

# Other (o)
alias oo=xdg-open
alias or=ruby
alias orr=rails
alias os=sqlite
alias ov=vim

# Pipes (oi)
alias oic=cowsay
alias oicr='cowsay -f $(random_cow)'
alias oil=less
alias oit=tail
alias oith=head
alias oiv=/usr/share/vim/vim80/macros/less.sh  # vim version of less
