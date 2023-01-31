An NSIS script that creates a basic installer with a start menu entry and add/remove program functionality.

1. Put the folder that contains the files you want to install in the same directory as the script
2. Set the variables at the very top of the script to desired values
3. Run the script with NSIS

The installer will be created in the same directory as the script.

Features of the resultant installer:
- start menu shortcut
- uninstaller (placed in same directory as installed files)
    - Add/Remove Programs entry

The install script is based on a template written by Joost Verburg.