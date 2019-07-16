# ******************************************************************************
# Short description
#
# Long description ...
#
# Public Functions:
#   . get_name                      returns the name of the libray,
#
#
# @namespace    mobilabs.py_lib
# @author       <author_name>
# @since        0.0.0
# @version      0.0.0
# @license      @@license@@
# ******************************************************************************
from . util.main import get


def get_name():
    """Returns a string.

    Parameters:
        arg1 (str): bla bla.
        arg2 (str): bla bla.

    Returns:
        (str): Bla bla ...

    Raises:
        IOError: bla bla.
    """
    return 'My name is py_lib' + get()
