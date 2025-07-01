!define APP_NAME "LibraryManagement"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "LibraryTech Solutions"
!define APP_EXECUTABLE "library_management.exe"

Name "${APP_NAME}"
OutFile "${APP_NAME}_Setup.exe"
InstallDir "$PROGRAMFILES\${APP_NAME}"
RequestExecutionLevel admin

Section "Install"
    SetOutPath "$INSTDIR"
    
    # Copy main executable
    File "..\target\release\${APP_EXECUTABLE}"
    
    # Create data directory
    CreateDirectory "$INSTDIR\data"
    
    # Create shortcuts
    CreateShortcut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXECUTABLE}"
    CreateDirectory "$SMPROGRAMS\${APP_NAME}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXECUTABLE}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
    
    # Write uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    # Registry entries
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
    Delete "$INSTDIR\${APP_EXECUTABLE}"
    Delete "$INSTDIR\uninstall.exe"
    RMDir /r "$INSTDIR\data"
    RMDir "$INSTDIR"
    
    Delete "$DESKTOP\${APP_NAME}.lnk"
    RMDir /r "$SMPROGRAMS\${APP_NAME}"
    
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd
