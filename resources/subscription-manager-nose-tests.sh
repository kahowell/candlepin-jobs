# needs xorg-x11-server-Xvfb rpm installed
# needs python-rhsm

# "make jenkins" will install these via `pip install -r test-requirements.txt'
#  if it can
#  (either user pip config, or virtualenvs)
# needs python-nose installed
# needs polib installed, http://pypi.python.org/pypi/polib
# probably will need coverage tools installed
# needs mock  (easy_install mock)
# needs PyXML installed
# needs pyflakes insalled
# if we haven't installed/ran subsctiption-manager (or installed it)
#   we need to make /etc/pki/product and /etc/pki/entitlement

echo "sha1:" "${sha1}"

cd $WORKSPACE

virtualenv env --system-site-packages || true
source env/bin/activate

# build a copy of python-rhsm from master
mkdir python_rhsm_build
cd python_rhsm_build

git clone git://github.com/candlepin/python-rhsm.git

# build/test python-rhsm
pushd $WORKSPACE/python_rhsm_build/python-rhsm
PYTHON_RHSM=$(pwd)

# build the c modules
python setup.py build
python setup.py build_ext --inplace

# not using "setup.py nosetests" yet
# since they need a running candlepin
# yeah, kind of ugly...
cp build/lib.linux-*/rhsm/_certificate.so src/rhsm/

pushd $WORKSPACE
export PYTHONPATH="$PYTHON_RHSM"/src

echo
echo "PYTHONPATH=$PYTHONPATH"
echo "PATH=$PATH"
echo


make install-pip-requirements
make build
make coverage