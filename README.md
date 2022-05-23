![Migration](https://user-images.githubusercontent.com/105330539/169730776-0b01ee45-dd61-42ab-ae7e-339fdfe9d12f.png)

# Migration
Tool to assist in helping end users enroll their devices into a new MDM platform for macOS devices. Helpful if migrating a fleet of computers to a new MDM without needing to wipe them or utilize manual enrollment and not maintaining full control of the devices. 


Here's a demo of the end user experience:
https://drive.google.com/file/d/1A_K2qICcGhcbaypLKpYUjjvfiWvxiSIq/view?usp=sharing


This is reliant on DEPNotify for instruction and notification to end users. There several ways this tool could be utilized.


## How to Use
1. Move device from original MDM to the new one in Apple Business Manager/Apple School Manager. 
2. Push this tool to devices in the original MDM.
3. Unenroll devices from the original MDM.
4. Run the script to prompt users to enroll their device.

### Recommended method

- Customize the Migration.sh file to say what you want in the message and title, and to display the icon/logo you want.

NOTE: There's also a section designed to let you utilize an MDM's API if it's capable of unenrolling a device. I'll be attaching a demo package that utilized the API for JAMF School to unenroll devices for a client. 

- Package the script, launch daemon, any logo/icon file you want, and a log file if desired. 

- Move devices in ABM/ASM.

- Communicate what to expect with your end users.

- Push the package in the original MDM. End users will not be prompted to enroll until they have been unenrolled from the original MDM. 

- Unenroll the devices from the original MDM. 

NOTE: If using the API of your original to MDM to unenroll with the script then end users will start getting prompted immediately. 


