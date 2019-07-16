# ******************************************************************************
# Short description
#
# Long description ...
#
# ???:
#
#
# @namespace    mobilabs.py_lib
# @author       <author_name>
# @since        0.0.0
# @version      0.0.0
# @licence      @@license@@
# ******************************************************************************
import unittest
import mobilabs.py_lib


class MyTest(unittest.TestCase):
    """Class docstrings go here."""

    def test_is_string(self):
        """ Tests if the function returns a string."""
        s = mobilabs.py_lib.get_name()
        self.assertTrue(isinstance(s, str))
