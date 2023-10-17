![Warp-Pipe](https://github.com/joshricketts/Mosyle-Warp-Pipe/assets/105330539/09754aa7-3f80-4ea7-b19b-78749bf28efa)

# Mosyle Warp Pipe
Tool to assist in helping end users enroll their devices into a new MDM platform for macOS devices. Helpful if migrating a fleet of computers to a new MDM without needing to wipe them or utilize manual enrollment and not maintaining full control of the devices. 


Here's a demo of the end user experience:


This is reliant on SwiftDialog for instruction and notification to end users. Thank you Bart Reardon! Check out SwiftDialog:
https://github.com/swiftDialog/swiftDialog


## How to Use
1. Move device from original MDM to the new one in Apple Business Manager/Apple School Manager. 
2. Push this tool to devices in the original MDM.
3. Unenroll devices from the original MDM.
4. Run the script to prompt users to enroll their device.

### Recommended method


- Customize the warp_mosyle.sh file to say what you want in the message and title, and to display the icon/logo you want.

NOTE: There's also a section designed to let you utilize an MDM's API if it's capable of unenrolling a device. I'll be attaching a demo package that utilized the API for JAMF School to unenroll devices for a client. 

- Package the script, launch daemon, any logo/icon file you want, and a log file if desired. 

- Move devices in ABM/ASM to the new MDM (Mosyle is what this is designed around).

- Communicate what to expect with your end users.

- Push the package in the original MDM. End users will not be prompted to enroll until they have been unenrolled from the original MDM. 

- Unenroll the devices from the original MDM when ready (a good way to check would be a script that makes sure these files are in place, or checks for the installation of the package). 

- Due to the existing launch daemon users will start being prompted to enroll into the new MDM. 
