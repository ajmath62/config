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


# Django
alias pmp='python manage.py'
alias pmp-w='python -W ignore manage.py'
alias pap='python app.py'
alias psp='pmp shell_plus --print-sql --quiet-load '
alias prp='pmp runserver_plus'
alias tst='pmp test --keepdb --exe --verbosity=3 --with-id '
alias tst!='tst --failed '


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

# Virtual environment
function _curr {
  pwd | rev | cut -f1 -d/ | rev
}
function venv {
  # Activate virtual environment
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
function venv-new {
  # Create new virtual environment
  if [ -z $1 ]; then
    venv_name=$(_curr)
  else
    venv_name=$1
  fi
  virtualenv -p python ~/.virtualenvs/$venv_name
}
alias sv='venv '
alias dv='deactivate'

# Check for non-ASCII characters
alias ascii='~/ascii '

# AngularJS component generation
function new_component {
    # syntax is new_component directory type subdirectory name
    full_dir=$1'/'$3'/'$4;
    js_file=$full_dir'/'$4'.'$2'.js'
    html_file=$full_dir'/'$4'.view.html'
    mkdir $full_dir  # If directory exists already, we don't care
    ta $js_file && ta $html_file && echo 'Success!'
}

# AWS
alias eb-ssh='echo "source /opt/python/current/env && cd /opt/python/current/app && python manage.py shell_plus --print-sql --quiet-load"; eb ssh '
