cmake_minimum_required(VERSION 2.8.3)

add_definitions(-DBOOST_PYTHON_STATIC_LIB)

# set(Boost_USE_STATIC_LIBS        ON)
# set(Boost_USE_MULTITHREADED      ON)
# set(Boost_USE_STATIC_RUNTIME    OFF)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(PythonInterp)

message(STATUS "PYTHON_VERSION_SUFFIX = ${PYTHON_VERSION_SUFFIX}")
message(STATUS "PYTHON_VERSION_MAJOR = ${PYTHON_VERSION_MAJOR}")
message(STATUS "PYTHON_VERSION_MINOR = ${PYTHON_VERSION_MINOR}")

if (PYTHONINTERP_FOUND)
  if (UNIX AND NOT APPLE)
    find_package(Boost COMPONENTS python${PYTHON_VERSION_SUFFIX})
    find_package(PythonInterp 3)
    find_package(PythonLibs 3 REQUIRED)
  else()	
    find_package(Boost COMPONENTS python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR})
    find_package(PythonInterp 3)
    find_package(PythonLibs 3 REQUIRED)
  endif()
else()
    message("Python not found")
endif()

message(STATUS "PYTHON_LIBRARIES = ${PYTHON_LIBRARIES}")
message(STATUS "PYTHON_EXECUTABLE = ${PYTHON_EXECUTABLE}")
message(STATUS "PYTHON_INCLUDE_DIRS = ${PYTHON_INCLUDE_DIRS}")
message(STATUS "Boost_LIBRARIES = ${Boost_LIBRARIES}")

add_link_options(-undefined dynamic_lookup)
# add_link_options(-fvisibility-inlines-hidden -fvisibility=hidden)

enable_testing()

include_directories(${Boost_INCLUDE_DIRS} ${PYTHON_INCLUDE_DIRS})
link_libraries(${Boost_LIBRARIES} ${PYTHON_LIBRARIES}) # Deprecated but so convenient!

add_subdirectory(iterators)
