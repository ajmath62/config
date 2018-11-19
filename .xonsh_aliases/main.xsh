# Common
aliases['be'] = 'echo'
aliases['bs'] = 'sudo'
aliases['bs?'] = 'sudo su'
aliases['bw'] = 'which'
aliases['bwp'] = 'which python'

# File manipulation
aliases['bk'] = 'ln -s'
aliases['bkh'] = 'ln'
aliases['bm'] = 'mv'
aliases['br?'] = 'rm -i'
aliases['br??'] = 'rm -ri'
aliases['br???'] = 'rm -rI'  # non-interactive

# Navigation
aliases['bc'] = 'cd'
aliases['bcd'] = 'cd ~/Documents'
aliases['bch'] = 'cd ~'
aliases['bcu'] = 'cd ..'
aliases['bcz'] = 'cd ~/zagaran'
aliases['bl'] = 'ls --color '
aliases['bla'] = 'ls --color -A '
aliases['bll'] = 'ls --color -Alh '

# Installing (ba)
aliases['baa'] = 'sudo apt-get autoremove'
aliases['bai'] = 'sudo apt-get install '
aliases['bar'] = 'sudo apt-get autoremove '
aliases['bar?'] = 'sudo apt-get remove '
aliases['baud'] = 'sudo apt-get dist-upgrade'
aliases['baug'] = 'sudo apt-get upgrade'
aliases['baut'] = 'sudo apt-get update'
aliases['bau'] = lambda: ![baut] and ![baug] and ![baud]

# Copy/Paste (bo)
aliases['bo'] = 'xclip -selection clipboard -in'
aliases['bop'] = 'xclip -selection clipboard -out'

# Database backup and restoration
# TODO: make these work with directories
# function bup {
#     cp $1 $1.backup
# }
# function ror {
#     cp $1.backup $1
# }

# Meta (f)
def _edit_aliases(args):
    # TODO: fix hardcoded home directory issue
    file = f'/home/aaron/.xonsh_aliases/{args[0]}.xsh'
    if !(test -f @(file)):
        # Argument that is an actual file -> edit that alias file
        $[gedit @(file)]
    else:
        print('No such alias file found.\nAvailable alias files:')
        for file in $(ls -A ~/.xonsh_aliases).split('\n'):
            print(file[:-4])  # strip .xsh\n

aliases['fa'] = _edit_aliases
aliases['fe'] = 'gedit ~/.xonshrc '
aliases['fs'] = 'source ~/.xonshrc'
aliases['fu'] = 'unalias -a'
aliases['fur'] = 'unalias -a && source ~/.xonshrc'

# Task PID
def _find_task_pid(args):
  return re.search(f'(?m)^ (\d+) .*{args[0]}', $(ps -e)).group(1)

def _kill_task(args):
  $[kill @(_find_task_pid(args))]


# Searching (s)
aliases['sa'] = 'ag --ignore=node_modules --ignore=doctor/data/*st.py --ignore=*.min.js* --ignore=*.cache --ignore=development.log --pager="less -FRXm" --column -i'
aliases['sap'] = 'sa -G .py$'
aliases['sapm'] = 'sap --ignore=*/migrations/* '
aliases['sar'] = 'ag'
aliases['sas'] = 'sa -s'  # case-sensitive
aliases['sau'] = 'sa -u '  # all
aliases['sav'] = 'sa --ignore=vendor --ignore=lib --ignore=packages '
aliases['sf'] = 'find $(pwd) | grep -in '
aliases['sg'] = 'grep -in'  # not case-sensitive, display line number
aliases['sr'] = _find_task_pid
aliases['srk?'] = _kill_task

# Cowsay
def _random_cow():
    return $(ls /usr/share/cowsay/cows | shuf -n1).rstrip('\n')

# Other (o)
aliases['obc'] = 'google-chrome'
aliases['obcc'] = 'google-chrome --force-device-scale-factor=1'  # make it small on monitors
aliases['obf'] = 'firefox -foreground '
aliases['obfd'] = 'firefox -foreground -P developer '  # open developer profile
aliases['obfs'] = 'firefox -foreground -search '
aliases['oo'] = 'xdg-open'
aliases['or'] = 'ruby'
aliases['orr'] = 'rails'
aliases['os'] = 'sqlite'
aliases['ov'] = 'vim'

# Pipes (oi)
aliases['oic'] = 'cowsay'
aliases['oicr'] = 'cowsay -f $(random_cow)'
aliases['oil'] = 'less -FRXm '
aliases['oilr'] = 'less'
aliases['oit'] = 'tail'
aliases['oith'] = 'head'
aliases['oiv'] = '/usr/share/vim/vim80/macros/less.sh'  # vim version of less
