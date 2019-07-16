# PKG_PY_LIB

`pkg_py_lib` is a boilerplate for creating Python packages with a top level namespace. This boilerplate is inspired from the example [here](https://python-packaging.readthedocs.io/en/latest/minimal.html#picking-a-name).

This Python module is attached to the top level namespace `top_level_namespace` that relates to the code ownership `top_level_namespace`.

If you want more details on how to define a Python package with a top level
namespace, you should refer here:

  * https://packaging.python.org/guides/packaging-namespace-packages/
  * https://github.com/pypa/sample-namespace-packages/tree/master/pkgutil


## How to create it

You have to create a project folder, clone `pkg_py_lib` in this folder and then run the script `createpkg.sh`.

Type the following commands in a shell terminal:

```bash
mkdir <my_project_folder>
cd <my_project_folder>
git clone https://github.com/jclo/pkg_py_lib.git
./pkg_py_lib/createpkg -t <top_level_namespace> -n <name_of_your_package>
```

The script `createpkg` populates your project folder. You can then delete the folder `pkg_py_lib`.


## Structure

Now, `<your_project_folder>` contains:

```bash
<your_project_folder>
  |
  |_ bin
  |   |_ <script>           # Python, Bash or else scripts running in a shell,
  |
  |_ <top_level_namespace>
  |   |_ __init__.py        # do not modify this file,
  |   |_ <name_of_your_package>
  |       |_ util
  |       |   |_ __init__.py    # an empty __init__.py file,
  |       |   |_ main.py        # an example of subfile,
  |       |_ __init__.py        # an example of __init__.py referencing main.py,
  |       |_ main.py            # the entry point of your package,
  |
  |_ tests
  |   |_ test_1.py          # an unitary test program,
  |
  |_ .gitignore             # files to exclude from git,
  |_ add_venv.sh            # a script to create a Virtual Environment,
  |_ cleanup.sh             # a script to remove *.pyc, __py_cache__ and build
  |                         # directories,
  |
  |_ CHANGELOG.md           # an empty changelog file,
  |_ LICENCE.md             # the license of your package (default MIT),
  |_ MANIFEST.in            # the manifest template,
  |_ README_BUILD_TEST.md   # a README describing how to create a Virtual
  |                         # environment, build and test your package,
  |_ README.md              # your README file,
  |_ setup.py               # the default setup.py file,  

```

That's all!
