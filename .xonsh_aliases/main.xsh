def _random_cow():
    return $(ls /usr/share/cowsay/cows | shuf -n1).rstrip('\n')
