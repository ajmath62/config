""" Define some helper methods for git hooks """
import subprocess
import sys

import six


class PY34CompletedProcess:
    """ Mock object that behaves similarly to Python 3.5+ subprocess.CompletedProcess """
    def __init__(self, returncode=None, stdout=None):
        self.returncode = returncode
        self.stdout = stdout


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


def subprocess_run(*args, **kwargs):
    """ Function that works similarly to Python 3.5+ subprocess.run
    
    It is not a perfect mapping, but it can be extended as needed
    """
    if six.PY34:
        if kwargs.pop('check', False):
            if kwargs.pop('stdout', None) == subprocess.PIPE:
                stdout = subprocess.check_output(*args, **kwargs)
                return PY34CompletedProcess(stdout=stdout)
            else:
                returncode = subprocess.check_call(*args, **kwargs)
                return PY34CompletedProcess(returncode=returncode)
        else:
            returncode = subprocess.call(*args, **kwargs)
            return PY34CompletedProcess(returncode=returncode)
    else:
        return subprocess.run(*args, **kwargs)


PRINT_STATEMENTS = ('print', 'puts', 'console')
