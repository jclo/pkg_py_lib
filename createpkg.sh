#!/bin/sh
#
# A bash script to create a Python package with a top level namespace.
#
# copyright 2019 Artelsys <contact@artelsys.com> (http://www.artelsys.com/)
#
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Global variables, default values
TOPLEVEL='mycompany'
PKGNAME='mylib'
COPYRIGHT="Copyright (c) 2019 John Doe <contact@doe.com>"
LICENSE="MIT. ${COPYRIGHT}"
SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
VERSION='0.0.0'


# --- Private Functions --------------------------------------------------------

##
# Dumps the help message.
#
function help() {
  echo ''
    echo 'Usage: -t <top level namespace> -n <name of the package>'
    echo ''
}


##
# Checks if the current folder is empty (except pkg_py_lib).
#
function isFolderEmpty() {
  LIST=0
  for entry in `ls`; do
    # echo $entry
    ((LIST+=1))
  done

  if [ ${LIST} -ne 1 ]
    then
      echo 'Your folder is not empty! Process aborted ...'
      exit 1
  fi
}


##
# Creates the package and copies the skeleton.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the copyright string
#
function createpkg() {
  toplevel=$1
  pkgname=$2
  src=$3
  copyright=$4

  # Fill it:
  cp ${src}/src/README.md .
  cp ${src}/src/README_BUILD_TEST.md .
  cp ${src}/MANIFEST.in .
  sed 's/@@copyright@@/'"${copyright}"'/' ${src}/src/LICENSE.md > ./LICENSE.md
  cp ${src}/src/CHANGELOG.md .

  cp ${src}/cleanup.sh .
  chmod +x cleanup.sh
  cp ${src}/add_venv.sh .
  chmod +x add_venv.sh

  cp ${src}/src/gitignore .gitignore
}


##
# Copies setup.py.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the license string
#
function cpsetupy() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4
  version=$5

  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' \
      -e 's/@@version@@/'"${version}"'/' ${src}/setup.py > ./setup.py
}


##
# Copies the scripts.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the license string
#
function cpscript() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4

  mkdir -p bin
  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' ${src}/bin/py_lib > ./bin/${pkgname}
}


##
# Copies the test files.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the license string
#
function cptests() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4

  mkdir -p tests
  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' ${src}/tests/test_1.py > ./tests/test_1.py
}


##
# Creates the Python module.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the license string
#
function createpym() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4

  # Create the top level folder:
  mkdir -p ${toplevel}
  cp ${src}/mobilabs/__init__.py ./${toplevel}/.

  # Create the module
  mkdir -p ${toplevel}/${pkgname}

  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs.py_lib/'"${toplevel}.${pkgname}"'/' \
      ${src}/mobilabs/py_lib/__init__.py > ./${toplevel}/${pkgname}/__init__.py

  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' \
      ${src}/mobilabs/py_lib/main.py > ./${toplevel}/${pkgname}/main.py


  # Create the submodule
  mkdir -p ${toplevel}/${pkgname}/util

  touch ${toplevel}/${pkgname}/util/__init__.py
  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs.py_lib/'"${toplevel}.${pkgname}"'/' \
      ${src}/mobilabs/py_lib/util/main.py > ./${toplevel}/${pkgname}/util/main.py
}



# --- Main program -------------------------------------------------------------

# Collect the passed in options:
while getopts "ht:n:" opt; do
  case ${opt} in

    h ) help
        exit 1
      ;;

    t ) TOPLEVEL=$(echo ${OPTARG} | tr '[:upper:]' '[:lower:]')
        ;;

    n ) PKGNAME=$(echo ${OPTARG} | tr '[:upper:]' '[:lower:]')
        ;;

    : ) echo "Option -$OPTARG requires an argument" >&2
        help
        exit 1
        ;;

  esac
done


# Check if the options are passsed:
if [[ $OPTIND -eq 1 ]]
  then echo 'You have to pass options!'
  help
  exit 1
fi

# Is directory empty?
isFolderEmpty

# Create the package and copy the skeleton:
createpkg ${TOPLEVEL} ${PKGNAME} ${SRC} "${COPYRIGHT}"
cpsetupy ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICENSE}" ${VERSION}

# Copy script and test files:
cpscript ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICENSE}"
cptests ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICENSE}"

# Create the Python module:
createpym ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICENSE}"

# end
