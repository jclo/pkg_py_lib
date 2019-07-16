# ******************************************************************************
# Short description
#
# Long description ...
#
# ???
#
# @namespace    mobilabs.py_lib
# @author       <author_name>
# @since        0.0.0
# @version      0.0.0
# @template     pkg_pylib v@@version@@
# @licence      @@license@@
# ******************************************************************************
from setuptools import setup, find_packages


def readme():
    with open('README.md') as f:
        return f.read()


def license():
    with open('LICENSE.md') as f:
        return f.read()


setup(
    # The name of your python module with the prefix 'mobilabs_'.
    name='mobilabs_py_lib',

    version='0.0.0a0',
    description='This is an example of a Python Package under mobilabs',
    long_description=readme(),
    long_description_content_type="text/markdown",
    license=license(),
    keywords='key1 key2 key3',

    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],

    author='<author_name>',
    author_email='<author_email>',
    url='',

    scripts=['bin/py_lib'],

    packages=find_packages(),
    install_requires=[
        'markdown',
    ],
    include_package_data=True,

    # Sometimes you want to install packages that aren't installed on PyPi.
    # In those cases, you can specify a list of one or more dependency_links
    # URLs where the package can be downloaded.
    # For example, if a library is published on GitHub, you can specify it
    # like:
    # dependency_links=['http://github.com/user/repo/tarball/master#egg=package-1.0']

    test_suite='nose.collector',
    tests_require=['nose'],

    zip_safe=False,
)
