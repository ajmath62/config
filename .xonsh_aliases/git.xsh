def _git_diff_add():
    status = $(git status --porcelain=v1)
    regex = r'^( M|UU|\?\?) (.*)$'
    file_list = re.findall(regex, status, re.MULTILINE)
    
    all_done = False
    for match_type, file in file_list:
        clear
        if match_type == '??':
            # Untracked file
            $[bat @(file)]
        else:
            $[git df -- @(file)]
        done = False
        while not done:
            yn = input(f'Git add {file}? (y/n/q/c/l/w/e/p) ').lower()
            if yn.startswith('y'):
                $[git add @(file)]
                done = True
            elif yn.startswith('n'):
                done = True
            elif yn.startswith('q'):
                done = True
                all_done = True
            elif yn.startswith('c'):
                clear
                $[bat @(file)]
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
                $[vim @(file)]
                clear
                $[git df -- @(file)]
            else:
                print('Please answer yes, no, quit, cat, line, word, edit or patch.')
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
    nth = int(args[0]) - 1 if args else 0
    return _git_branch_history()[nth]

def _git_last_branch_op(op, args):
    # Run a git operation on the nth last branch
    last_branch = _git_last_branch(args)
    return ![git @(op) @(last_branch) @(args[1:])]

def _git_log_hours(args):
    start_date = args[0] if args else 'midnight'
    $[git log --author=ajmath62@gmail.com --all --reverse '--pretty=%ad: %s' '--date=format:%a %h %d %I:%M%P' --since @(start_date)]

def _git_status_cow():
    return $(git status | cowsay -n -f @(_random_cow()))

def _git_reset_local_changes(args):
    stash = $(git diff) or $(git diff --cached)
    if stash:
        # There are local changes, so stash them before resetting
        ![git stash]
    ![git reset --hard @(args)]
    if stash:
        # Bring back local changes
        ![git stash pop]



# Git aliases (g)
# Branches (gb)
aliases['gbb'] = 'git merge-base '
aliases['gbc'] = 'git checkout '
aliases['gbcd'] = 'gbc development'
aliases['gbcm'] = 'gbc master'
aliases['gbco'] = lambda args: _git_last_branch_op('checkout', args)
aliases['gbcp'] = 'gbc production'
aliases['gbcs'] = 'gbc stable'
aliases['gbe'] = 'git branch -m '  # rename branch
aliases['gbi'] = _git_is_child
aliases['gbl'] = 'git branch --list '
aliases['gbla'] = 'git branch --list --all'
aliases['gblav'] = 'git branch --list --all --verbose --verbose '
aliases['gblv'] = 'git branch --list --verbose '
aliases['gblvv'] = 'git branch --list --verbose --verbose '
aliases['gbm'] = _git_reset_local_changes
aliases['gbn'] = lambda args: ![git checkout -b @(args[0])] and ![git push -u origin @(args[0])]
aliases['gbno'] = 'git checkout -b '
aliases['gbol'] = lambda: ![echo @('\n'.join(f'{idx: 2}\t{e}' for idx, e in enumerate(_git_branch_history(), start=1))) | oilr]
aliases['gbr?'] = 'git branch -d'
aliases['gbr??'] = 'git branch -D'
# Committing (gc)
aliases['gca'] = 'git add'
# add grandchild or great-grandchild migration directories
aliases['gcam'] = lambda: ![git add */migrations err> /dev/null] or ![git add */*/migrations]
aliases['gcap'] = 'git add --patch'  # git add by chunks of file
aliases['gcc'] = 'git commit '
aliases['gcca'] = 'git commit --amend '
aliases['gch'] = 'git reset HEAD'
aliases['gch?'] = 'git checkout -- '
aliases['gcm'] = 'git merge'
aliases['gcma?'] = 'git merge --abort '
aliases['gcmd'] = 'git merge development'
aliases['gcmm'] = 'git merge master'
aliases['gcmo'] = lambda args: _git_last_branch_op('merge', args)
aliases['gcp'] = 'git cherry-pick '
aliases['gcpo'] = lambda args: _git_last_branch_op('cherry-pick', args)
aliases['gcq'] = _git_diff_add
aliases['gcr?'] = 'git rm'
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
aliases['gdvc'] = 'git show --no-patch '
aliases['gdvl'] = 'git show '
aliases['gdvs'] = 'git show --stat '
# Rebase (ge)
aliases['ge'] = 'git rebase '
aliases['gea?'] = 'git rebase --abort '
aliases['gec'] = 'git rebase --continue '
aliases['gei'] = 'git rebase --interactive '
aliases['gem'] = 'git rebase master '
aliases['geo'] = lambda args: _git_last_branch_op('rebase', args)
aliases['gew'] = 'git rebase --show-current-patch '
# File operations (gf)
aliases['gfc'] = lambda: $[git ls-files | wc]
aliases['gfm'] = 'git mv '
aliases['gfl'] = lambda: $[git ls-files | less -FRXm]
aliases['gfr?'] = 'git rm '
# Log (gl)
aliases['glc'] = lambda: $[git log --pretty=%H | head -n +1]
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
aliases['gpm'] = lambda: $[git merge @('origin/' + $PROMPT_FIELDS['curr_branch']())]
aliases['gpn'] = 'git clone'
aliases['gpr'] = 'git pull --rebase'
aliases['gpu'] = 'git push'
aliases['gpun'] = lambda: $[git push -u origin @($PROMPT_FIELDS['curr_branch']())]
aliases['gput'] = 'git push --tags '
# Stash (gs)
aliases['gsl'] = 'git stash list'
aliases['gso'] = 'git stash pop'
aliases['gsp'] = 'git stash save --patch'  # git stash by chunks of file
aliases['gsr?'] = 'git stash drop'
aliases['gss'] = 'git stash push'
aliases['gsw'] = 'git stash show -u'  # displays diff of stash
aliases['gsws'] = 'git stash show '
# Bisect (gx)
aliases['gx'] = 'git bisect '
aliases['gxk'] = 'git bisect skip '
aliases['gxl'] = 'git bisect log '
aliases['gxn'] = 'git bisect bad '  # new
aliases['gxo'] = 'git bisect good '  # old
aliases['gxr?'] = 'git bisect reset '
aliases['gxx'] = 'git bisect start '
