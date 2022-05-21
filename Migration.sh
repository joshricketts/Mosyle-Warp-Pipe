#!/bin/bash

# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** CUSTOMIZED PORTION OF SCRIPT ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------


# Custom title and message in Dialog box. To enter a space and new line in the message use the following text before each line: " \n \n"

title="Enroll your Mac into our new MDM!"

message="You must complete the enrollment process into the new management system. \n \n
If you do not enroll your device you will not be able to access to any resources within your organization. \n \n
Please connect to a network at this time. \n \nIf no notification shows up when this text changes then try clicking the clock in the top right corner of your display on the menu bar."

# Text for the computer to search for within the Configuration Profiles directory.
# This is to detect if there is still a config profile from the old MDM to determine if we are still enrolled. Generally should be the MDM name.
oldMDM="JAMF"

# Text for the computer to search for within the Configuration Profiles directory.
# This is to detect if there is still a config profile from the old MDM to determine if we are still enrolled. Generally should be the MDM name.
newMDM="Mosyle"



# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** START OF STANDARD SCRIPT ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** VARIABLES ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------


# File path to packaged Mosyle icon for 
icon="Command: Image: /Library/Management/EnrollMDM/Mosyle$Mosyleicon.png"

# DEPNotify application path
dialog_app="/Applications/Utilities/DEPNotify.app/Contents/MacOS/DEPNotify"

# DEPNotify command file path
dialog_cmd_file="/var/tmp/depnotify.log"

# Command to open DEPNotify dialog window
dialog_cmd="/bin/echo 
Command: MainTitle: $title
Command: MainText: $message
$icon"


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** FUNCTIONS ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------

# Clear log file
function clearlog(){
	rm /private/var/tmp/depnotify.log; touch /private/var/tmp/depnotify.log
}

# Execute a DEPNotify command.
function dialog_command(){
	/bin/echo "$1"
	/bin/echo "$1"  >> "$dialog_cmd_file"
}

# Remove prior provisioning file for testing and debugging
function cleanup(){
	rm -r /private/var/tmp/com.depnotify.provisioning.done
}

# Unenroll from JAMF School. You'll need to review API documentation and build and API in Postman to get the "curl" section information created.
function unenrollJAMFSchool(){
    udid=$(system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }')
echo "$udid"
    curl --location --request POST "https://#specificURLofyourJAMFSchooltenant#.jamfcloud.com/api/devices/$udid/unenroll" \
--header "Authorization: Basic #Base64-JAMFSchoolNetworkID:APIKey#" \
--header "Cookie: hash=#you'll get this when building your API in Postman#"
}

# Find if we are currently enrolled in the old MDM. This function works well for JAMF School which is the only one I can test on. We shouldn't need the "checkAllMDMs" function if you know which MDM you're leaving and put it in the variable up top.
function checkOldMDM(){
    grep -Ril "$oldMDM" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
# Here is where you will want to put the unenroll function for your specific tenant in place of the echo and exit commands. 
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
}

# Find if we are currently enrolled into any MDM currently. This function cannot be fully tested for all MDMs. If you're moving from an MDM besides JAMF please test this well prior to deployment.
function checkAllMDMs(){
    grep -Ril "JAMF" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Intune" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Meraki" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Kandji" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Mosyle" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Meraki" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "Hexnode" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "JumpCloud" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "Workspace One" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "MobileIron" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "MaaS360" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "Cisco" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "IBM" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
     grep -Ril "Airwatch" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Addigy" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Microsoft" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
    grep -Ril "Zuludesk" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
    if [[ $? = 0 ]];
        then echo "You must unenroll this device from the old MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding"
    exit 1000
    fi
}

# Find if we are currently enrolled into any MDM currently. This function cannot be fully tested for all MDMs. If you're moving from an MDM besides JAMF please test this well prior to deployment.
function checknewMDM(){
    grep -Ril "$newMDM" /private/var/db/ConfigurationProfiles/Settings/Managed\ Applications 
}

# Command to enroll Mac
function enroll(){
	sudo profiles renew -type enrollment
}

# Command to properly rest between sections of script
function rest(){
	sleep 5
}

