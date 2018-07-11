# Python (p)
alias pa='python app.py'
alias pc=pip-compile
alias pcs=pip-sync
alias pcu='pip-compile --upgrade '
alias pf='pip list'
alias pi='pip install '
alias pii='pip install --upgrade pip'
alias pir='pip install -r requirements.txt'
alias piu='pip install --upgrade '
alias pl='pylint *'
alias pp=ipython
alias pr!='pip uninstall '
alias prf!='pip uninstall $(pip freeze)'
alias pv='python -V'
alias pw='pip show '
alias py=python

# Django (pd)
alias pdk='python manage.py addstatictoken '
alias pdm='python manage.py migrate '
alias pdmm='python manage.py makemigrations '
alias pdmq='python manage.py sqlmigrate '
alias pdms='python manage.py showmigrations '
alias pdn='python manage.py test --keepdb --exe --verbosity=3 --with-id '  # with nose
alias pdnf='pdn --failed'
alias pdp='python manage.py '
alias pdq='python manage.py dbshell'
alias pdr='python manage.py runserver_plus'
alias pdrm='python manage.py runserver'
alias pds='python manage.py shell_plus --print-sql --quiet-load'
alias pdsm='python manage.py shell_plus'
alias pdt='python manage.py test --keepdb --verbosity=3 '  # without nose
alias pdw='python -W ignore manage.py '

# JavaScript (e)
function es_lint {
  ./node_modules/.bin/eslint $@ && (echo -e "\n${GREENBOLD}  No errors${NOCOLOR}\n")
}
alias el=es_lint
alias et='rake jasmine'
alias etb='rake jasmine:ci'

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
alias eb-deploy='eb deploy'

# Specific tasks
function mongo {
  mongod --dbpath ${1} --port 27017 --smallfiles --nssize 1 --noprealloc --storageEngine mmapv1 --journal
}
function mongo_bg {
  mongod --dbpath ${1} --port 27017 --smallfiles --logpath ${1}/ajk_db/log.txt --logappend --nssize 1 --noprealloc --storageEngine mmapv1 --journal 1> /dev/null
}
alias bun='sudo rabbitmq-server'  # Rabbit MQ
alias bund='sudo rabbitmq-server -detached'
alias cry='celery worker -A gecko --loglevel=DEBUG -B -Q default,crush,udefutures'  # Celery
alias pgs='sudo -u postgres psql'  # PostgreSQL
alias xbar='crossbar start'  # Crossbar
alias om=mongo  # MongoDB
alias omb=mongo_bg
