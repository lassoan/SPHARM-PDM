
# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Set dependency list
set(BatchMake_DEPENDENCIES ${ITK_EXTERNAL_NAME})

# Include dependent projects if any
set(proj BatchMake)

# Set CMake OSX variable to pass down the external project
set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
if(APPLE)
  list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
    -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
endif()

#message(STATUS "${__indent}Adding project ${proj}")
ExternalProject_Add(${proj}
  GIT_REPOSITORY "${git_protocol}://batchmake.org/BatchMake.git"
  GIT_TAG "origin/master"
  SOURCE_DIR BatchMake
  BINARY_DIR BatchMake-build
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${ep_common_flags}
    ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DUSE_FLTK:BOOL=OFF
    -DDASHBOARD_SUPPORT:BOOL=OFF
    -DGRID_SUPPORT:BOOL=ON
    -DUSE_SPLASHSCREEN:BOOL=OFF
    -DITK_DIR:PATH=${ITK_DIR}
  INSTALL_COMMAND ""
  DEPENDS
    ${BatchMake_DEPENDENCIES}
  )
# ExternalProject_Add_Step(${proj} fix_itk_libs
#   COMMENT "Get Rid of individual ITK Libs in favor of ITK_LIBRARIES"
#   DEPENDEES download
#   DEPENDERS configure
#   DEPENDS ${CMAKE_CURRENT_LIST_DIR}/BatchMake.patch
#   WORKING_DIRECTORY <SOURCE_DIR>
#   COMMAND patch -p1 "--input=${CMAKE_CURRENT_LIST_DIR}/BatchMake.patch"
# )
set(BatchMake_DIR ${CMAKE_BINARY_DIR}/BatchMake-build)
