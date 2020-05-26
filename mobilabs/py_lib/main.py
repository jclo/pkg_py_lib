# ******************************************************************************
"""
Short description.

Long description ...

Public Functions:
    . get_name                      returns the name of the libray,


@namespace      mobilabs.py_lib
@author         <author_name>
@since          0.0.0
@version        0.0.0
@licence        @@license@@
"""
# ******************************************************************************
from . util.main import get


def get_name():
    """Return a string.

    ### Parameters:
        param1 (str):       bla bla ...
        param2 (str):       bla bla ...

    ### Returns:
        (str):              bla bla ...

    Raises:
        IOError:            bla bla ...

    """
    return 'My name is py_lib' + get()
