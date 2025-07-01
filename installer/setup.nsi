!define APP_NAME "LibraryManagement"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "LibraryTech Solutions"
!define APP_EXECUTABLE "library_management.exe"
!define APP_DISPLAY_NAME "Library Management System"

Name "${APP_DISPLAY_NAME}"
OutFile "${APP_NAME}_Setup.exe"
InstallDir "$PROGRAMFILES\${APP_NAME}"
RequestExecutionLevel admin

# Modern UI
!include "MUI2.nsh"

# Interface Settings
!define MUI_ABORTWARNING

# Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

# Languages
!insertmacro MUI_LANGUAGE "English"

Section "Install"
    SetOutPath "$INSTDIR"
    
    # Show detailed progress
    DetailPrint "Installing Library Management System..."
    
    # Copy main executable (from Windows cross-compilation target)
    File "..\target\x86_64-pc-windows-gnu\release\${APP_EXECUTABLE}"
    
    # Create data directory for database
    CreateDirectory "$INSTDIR\data"
    
    # Create config directory
    CreateDirectory "$INSTDIR\config"
    
    # Create logs directory
    CreateDirectory "$INSTDIR\logs"
    
    # Copy sample configuration file if exists
    IfFileExists "..\config\app.toml" 0 +2
    File /oname=config\app.toml "..\config\app.toml"
    
    # Create default config file if none exists
    IfFileExists "$INSTDIR\config\app.toml" +5 0
    FileOpen $0 "$INSTDIR\config\app.toml" w
    FileWrite $0 "[database]$\r$\nurl = 'sqlite:data/library.db'$\r$\n[server]$\r$\nport = 8080$\r$\n"
    FileClose $0
    
    # Create shortcuts with proper working directory
    CreateShortcut "$DESKTOP\${APP_DISPLAY_NAME}.lnk" "$INSTDIR\${APP_EXECUTABLE}" "" "$INSTDIR\${APP_EXECUTABLE}" 0 SW_SHOWNORMAL "" "${APP_DISPLAY_NAME}" "$INSTDIR"
    CreateDirectory "$SMPROGRAMS\${APP_DISPLAY_NAME}"
    CreateShortcut "$SMPROGRAMS\${APP_DISPLAY_NAME}\${APP_DISPLAY_NAME}.lnk" "$INSTDIR\${APP_EXECUTABLE}" "" "$INSTDIR\${APP_EXECUTABLE}" 0 SW_SHOWNORMAL "" "${APP_DISPLAY_NAME}" "$INSTDIR"
    CreateShortcut "$SMPROGRAMS\${APP_DISPLAY_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
    
    # Write uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    # Registry entries for Add/Remove Programs
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_DISPLAY_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoRepair" 1
    
    # Estimate install size (in KB)
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "EstimatedSize" 50000
    
    # File associations (optional - for .libdb files)
    WriteRegStr HKCR ".libdb" "" "LibraryManagement.Database"
    WriteRegStr HKCR "LibraryManagement.Database" "" "Library Management Database"
    WriteRegStr HKCR "LibraryManagement.Database\DefaultIcon" "" "$INSTDIR\${APP_EXECUTABLE},0"
    WriteRegStr HKCR "LibraryManagement.Database\shell\open\command" "" '"$INSTDIR\${APP_EXECUTABLE}" "%1"'
    
    DetailPrint "Installation completed successfully!"
    
SectionEnd

Section "Uninstall"
    DetailPrint "Removing Library Management System..."
    
    # Remove executable and files
    Delete "$INSTDIR\${APP_EXECUTABLE}"
    Delete "$INSTDIR\uninstall.exe"
    
    # Remove configuration files (ask user)
    MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to remove configuration and data files?$\r$\n$\r$\nChoose 'No' to keep your library database and settings." IDNO skip_data_removal
    RMDir /r "$INSTDIR\data"
    RMDir /r "$INSTDIR\config"
    RMDir /r "$INSTDIR\logs"
    Goto continue_uninstall
    
    skip_data_removal:
    DetailPrint "Keeping user data and configuration files..."
    
    continue_uninstall:
    # Remove directories (only if empty)
    RMDir "$INSTDIR"
    
    # Remove shortcuts
    Delete "$DESKTOP\${APP_DISPLAY_NAME}.lnk"
    RMDir /r "$SMPROGRAMS\${APP_DISPLAY_NAME}"
    
    # Remove registry entries
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
    
    # Remove file associations
    DeleteRegKey HKCR ".libdb"
    DeleteRegKey HKCR "LibraryManagement.Database"
    
    DetailPrint "Uninstallation completed!"

SectionEnd