function finalize_success(){
	dialog_command "Command: Determinate: 1"
	dialog_command "Command: DeterminateManualStep: 1"
	dialog_command "Command: ContinueButton: Done ✅"
	dialog_command "Command: MainText: You've successfully completed enrollment of your Mac! Thank you!"
    dialog_command "Command: MainTitle: Enrollment Complete!"
}

function finalize_failure(){
	dialog_command "Command: Determinate: 1"
	dialog_command "Command: DeterminateManualStep: 1"
	dialog_command "Command: ContinueButton: Done ❌"
	dialog_command "Command: MainText: Enrollment did not complete successfully. You will prompted to try again later."
    dialog_command "Command: MainTitle: Enrollment Unfinished"
}

# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** CHECK WE'RE IN USER ENVIRONMENT ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------


# Check that user is logged in currently.
setupAssistantProcess=$(pgrep -l "Setup Assistant")
until [ "$setupAssistantProcess" = "" ]; do
  echo "$(date "+%a %h %d %H:%M:%S"): Setup Assistant Still Running. PID $setupAssistantProcess." 2>&1 | tee -a /var/tmp/deploy.log
  sleep 1
  setupAssistantProcess=$(pgrep -l "Setup Assistant")
done
echo "$(date "+%a %h %d %H:%M:%S"): Out of Setup Assistant" 2>&1 | tee -a /var/tmp/deploy.log
echo "$(date "+%a %h %d %H:%M:%S"): Logged in user is $(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')" 2>&1 | tee -a /var/tmp/deploy.log

finderProcess=$(pgrep -l "Finder")
until [ "$finderProcess" != "" ]; do
  echo "$(date "+%a %h %d %H:%M:%S"): Finder process not found. Assuming device is at login screen. PID $finderProcess" 2>&1 | tee -a /var/tmp/deploy.log
  sleep 1
  finderProcess=$(pgrep -l "Finder")
done
echo "$(date "+%a %h %d %H:%M:%S"): Finder is running" 2>&1 | tee -a /var/tmp/deploy.log
echo "$(date "+%a %h %d %H:%M:%S"): Logged in user is $(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')" 2>&1 | tee -a /var/tmp/deploy.log


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** START EXECUTING ENROLLMENT PROCESS AND INFORMING END USER ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------

# Check for existence of a profile from any MDM that should get removed upon unenrollment. Once gone start attempting to enroll into new MDM/Mosyle.
checkAllMDMs

# Check for existence of a file from the old MDM that should get removed upon unenrollment. Once gone start attempting to enroll into new MDM/Mosyle.
checkOldMDM


# Prepare by removing provisioning file.
cleanup


# Clear log file
clearlog



# Write to DEPNotify command file.
dialog_command "$dialog_cmd"


# Launch DEPNotify and run it in the background. Sleep for a while to let it initialize and give users a chance to read initial message.
open -a "$dialog_app"

for i in {1..12}; do
	rest
done


# Start enrollment process.
    enroll


# Change DEPNotify window based on enrollment process starting
    dialog_command "Command: MainText: Follow steps outlined below to enroll your computer. \n \n1️⃣ Click the notification that shows up in the top right corner \n \n2️⃣ This will open a pop-up window asking for you to allow your device to be enrolled. Select 'Allow' \n \n3️⃣ Type in the login credentials for your computer and click 'Enroll'"
rest


# Start while loop that ends once the Mosyle MDM application is detected, or times out after about 6 and a half minutes. 
for i in {1..80}; do
# Detect Mosyle profile to allow Dialog box to close.
    checknewMDM
		if [[ $? = 0 ]];
			then
				echo "Computer enrolled into Mosyle. Allowing Dialog window to be closed"
				finalize_success
				break 2
		else
				echo "Computer not enrolled yet."
				rest
		fi
done


# If Mosyle profile isn't in place (due to user not finishing enrollment) then exit here to prevent running any further customized portionof the script before user finishes enrolling.
checknewMDM
if [[ ! $? = 0 ]]; 
    then 
        finalize_failure
        exit 1
fi


# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** CUSTOM PER CLIENT/OPTIONAL - CLEANUP OLD MDM TENANT FILES ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------





# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** END OF SCRIPT ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
exit 0
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# *** END OF SCRIPT ***
# --------------------------------------------------------------------------------------------------------------------------------------------------------------
