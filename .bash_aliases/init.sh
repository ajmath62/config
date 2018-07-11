folder=$(dirname ${BASH_SOURCE})
for file in $(ls ${folder}); do
  # Skip this file to avoid recursion
  if test ${file} == 'init.sh'; then continue; fi
  
  # Source every file in the .bash_aliases folder
  if test -f ${folder}/${file}; then
    source ${folder}/${file}
  fi
done
