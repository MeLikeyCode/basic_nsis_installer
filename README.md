An NSIS script that creates a basic installer with a start menu entry and add/remove program functionality.

1. Put the folder that contains the files you want to install in the same directory as the script (`build_installer.nsi`)
2. Set the variables at the very top of the script to desired values
3. Run the script with NSIS (`makensis build_installer.nsi` or use the NSIS GUI)

The installer will be created in the same directory as the script.

Features of the resultant installer:
- start menu shortcut
- uninstaller (placed in same directory as installed files)
    - Add/Remove Programs entry

The install script is based on a template written by Joost Verburg.