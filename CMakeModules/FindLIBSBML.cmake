# Locate libsbml
# This module defines:
# LIBSBML_INCLUDE_DIR, where to find the headers
#
# LIBSBML_LIBRARY, LIBSBML_LIBRARY_DEBUG
# LIBSBML_FOUND, LIBSBML_LIBRARY_NAME


if(UNIX OR CYGWIN OR MINGW)
  set(LIBSBML_LIBRARY_NAME sbml)
else()
  set(LIBSBML_LIBRARY_NAME libsbml)
endif()

if (NOT LIBSBML_SHARED)
  set(LIBSBML_LIBRARY_NAME "${LIBSBML_LIBRARY_NAME}-static")
endif()

message (STATUS "Looking for ${LIBSBML_LIBRARY_NAME}")

find_package(${LIBSBML_LIBRARY_NAME} CONFIG QUIET)
message (STATUS "${${LIBSBML_LIBRARY_NAME}_FOUND}")

if (NOT ${LIBSBML_LIBRARY_NAME}_FOUND)
  find_package(${LIBSBML_LIBRARY_NAME} CONFIG QUIET
    PATHS /usr/lib/cmake
          /usr/local/lib/cmake
          /opt/lib/cmake
          /opt/local/lib/cmake
          /sw/lib/cmake
          ${CONAN_LIB_DIRS_LIBSBML}
          ${CONAN_LIB_DIRS_LIBSBML}/cmake
          ${CONAN_LIB_DIRS_LIBSBML}/lib/cmake
  )
endif()

if (${LIBSBML_LIBRARY_NAME}_FOUND)

  get_target_property(LIBSBML_LIBRARY ${LIBSBML_LIBRARY_NAME} LOCATION)
  get_filename_component(LIB_PATH ${LIBSBML_LIBRARY} DIRECTORY)
  file(TO_CMAKE_PATH ${LIB_PATH}/../include LIBSBML_INCLUDE_DIR)  
  get_filename_component (LIBSBML_INCLUDE_DIR ${LIBSBML_INCLUDE_DIR} REALPATH)
  get_target_property(LIBSBML_VERSION ${LIBSBML_LIBRARY_NAME} VERSION)
  get_target_property(LIBSBML_INTERFACE_LINK_LIBRARIES ${LIBSBML_LIBRARY_NAME} INTERFACE_LINK_LIBRARIES)

  if (NOT LIBSBML_INTERFACE_LINK_LIBRARIES)
  get_target_property(LIBSBML_INTERFACE_LINK_LIBRARIES ${LIBSBML_LIBRARY_NAME} IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE)
  endif()

  if (LIBSBML_INTERFACE_LINK_LIBRARIES)
    set(LIBSBML_LIBRARY ${LIBSBML_LIBRARY} ${LIBSBML_INTERFACE_LINK_LIBRARIES})
  endif (LIBSBML_INTERFACE_LINK_LIBRARIES)
  

else()

find_path(LIBSBML_INCLUDE_DIR sbml/SBase.h
    PATHS $ENV{LIBSBML_DIR}/include
          $ENV{LIBSBML_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}/include
          ~/Library/Frameworks
          /Library/Frameworks
          /sw/include        # Fink
          /opt/local/include # MacPorts
          /opt/csw/include   # Blastwave
          /opt/include
          /usr/freeware/include
    NO_DEFAULT_PATH)

if (NOT LIBSBML_INCLUDE_DIR)
    find_path(LIBSBML_INCLUDE_DIR sbml/SBase.h)
endif (NOT LIBSBML_INCLUDE_DIR)


if (NOT LIBSBML_INCLUDE_DIR)
    message(FATAL_ERROR "libsbml include dir not found not found!")
endif (NOT LIBSBML_INCLUDE_DIR)


find_library(LIBSBML_LIBRARY 
    NAMES sbml-static 
          sbml
          libsbml-static 
          libsbml
    PATHS $ENV{LIBSBML_DIR}/lib
          $ENV{LIBSBML_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}/lib
          ${CONAN_LIB_DIRS_LIBSBML}
          ~/Library/Frameworks
          /Library/Frameworks
          /sw/lib        # Fink
          /opt/local/lib # MacPorts
          /opt/csw/lib   # Blastwave
          /opt/lib
          /usr/freeware/lib64
    NO_DEFAULT_PATH)

if (NOT LIBSBML_LIBRARY)
    find_library(LIBSBML_LIBRARY 
        NAMES sbml-static 
              sbml)
endif (NOT LIBSBML_LIBRARY)

if (NOT LIBSBML_LIBRARY)
    message(FATAL_ERROR "LIBSBML library not found!")
endif (NOT LIBSBML_LIBRARY)

  add_library(${LIBSBML_LIBRARY_NAME} UNKNOWN IMPORTED)
  set_target_properties(${LIBSBML_LIBRARY_NAME} PROPERTIES IMPORTED_LOCATION ${LIBSBML_LIBRARY})
  
  include(CheckLibraryExists)
  check_library_exists(ExpartParser "" HAVE_EXPAT)

endif()



set(LIBSBML_FOUND "NO")
if(LIBSBML_LIBRARY)
    if (LIBSBML_INCLUDE_DIR)
        SET(LIBSBML_FOUND "YES")
    endif(LIBSBML_INCLUDE_DIR)
endif(LIBSBML_LIBRARY)

# handle the QUIETLY and REQUIRED arguments and set LIBSBML_FOUND to TRUE if 
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBSBML DEFAULT_MSG LIBSBML_LIBRARY_NAME LIBSBML_LIBRARY LIBSBML_INCLUDE_DIR)

mark_as_advanced(LIBSBML_INCLUDE_DIR LIBSBML_LIBRARY LIBSBML_LIBRARY_NAME)

