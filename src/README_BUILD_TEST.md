# README BUILD

This README explains how to create a Virtual Environment to build and test your package.

The script `configure.sh` does this automatically.


## Virtual Environment

### Create

A virtual environment is a way to create an isolated space so you can, for example, run Python 2.7 for one project and Python 3.7 for another on the same computer.

This isolated space will contain the package required by your project.

First, you need to create a folder:

```bash
python3 -m venv ./myvenv
```


### Activate

You have to activate this virtual environment by typing the following command:

```bash
source ./myvenv/bin/activate
```

Now, the Python's packages you install will only be available within this virtual environment.

Nota:
The shell prompt starts with `(myenv)`.


### Deactivate

When you leave your project, you need to deactivate the Virtual Environment. Type the following command:

```
deactivate
```

`(myenv)` disappears from the prompt shell.


## Install your package

When your Virtual Environment is active, type the following command in a shell window:

```bash
pip install .
```

The module will be installed in your Virtual Environment.


## Run the tests

First, you need to install `nose`. If it is not done:

```bash
pip install nose
```

Then, you can launch the tests:

```bash
nosetests -v
```


That's all!
