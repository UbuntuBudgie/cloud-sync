# Budgiebackup - README  

- Budgiebackup and Budgierestore are bash scripts that aim to automate backup and restore of Ubuntu Budgie settings, panels, applets, themes, plank settings, and applet data.  
- Backup destination can be chosen by the user. No information is stored or sent outside of chosen backup destination.
- Restore process, in order to make sure all tasks can be fulfilled, adds some PPAs. Those are PPAs that users would need to have in order to install applets and themes. No additional PPAs are added.  
- Restore process includes adding software and repositories, therefore some of the steps will ask user to enter password, in order to elevate privileges (sudo).  
- Backup and restore are tested and compatible with Ubuntu Budgie 18.04 and Ubuntu Budgie 19.10.  
- No personal data is backed up, outside of data relative to Ubuntu Budgie applets. An example, is the quick notes applet.
- Cross release backup and restore is supported, but minor issues with additional applets missing from panels could happen. More testing is undergoing.
- Same-release backup is supported and tested. No issues or inconsistencies are observed so far.
