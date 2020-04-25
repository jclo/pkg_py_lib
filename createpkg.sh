#!/bin/sh
#
# A bash script to create a Python package with a top level namespace.
#
# copyright 2020 Artelsys <contact@artelsys.com> (http://www.artelsys.com/)
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

# (must not be changed)
SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get the global variables from 'config.sh' file
# These global variables are:
#  TOPLEVEL='...'
#  PKGNAME='...'
#  COPYRIGHT="..."
#  LICENSE="..."
#  AUTHOR='...'
#  AUTHOR_EMAIL='...'
source ${SRC}/config.sh
LICOP="${LICENSE}. ${COPYRIGHT}"


# --- Private Functions --------------------------------------------------------

##
# Dumps the help message.
#
function help() {
  echo ''
    echo 'Usage: -t <top level namespace> -n <name of the package>'
    echo ''
    echo '-t  top level namespace. Default is mycompany,'
    echo '-n  the name of the package. Default is mylib,'
    echo '-c  the copyright. Default is Copyright (c) 2020 John Doe <contact@doe.com>,'
    echo '-a  the author. Default is John Doe,'
    echo '-e  the email address of the author. Default is contact@doe.com,'
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

  if [[ ${LIST} -gt 1 ]]
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
  cp ${src}/src/README_JUPYTER.md .
  mkdir -p img
  cp ${src}/src/img/kernel.png ./img/.
  cp ${src}/src/README_BUILD_TEST.md .
  cp ${src}/MANIFEST.in .
  sed 's/@@copyright@@/'"${copyright}"'/' ${src}/src/LICENSE.md > ./LICENSE.md
  cp ${src}/src/CHANGELOG.md .

  cp ${src}/cleanup.sh .
  chmod +x cleanup.sh
  cp ${src}/src/configure.sh .
  chmod +x configure.sh

  mkdir -p scripts
  cp ${src}/src/scripts/* ./scripts/.

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
#   arg5 (string): the version of the template
#   arg6 (string): the name of the author
#   arg7 (string): the email address of the author
#
function cpsetupy() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4
  version=$5
  author=$6
  email=$7

  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' \
      -e 's/@@version@@/'"${version}"'/' \
      -e 's/<author_name>/'"${author}"'/' \
      -e 's/<author_email>/'"${email}"'/' ${src}/setup.py > ./setup.py
}


##
# Copies the scripts.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the license string
#   arg5 (string): the name of the author
#
function cpscript() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4
  author=$5

  mkdir -p bin
  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' \
      -e 's/<author_name>/'"${author}"'/' ${src}/bin/py_lib > ./bin/${pkgname}
}


##
# Copies the test files.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the license string
#   arg5 (string): the name of the author
#
function cptests() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4
  author=$5

  mkdir -p tests
  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' \
      -e 's/<author_name>/'"${author}"'/' ${src}/tests/test_1.py > ./tests/test_1.py
}


##
# Creates the Python module.
#
# Arguments:
#   arg1 (string): the top level namespace
#   arg2 (string): the name of the package
#   arg3 (string): the source path
#   arg4 (string): the license string
#   arg5 (string): the name of the author
#
function createpym() {
  toplevel=$1
  pkgname=$2
  src=$3
  license=$4
  author=$5

  # Create the top level folder:
  mkdir -p ${toplevel}
  cp ${src}/mobilabs/__init__.py ./${toplevel}/.

  # Create the module
  mkdir -p ${toplevel}/${pkgname}

  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/<author_name>/'"${author}"'/' \
      -e 's/mobilabs.py_lib/'"${toplevel}.${pkgname}"'/' \
      ${src}/mobilabs/py_lib/__init__.py > ./${toplevel}/${pkgname}/__init__.py

  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/<author_name>/'"${author}"'/' \
      -e 's/mobilabs/'"${toplevel}"'/' \
      -e 's/py_lib/'"${pkgname}"'/' \
      ${src}/mobilabs/py_lib/main.py > ./${toplevel}/${pkgname}/main.py


  # Create the submodule
  mkdir -p ${toplevel}/${pkgname}/util

  touch ${toplevel}/${pkgname}/util/__init__.py
  sed -e 's/@@license@@/'"${license}"'/' \
      -e 's/<author_name>/'"${author}"'/' \
      -e 's/mobilabs.py_lib/'"${toplevel}.${pkgname}"'/' \
      ${src}/mobilabs/py_lib/util/main.py > ./${toplevel}/${pkgname}/util/main.py
}



# --- Main program -------------------------------------------------------------

# Collect the passed in options:
while getopts "ht:n:c:a:e:" opt; do
  case ${opt} in

    h ) help
        exit 1
      ;;

    t ) TOPLEVEL=$(echo ${OPTARG} | tr '[:upper:]' '[:lower:]')
        ;;

    n ) PKGNAME=$(echo ${OPTARG} | tr '[:upper:]' '[:lower:]')
        ;;

    c ) COPYRIGHT=${OPTARG}
        LICOP="${LICENSE}. ${COPYRIGHT}"
        ;;

    a ) AUTHOR=${OPTARG}
        ;;

    e ) AUTHOR_EMAIL=${OPTARG}
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
echo 'Create the project skeleton ...'
createpkg ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICOP}"
cpsetupy ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICOP}" ${VERSION} "${AUTHOR}" "${AUTHOR_EMAIL}"

# Copy script and test files:
echo 'Copy the scripts ...'
cpscript ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICOP}" "${AUTHOR}"
echo 'Copy the test files ...'
cptests ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICOP}" "${AUTHOR}"

# Create the Python module:
echo "Create the Python package ${TOPLEVEL}.${PKGNAME} ..."
createpym ${TOPLEVEL} ${PKGNAME} ${SRC} "${LICOP}" "${AUTHOR}"

echo 'Done!'
echo ''
echo 'Read the file README_BUILD_TEST.md to understand how to build and test the created Python package.'
echo ''

# end
