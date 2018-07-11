# Timesheet
alias log='vi ajk.timesheet'

# File deletion
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

# Weird thing Eli told me to do
alias sudo='sudo '

# Database backup and restoration
function bup {
    cp $1 $1.backup
}
function ror {
    cp $1.backup $1
}

# Meta
alias p='vi ~/.bash_profile; source ~/.bash_profile' #edit user profile

# Searching
alias grop='grep -in'  # not case-sensitive, display line number
alias ag='ag --ignore=node_modules --ignore=doctor/data/*st.py --ignore=*.min.js* --ignore=*.cache --ignore=development.log'
alias og='ag --pager="less -FRXm" --column '
alias ogu='og -u '
alias ogpy='og -G .py$'
alias ogpy-mig='ogpy --ignore=*/migrations/* '
alias ogv='og --ignore=vendor --ignore=lib '
