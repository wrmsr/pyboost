python_add_module(iterators iterators.cc)
file(COPY test_iterators.py DESTINATION .)
add_test(NAME iterators COMMAND ${PYTHON_EXECUTABLE} test_iterators.py)

