folder = $(dirname @(__file__)).rstrip()
for file in $(ls @(folder)).split('\n'):  # ls ignores filenames that start with a dot, including this one
    # Source every file in the .xonsh_aliases folder
    full_file = folder + '/' + file
    if !(test -f @(full_file)):
        ![source @(full_file)]
