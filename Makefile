# https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2

SHELL:=/bin/bash

BOOST_VERSION:=1_72_0

all: test


.PHONY: clean
clean:
	rm -rf .boost
	rm -rf .venv
	rm -rf boost_$(BOOST_VERSION)
	rm -rf build

.PHONY: venv
venv:
	if [ ! -d .venv ] ; then \
		virtualenv -p ~/.pyenv/versions/3.8.2/bin/python .venv ; \
	fi

.PHONY: boost
boost: venv
	CWD=$(shell pwd) ; \
	\
	if [ ! -d .boost ] ; then \
		if [ ! -d boost_$(BOOST_VERSION) ] ; then \
			tar xvjf boost_$(BOOST_VERSION).tar.bz2 ; \
		fi ; \
		\
		if [ ! -f boost_$(BOOST_VERSION)/project-config.jam ] ; then \
			(cd boost_$(BOOST_VERSION) && ./bootstrap.sh \
				--with-python=$$CWD/.venv/bin/python \
				--prefix=$$CWD/.boost \
				--exec-prefix=$$CWD/.boost/bin \
				--libdir=$$CWD/.boost/lib \
				--includedir=$$CWD/.boost/include \
				--with-libraries=python \
			); \
		fi ; \
		\
		(cd boost_$(BOOST_VERSION) && ./b2 install) ; \
	fi

.PHONY: cmake
cmake: boost
	CWD=$(shell pwd) ; \
	\
	if [ ! -d build ] ; then \
		mkdir build ; \
		\
		(. .venv/bin/activate && cd build && \
			BOOST_ROOT=$$CWD/.boost \
			cmake .. \
			-DPYTHON_LIBRARY=$$CWD/.venv/lib \
			-DPYTHON_INCLUDE_DIR=$$CWD/.venv/include/python3.8 \
		); \
	fi

.PHONY: build
build: cmake
	(cd build && VERBOSE=1 make -j8)


.PHONY: test
test: build
	(cd build/iterators && ../../.venv/bin/python test_iterators.py)