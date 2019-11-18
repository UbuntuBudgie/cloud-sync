# Ubuntu Budgie settings backup - workflow logic  


##Backup  
1. Check if both temporary directory and backup directory have enough free disk space. Required disk space for both temporary and backup directory can be changed with variables "TempAvailSpace" and "BakAvailSpace". Default is 10MB.
2. Create backup directory "budgiebackup". This directory will be inside a parent directory that can be chosen by editing the variable "TempDir". Default is /tmp/ . We will use this directory to store temporary files. Upon completion, we will create a compressed archive and remove this temporary directory.
3. Query installed budgie software, filter by "budgie applets" output list to file.This is needed to avoid issues when restoring budgie settings with dconf, as restoring an applet that is not installed will not give a desirable result.  
4. Query installed budgie themes, filter by "theme name", and output list to file. This will be a specific query limited to only themes that are supported by ubuntu budgie team. Therefore themes available in the budgie-themes panel.  
5. Save current user's budgie applet data. Available in ~/.config/budgie-extras.  
6. Save plank launchers configuration. Available in ~/.config/plank.  
7. Save budgie settings by dumping dconf to file, filter by "/com/solus-project/".  
8. Save plank docks settings by dumping dconf to file, filter by "/net/launchpad/plank/docks/".  
9. Compress all files in the temporary directory, into a .tar.gz archive called "budgiebackup.tar.gz".  
10. Delete temporary directory.  

##Restore  
1. Check if both temporary directory and backup directory have enough free disk space. Required disk space for both temporary and backup directory can be changed with variables "TempAvailSpace" and "BakAvailSpace". Default is 10MB.  
2. Create backup directory "budgiebackup". This directory will be inside a parent directory that can be chosen by editing the variable "TempDir". Default is /tmp/ . We will use this directory to store temporary files. Upon completion, we will create a compressed archive and remove this temporary directory.  
3. Decompress/extract tar archive "budgiebackup.tar.gz" to temporary directory.  
4. Install PPAs used by ubuntu budgie applets and themes. Many applets and themes, require additional PPA repositories, it is important to add those PPAs and install applets and themes before data and dconf are restored. Ubuntu has many releases, and some PPAs are not consistent across releases. An extra script section is created to query release name, and based upon release name, different actions are taken. At this stage 18.04 LTS and 19.10 are supported. Future releases also will require additional work to keep the scripts up to date with PPA names and changes.  
5. Grab previously installed budgie software from list, and issue install command.  
6. Grab previoulsy installed budgie themes from list, and issue install command.
7. Restore budgie applet data, from backup archive to ~/.config/budgie-extras.  
8. Restore plank configuration, from backup archive to ~/.config/plank.  
9. Restore budgie settings using dconf.  
10. Restore plank settings using dconf.  
11. Delete temporary directory.  
12. Prompt for log off.  
