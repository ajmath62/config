def _git_diff_add():
    status = $(git status).split('\n')
    changed_color='1;31'  # git config color.status.changed; in this case, bold red
    matches = [re.search('^\t\x1b\[1;31m(?:both )?modified:   (.*)\x1b\[m$', l) for l in status]
    file_list = [m.group(1) for m in matches if m]
    
    all_done = False
    for file in file_list:
        clear
        $[git df -- @(file)]
        done = False
        while not done:
            yn = input(f'Git add {file}? (y/n/q/l/w/e/p) ').lower()
            if yn.startswith('y'):
                $[git add @(file)]
                done = True
            elif yn.startswith('n'):
                done = True
            elif yn.startswith('q'):
                done = True
                all_done = True
            elif yn.startswith('l'):
                clear
                $[git diff -- @(file)]
            elif yn.startswith('w'):
                clear
                $[git df -- @(file)]
            elif yn.startswith('p'):
                clear
                $[git add --patch @(file)]
                done = True
            elif yn.startswith('e'):
                $(vim @(file))
                clear
                $[git df -- @(file)]
            else:
                print('Please answer yes, no, quit, line, word, edit or patch.')
        if all_done:
            break
    clear
    $[git status]

def _git_is_child(args):
    # First argument is child commit, second is parent commit
    if !(git merge-base --is-ancestor @(args[0]) @(args[1])):
        print(f'{args[0]} is a child of {args[1]}')
    else:
        print(f'{args[0]} is not a child of {args[1]}')

def _git_branch_history():
    # ?m means multiline regex
    return re.findall(r"(?m)^'checkout: moving from (.+) to .+$", $(git log --walk-reflogs --pretty='%gs'))

def _git_last_branch(args):
    # Get the name of the branch that the nth last git checkout operation started at
    # If no argument is provided, use the most recent branch
    nth = args[0] - 1 if args else 0
    return _git_branch_history()[nth]

def _git_last_branch_op(args):
    # Run a git operation on the nth last branch
    last_branch = _git_last_branch(args[1:])
    return $(git @(args[0]) @(last_branch) @(args[2:]))

def _git_log_hours(args):
    start_date = args[0] if args else 'midnight'
    return $(git log --author=ajmath62@gmail.com --all --reverse --pretty="%ad: %s" --date="format:%h %d %I:%M%P" --since @(start_date))

def _git_status_cow():
    return $(git status | cowsay -n -f @(_random_cow()))


# Git aliases (g)
# Branches (gb)
aliases['gbb'] = 'git merge-base '
aliases['gbc'] = 'git checkout '
aliases['gbcd'] = 'gbc development'
aliases['gbcm'] = 'gbc master'
aliases['gbco'] = 'git_last_branch_op checkout '
aliases['gbcp'] = 'gbc production'
aliases['gbcs'] = 'gbc stable'
aliases['gbi'] = _git_is_child
aliases['gbl'] = 'git branch --list '
aliases['gbla'] = 'git branch --all'
aliases['gbm'] = 'git branch -m '  # rename branch
aliases['gbn'] = 'bv "git checkout -b" "git push -u origin"'
aliases['gbno'] = 'git checkout -b '
aliases['gbol'] = 'git_branch_history | nl -w2 -s": " | oilr '
aliases['gbr!'] = 'git branch -d'
# Committing (gc)
aliases['gca'] = 'git add'
aliases['gcam'] = 'git add */migrations 2> /dev/null || git add */*/migrations'  # add grandchild or great-grandchild migration directories
aliases['gcap'] = 'git add --patch'  # git add by chunks of file
aliases['gcb'] = 'git rebase '
aliases['gcbc'] = 'git rebase --continue '
aliases['gcbi'] = 'git rebase --interactive '
aliases['gcbm'] = 'git rebase master '
aliases['gcbo'] = 'git_last_branch_op rebase '
aliases['gcc'] = 'git commit '
aliases['gcca'] = 'git commit --amend '
aliases['gch'] = 'git reset HEAD'
aliases['gch!'] = 'git checkout -- '
aliases['gcm'] = 'git merge'
aliases['gcmd'] = 'git merge development'
aliases['gcmm'] = 'git merge master'
aliases['gcmo'] = 'git_last_branch_op merge'
aliases['gcp'] = 'git cherry-pick '
aliases['gcpo'] = 'git_last_branch_op cherry-pick '
aliases['gcq'] = _git_diff_add
aliases['gcr!'] = 'git rm'
# Diff (gd)
aliases['gdc'] = 'git df --cached'  # displays diff of staged changes
aliases['gdcs'] = 'git df --cached --stat'
aliases['gdd'] = 'git df '  # word diff
aliases['gdf'] = _git_status_cow
aliases['gdfc'] = 'git status'  # no cow
aliases['gdfcu'] = 'git status -uno'  # hide untracked files
aliases['gdfs'] = 'git status | cowsay -W80 -f $(random_cow)'
aliases['gdfu'] = 'git status -uno | cowsay -n -f $(random_cow)'
aliases['gdl'] = 'git diff '  # line diff
aliases['gdlc'] = 'git diff --cached'
aliases['gdo'] = 'gdd master origin/master'
aliases['gdos'] = 'gds master origin/master'
aliases['gds'] = 'git df --stat'  # displays diff but files only
aliases['gdv'] = 'git show --word-diff=color '
aliases['gdvl'] = 'git show '
aliases['gdvs'] = 'git show --stat '
# File operations (gf)
aliases['gfc'] = 'git ls-files | wc '
aliases['gfm'] = 'git mv '
aliases['gfl'] = 'git ls-files | less -FRXm '
aliases['gfr!'] = 'git rm '
# Log (gl)
aliases['glc'] = 'git log --pretty=%H | head -n +1'
aliases['glf'] = 'git reflog '
aliases['glh'] = _git_log_hours 
aliases['gll'] = 'git log '
aliases['glo'] = _git_last_branch
aliases['glp'] = 'git log --patch '
aliases['gls'] = 'git log --stat '
# Repository (gp)
aliases['gpa'] = 'git remote add '
aliases['gpd'] = 'git pull'
aliases['gpe'] = 'git remote set-url '
aliases['gpf'] = 'git fetch '
aliases['gpfp'] = 'git fetch --prune '
aliases['gpl'] = 'git remote --verbose'
aliases['gpm'] = 'git merge origin/$(git_parse_branch)'
aliases['gpr'] = 'git pull --rebase'
aliases['gpu'] = 'git push'
# Stash (gs)
aliases['gsl'] = 'git stash list'
aliases['gso'] = 'git stash pop'
aliases['gsp'] = 'git stash save --patch'  # git stash by chunks of file
aliases['gsr!'] = 'git stash drop'
aliases['gss'] = 'git stash save'
aliases['gsw'] = 'git stash show -u'  # displays diff of stash
aliases['gsws'] = 'git stash show '
