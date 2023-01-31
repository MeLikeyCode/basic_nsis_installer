; Creates an installer.
;
; 1) Put the folder that contains the files you want to install in the same directory as this file
; 2) Set the variables below to desired values (all paths are relative to this file)
; 3) Run this file with NSIS (`makensis build_installer.nsi` or use the NSIS GUI). 
;
; The installer will be created in the same directory as this file.
;
; Features of the resultant installer:
; - start menu shortcut
; - uninstaller (placed in same directory as installed files)
; - Add/Remove Programs entry
;
; This file is based on a template written by Joost Verburg

; Set these variables
  !define APP_TITLE "Matrix Playground" # the title that is displayed in the installer window and in the Add/Remove Programs dialog
  !define INSTALLER_EXE "install_matrix_playground.exe" # the name of the installer file
  !define ROOTDIR "dist\matrix_playground" ; root directory of the files to be installed (if using pyinstaller this is usually in dist\<some_folder>)
  !define EXE_PATH "matrix_playground.exe" ; the executable file that a shortcut will be created for in the start menu
  !define INSTALLATION_LICENSE "installation_license.txt" ; name of the file that contains the license text

; You're done. You don't need to touch the rest of the file. Run this file with NSIS to generate the installer.

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "${APP_TITLE}"
  OutFile "${INSTALLER_EXE}"
  Unicode True

  ;do not require admin to run installer
  RequestExecutionLevel user

  ;Default installation folder
  InstallDir "$LOCALAPPDATA\$(^Name)"
  
;--------------------------------
;Interface Settings

  ;if user tries to exit installation, display a popup warning/confirmation first
  !define MUI_ABORTWARNING

;--------------------------------
;Pages
  ; these are the various screens of the installation
  ; in NSIS, these screens are called pages
  ; the pages are displayed in the order they are defined

  !insertmacro MUI_PAGE_LICENSE "${INSTALLATION_LICENSE}"
  !insertmacro MUI_PAGE_DIRECTORY ; page that allows user to choose installation directory
  !insertmacro MUI_PAGE_INSTFILES ; page that shows the installation happening (i.e. the progress bar page)
  
  ; these pages are for the uninstaller
  !insertmacro MUI_UNPAGE_CONFIRM ; page that asks user to confirm uninstallation
  !insertmacro MUI_UNPAGE_INSTFILES ; page that shows the uninstallation happening (i.e. the progress bar page)
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Main Section" SecMain

  SetOutPath "$INSTDIR" ; set the directory that will be used as the destination for subsequent copy commands
  File /r "${ROOTDIR}\*.*" ; a copy command, here we are recursively copying all files of ROOTDIR to the installation directory

  ;create start-menu shortcut
  ;$SMPROGRAMS is a reference to the directory in windows that houses all start menu shortcuts
  CreateShortCut "$SMPROGRAMS\$(^Name).lnk" "$INSTDIR\${EXE_PATH}" "" "$INSTDIR\${EXE_PATH}" 0  

  ;write uninstall information to the registry (so it shows up in Add/Remove Programs)
  ;in windows, the uninstall information is stored in the registry under the key HKEY_*\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
  ;for system wide installations, this key is HKEY_LOCAL_MACHINE
  ;for user specific installations (of the current user), this key is HKEY_CURRENT_USER
  ;in general, a user in windows cannot read other users registry keys
  ;if you want to install without admin rights, you must 1) write to a user specific folder (like %USERPROFILE%) and 2) write to the user specific registry
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" "DisplayName" "$(^Name)"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" "UninstallString" "$INSTDIR\Uninstall.exe"
  
  ;Create uninstaller
  ;as part of the instllation, we create an uninstaller that will later be used to uninstall the program
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  ; this is the "section" of code that the uninstaller will call when it is invoked
  ; the uninstaller can be directly invoked (by running the uninstaller exe) or it can be invoked by the Add/Remove Programs dialog (if uninstall registery keys were added)

  RMDir /r "$INSTDIR"

  ;delete start-menu shortcut
  Delete "$SMPROGRAMS\$(^Name).lnk"

  ;Delete uninstall information from the registry
  DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"  

SectionEnd