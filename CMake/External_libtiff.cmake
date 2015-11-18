# libtiff External project

# We need -fPIC when building statically
if( UNIX AND NOT BUILD_SHARED_LIBS)
  set (CMAKE_POSITION_INDEPENDENT_CODE TRUE)
endif()

# JPEG
add_package_dependency(
  PACKAGE libtiff
  PACKAGE_DEPENDENCY libjpeg-turbo
  PACKAGE_DEPENDENCY_ALIAS JPEG
)

# ZLIB
add_package_dependency(
  PACKAGE libtiff
  PACKAGE_DEPENDENCY ZLib
  PACKAGE_DEPENDENCY_ALIAS ZLIB
)

set(libtiff_ARGS
    -Djpeg:BOOL=${libtiff_WITH_libjpeg-turbo}
    -Dzlib:BOOL=${libtiff_WITH_ZLib}
)

# If add_package_dependency went looking for JPEG JPEG_FOUND 
# would be set as would JPEG_INCLUDE_DIR and JPEG_LIBRARY. 
# Otherwise, it's using FLETCH:
if(NOT JPEG_FOUND)
    set(JPEG_INCLUDE_DIR ${fletch_BUILD_INSTALL_PREFIX}/include)
    set(JPEG_LIBRARY ${fletch_BUILD_INSTALL_PREFIX}/lib/jpeg.lib)
endif()
set(libtiff_JPEG_ARGS
    -DJPEG_INCLUDE_DIR:PATH=${JPEG_INCLUDE_DIR}
    -DJPEG_LIBRARY:FILE=${JPEG_LIBRARY}
    )

# Ibid, but for Zlib
if(NOT ZLIB_FOUND)
    set(ZLIB_INCLUDE_DIR ${fletch_BUILD_INSTALL_PREFIX}/include)
    set(ZLIB_LIBRARY ${fletch_BUILD_INSTALL_PREFIX}/lib/zlib.lib)
endif()
set(libtiff_ZLIB_ARGS
    -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INCLUDE_DIR}
    -DZLIB_DEBUG_LIBRARY:PATH=${ZLIB_LIBRARY}
    -DZLIB_RELASE_LIBRARY:PATH=${ZLIB_LIBRARY}
    )


ExternalProject_Add(libtiff
    DEPENDS ${libtiff_DEPENDS}
    URL ${libtiff_url}
    URL_MD5 ${libtiff_md5}
    PREFIX ${fletch_BUILD_PREFIX}
    DOWNLOAD_DIR ${fletch_DOWNLOAD_DIR}
    DOWNLOAD_COMMAND ${libtiff_download_command}
    INSTALL_DIR ${fletch_BUILD_INSTALL_PREFIX}
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
      -DCMAKE_C_FLAGS=${CMAKE_CXX_FLAGS}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      -DCMAKE_INSTALL_PREFIX:PATH=${fletch_BUILD_INSTALL_PREFIX}
        ${libtiff_ARGS}
        ${libtiff_JPEG_ARGS}
        ${libtiff_ZLIB_ARGS}
)


set(libtiff_ROOT "${fletch_BUILD_INSTALL_PREFIX}" CACHE PATH "" FORCE)
file(APPEND ${fletch_CONFIG_INPUT} "
################################
# libtiff
################################
set(libtiff_ROOT @libtiff_ROOT@)

set(fletch_ENABLED_libtiff TRUE)
")
