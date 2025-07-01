cmake_minimum_required(VERSION 3.10)
project(LibraryManagement VERSION 1.0.0 LANGUAGES C)

# Set C standard
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Compiler flags
if(MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W4")
else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -O2")
endif()

# Source files
set(SOURCES
    main.c
    book_operations.c
    user_management.c
    borrowing.c
    utilities.c
    config.c
    reports.c
)

# Headers
set(HEADERS
    library.h
)

# Create executable
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

# Link libraries
if(WIN32)
    target_link_libraries(${PROJECT_NAME} ws2_32)
endif()

# Set output name
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "library_mgmt")

# Installation
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    COMPONENT Runtime
)

# Install configuration files
install(FILES configs/library.conf.default
    DESTINATION etc/${PROJECT_NAME}
    RENAME library.conf
    COMPONENT Configuration
)

# Install documentation
install(FILES README.md LICENSE
    DESTINATION share/doc/${PROJECT_NAME}
    COMPONENT Documentation
)

# Create desktop entry for Linux
if(UNIX AND NOT APPLE)
    install(FILES packaging/library_mgmt.desktop
        DESTINATION share/applications
        COMPONENT Desktop
    )
endif()

# CPack configuration for creating installers
include(InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
set(CPACK_PACKAGE_CONTACT "developer@library-mgmt.com")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Professional Library Management System")
set(CPACK_PACKAGE_DESCRIPTION "A complete library management system with user authentication, book management, and reporting capabilities.")

# Windows installer
if(WIN32)
    set(CPACK_GENERATOR "NSIS")
    set(CPACK_NSIS_DISPLAY_NAME "Library Management System")
    set(CPACK_NSIS_PACKAGE_NAME "LibraryManagement")
    set(CPACK_NSIS_CONTACT "support@library-mgmt.com")
    set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/yourusername/library-management")
    set(CPACK_NSIS_MODIFY_PATH ON)
    set(CPACK_NSIS_CREATE_ICONS_EXTRA
        "CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Library Management.lnk' '$INSTDIR\\\\bin\\\\library_mgmt.exe'"
    )
    set(CPACK_NSIS_DELETE_ICONS_EXTRA
        "Delete '$SMPROGRAMS\\\\$START_MENU\\\\Library Management.lnk'"
    )
endif()

# Linux packages
if(UNIX AND NOT APPLE)
    set(CPACK_GENERATOR "DEB;RPM")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Library Management Team")
    set(CPACK_DEBIAN_PACKAGE_SECTION "office")
    set(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
    set(CPACK_RPM_PACKAGE_GROUP "Applications/Office")
    set(CPACK_RPM_PACKAGE_LICENSE "MIT")
endif()

include(CPack)
