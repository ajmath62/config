""" Define some helper methods for git hooks """

import sys


class RemapStdinToTTY:
    """ Context manager for using TTY as stdin
    
    This is particularly useful in a git hook context, because git hooks get called
    in a noninteractive environment.
    """
    
    def __enter__(self):
        # Store actual stdin so that we can put it back on context manager exit
        self.original_stdin = sys.stdin
        sys.stdin = open('/dev/tty')
    
    def __exit__(self, exc_type, exc_value, traceback):
        sys.stdin = self.original_stdin


def ignore_or_exit():
    """ Ask the user if they want to commit, and exit if not """
    with RemapStdinToTTY():
        if not input('Ignore and commit anyways? (y/n) ').lower().startswith('y'):
            exit(1)


PRINT_STATEMENTS = ('print', 'puts', 'console')
