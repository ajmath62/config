folder=$(dirname ${BASH_SOURCE})
for file in $(ls ${folder}); do  # ls ignores filenames that start with a dot, including this one
  # Source every file in the .bash_aliases folder
  if test -f ${folder}/${file}; then
    source ${folder}/${file}
  fi
done
