# Git functions
function git_diff_add {
  changed_color='1;31' # git config color.status.changed; in this case, bold red
  file_list=$(git status | sed -n "s/^.*\x1B\[${changed_color}m\(both \)\?modified:   \(.*\)\x1B.*$/\2/p")
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
        * ) echo 'Please answer yes, no, line, word, edit or patch.';;
      esac
    done
  done; clear && git status
}
function git_is_child {
  # First argument is child commit, second is parent commit
  git merge-base --is-ancestor $1 $2 && echo "$1 is a child of $2" || echo "$1 is not a child of $2"
}
function git_branch_history {
  git log --walk-reflogs --pretty='%gs' | sed -n 's/^checkout: moving from \(.*\?\) to .*\?$/\1/p' -n
}
function git_last_branch {
  # Get the name of the branch that the nth last git checkout operation started at
  # If no argument is provided, use the most recent branch
  nth=${1:-1}
  git_branch_history | sed -n ${nth}p
}
function git_last_branch_op {
  # Run a git operation on the nth last branch
  operation=${1}
  git ${operation} $(git_last_branch ${2}) ${@:3}
}
function git_log_hours {
  if test ${1}; then
    start_date="--since=${1}"
  else
    unset start_date
  fi
  git log --author=ajmath62@gmail.com --all --reverse --pretty="%ad: %s" --date="format:%h %d %I:%M%P" ${start_date}
}

# Git aliases (g)
# Branches (gb)
alias gbc='git checkout '
alias gbcd='gbc development'
alias gbcm='gbc master'
alias gbco='git_last_branch_op checkout '
alias gbcp='gbc production'
alias gbcs='gbc stable'
alias gbl='git branch --list '
alias gbla='git branch --all'
alias gbm='git branch -m '
alias gbn='bv "git checkout -b" "git push -u origin"'
alias gbno='git checkout -b '
alias gbo=git_last_branch
alias gbol='git_branch_history | nl -w2 -s": " | oil '
alias gbr!='git branch -d'
# Committing (gc)
alias gca='git add'
alias gcam='git add */migrations 2> /dev/null || git add */*/migrations'  # add grandchild or great-grandchild migration directories
alias gcb='git rebase '
alias gcbc='git rebase --continue '
alias gcbm='git rebase master '
alias gcbo='git_last_branch_op rebase '
alias gcc='git commit '
alias gcca='git commit --amend '
alias gch='git reset HEAD'
alias gch!='git checkout -- '
alias gcm='git merge'
alias gcmd='git merge development'
alias gcmm='git merge master'
alias gcmo='git_last_branch_op merge'
alias gcp='git add --patch'  # git add by chunks of file
alias gcq=git_diff_add
alias gcr!='git rm'
# Diff (gd)
alias gdc='git df --cached'  # displays diff of staged changes
alias gdcs='git df --cached --stat'
alias gdd='git df '  # word diff
alias gdf='git status | cowsay -n -f $(random_cow)'
alias gdfc='git status'  # no cow
alias gdfcu='git status -uno'  # hide untracked files
alias gdfs='git status | cowsay -W80 -f $(random_cow)'
alias gdfu='git status -uno | cowsay -n -f $(random_cow)'
alias gdi=git_is_child
alias gdl='git diff '  # line diff
alias gdlc='git diff --cached'
alias gdo='gd-d master origin/master'
alias gdos='gd-s master origin/master'
alias gds='git df --stat'  # displays diff but files only
alias gdv='git show --word-diff=color '
alias gdvl='git show '
alias gdvs='git show --stat '
# File operations (gf)
alias gfc='git ls-files | wc '
alias gfm='git mv '
alias gfl='git ls-files | less -FRXm '
alias gfr='git rm '
# Log (gl)
alias glc='git log --pretty=%H | head -n +1'
alias glf='git reflog '
alias glh=git_log_hours 
alias gll='git log '
alias glp='git log --patch '
alias gls='git log --stat '
# Repository (gp)
alias gpa='git remote add '
alias gpd='git pull'
alias gpf='git fetch '
alias gpfp='git fetch --prune '
alias gpl='git remote --verbose'
alias gpm='git merge origin/$(git_parse_branch)'
alias gpr='git pull --rebase'
alias gpu='git push'
# Stash (gs)
alias gsl='git stash list'
alias gso='git stash pop'
alias gsp='git stash save --patch'  # git stash by chunks of file
alias gsr!='git stash drop'
alias gss='git stash save'
alias gsw='git stash show -u'  # displays diff of stash
alias gsws='git stash show '
