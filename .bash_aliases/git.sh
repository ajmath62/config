# Git functions
function git_store_old {
    _OLD_BRANCH=$(git_parse_branch)
}
function git_checkout_old {
    temp=$_OLD_BRANCH
    git_store_old
    git checkout $temp
}
function git_merge_old {
    git merge $_OLD_BRANCH
}
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

# Git aliases
# gb = branch, gc = commit, gd = diff, gp = repository, gs = stash
alias gb-c='git_store_old && git checkout'
alias gb-cd='gb-c development'
alias gb-cm='gb-c master'
alias gb-co='git_checkout_old'
alias gb-cp='gb-c production'
alias gb-cs='gb-c stable'
alias gb-l='git branch'
alias gb-la='git branch -a'
alias gb-n='ev "git checkout -b" "git push -u origin"'
alias gb-rr!='git branch -d'
alias gc-a='git add'
alias gc-am='git add */migrations 2> /dev/null || git add */*/migrations'  # add grandchild or great-grandchild migration directories
alias gc-c='git commit '
alias gc-ca='git commit --amend '
alias gc-h='git reset HEAD'
alias gc-hh='git checkout -- '
alias gc-m='git merge'
alias gc-md='git merge development'
alias gc-mm='git merge master'
alias gc-mo='git_merge_old'
alias gc-p='git add --patch'  # git add by chunks of file
alias gc-q='git_diff_add'
alias gc-r='git rebase '
alias gc-rc='git rebase --continue '
alias gc-rm='git rebase master '
alias gc-rr!='git rm'
alias gd-c='git df --cached'  # displays diff of staged changes
alias gd-d='git df '  # word diff
alias gd-f='git status'
alias gd-fu='git status -uno'
alias gd-i=git_is_child
alias gd-l='git diff '  # line diff
alias gd-o='gd-d master origin/master'
alias gd-os='gd-s master origin/master'
alias gd-s='git df --stat'  # displays diff but files only
alias gd-v='git show --word-diff=color '
alias gd-vl='git show '
alias gd-vs='git show --stat '
alias gp-d='git pull'
alias gp-f='git fetch'
alias gp-r='git pull --rebase'
alias gp-u='git push'
alias gs-l='git stash list'
alias gs-o='git stash pop'
alias gs-p='git stash save --patch'  # git stash by chunks of file
alias gs-rr!='git stash drop'
alias gs-s='git stash save'
alias gs-w='git stash show -u'  # displays diff of stash
alias gs-ws='git stash show '
