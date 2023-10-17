#!/bin/zsh

# This script walks end-users through enrolling their computers into an MDM. Please check the following URL for instructions on 
version="1.0"

# -----------------------------------------------------------------------------------
# *** CUSTOMIZABLE VARIABLES ***
# -----------------------------------------------------------------------------------

enrollment_URL="" # find this in their Mosyle tenant under Organization/My School > Apple Basic Setup > Enrollment > Manual Enroll via Safari URL-----Ex: "https://enroll.mosyle.com/?account=organization"

instructionURL=""

support_email=""

title="Mosyle Enrollment"

initial_message="## Device is not managed by Mosyle\n
To begin the process of enrollment click the **Start** button below\n
Then follow the coming instructions to enroll your device into Mosyle.\n"

error_message="Enrollment was not successful. You will be prompted to reattempt shortly.\n
If continue to have trouble enrolling your Mac please email the following support address:\n
**$support_email**"

success_message="Enrollment into Mosyle was successful!\n
Feel free to check out the new Self-Service app which looks like the above icon."

helpmessage="This tool is designed to run when a device is not enrolled into Mosyle.\n
It will prompt you every 30 minutes to complete enrollment until you have successfully enrolled.\n
If you have any problems enrolling please email:\n
**$support_email**"

# -----------------------------------------------------------------------------------
# *** STATIC VARIABLES ***
# -----------------------------------------------------------------------------------

timestamp=$(date "+%a %h %d %H:%M:%S")
logfile="/var/log/Mosyle_Warp.log"

# Refresh script log file, and write initial timestamp of script run
echo "$timestamp" > "$logfile"

dialogApp="/usr/local/bin/dialog"
dialog_command_file="/var/tmp/Enroll_Mosyle_CMDfile.txt"

# Refresh SwiftDialog command file
echo "" > "$dialog_command_file"

icon="/Library/Application Support/Mosyle Warp Pipe/Mosyle-icon.png"

caption1_ADE="Click the notification that should have just shown in the top right corner of the screen. If you don't see one then click on the date and time on the menu bar, and then click the nofication there."
caption2_ADE="After clicking 'Allow' you will be prompted to enter the login credentials for your laptop to finish enrollment."
caption3_ADE="Enter your computer's login credentials to approve the install."

caption1_Safari="Safari should have opened to download a file, and a notification should have come up."
caption2_Safari="If you don't see the notification then open the .mobileconfig file that should now be the most recent file in your 'Downloads' folder. (It will not have the same name as the example)"
caption3_Safari="Open System Preferences or System Settings and find 'Profiles'."
caption4_Safari="Double-click on the profile pending install."
caption5_Safari="Click 'Enroll' on the pop-up."
caption6_Safari="Enter your computer's login credentials to approve the install."

dialogCMD_Initial="$dialogApp \
--title \"$title\" \
--message \"$initial_message\" \
--alignment center \
--icon \"$icon\" \
--commandfile \"$dialog_command_file\" \
--quitkey \"X\" \
--small \
--moveable \
--ontop \
--timer 600 \
--hidetimerbar \
--helpmessage \"$helpmessage\" \
--infobuttontext \"More Instructions\" \
--infobuttonaction \"$instructionURL\" \
--button1text \"Start\" \
"

dialogCMD_ADE_Enroll="$dialogApp \
--title \"$title\" \
--alignment center \
--icon \"$icon\" \
--message \"$ADE_message\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/ADE-Assets/1.Notification.png\" \
--imagecaption \"$caption1_ADE\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/ADE-Assets/2.ClickAllow.png\" \
--imagecaption \"$caption2_ADE\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/ADE-Assets/3.EnterCreds.png\" \
--imagecaption \"$caption3_ADE\" \
--commandfile \"$dialog_command_file\" \
--quitkey \"X\" \
--moveable \
--ontop \
--timer 600 \
--hidetimerbar \
--autoplay \
--helpmessage \"$helpmessage\" \
--infobuttontext \"More Instructions\" \
--infobuttonaction \"$instructionURL\" \
--button1text \"Done!\" \
--button2text \"I didn't receive a notification...\" \
"

dialogCMD_Safari_Enroll="$dialogApp \
--title \"$title\" \
--alignment center \
--icon \"$icon\" \
--message \"$Safari_message\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/Safari-Assets/1.Notification.png\" \
--imagecaption \"$caption1_Safari\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/Safari-Assets/2.DownloadedFile.png\" \
--imagecaption \"$caption2_Safari\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/Safari-Assets/3.OpenSystemPrefs.png\" \
--imagecaption \"$caption3_Safari\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/Safari-Assets/4.Double-ClickProfile.png\" \
--imagecaption \"$caption4_Safari\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/Safari-Assets/5.ClickEnroll.png\" \
--imagecaption \"$caption5_Safari\" \
--image \"/Library/Application Support/Mosyle Warp Pipe/Safari-Assets/6.EnterCreds.png\" \
--imagecaption \"$caption6_Safari\" \
--commandfile \"$dialog_command_file\" \
--quitkey \"X\" \
--moveable \
--ontop \
--timer 600 \
--hidetimerbar \
--autoplay \
--helpmessage \"$helpmessage\" \
--infobuttontext \"More Instructions\" \
--infobuttonaction \"$instructionURL\" \
--button1text \"Done!\" \
--button2text \"I wasn't able to complete enrollment...\" \
"

dialogCMD_Error="$dialogApp \
--title \"$title\" \
--message \"$error_message\" \
--alignment center \
--small \
--icon \"$icon\" \
--commandfile \"$dialog_command_file\" \
--quitkey \"X\" \
--moveable \
--ontop \
--timer 600 \
--hidetimerbar \
--helpmessage \"$helpmessage\" \
--infobuttontext \"More Instructions\" \
--infobuttonaction \"$instructionURL\" \
--button1text \"Close\" \
"

MDMs=(
	"JAMF"
	"Intune"
	"Meraki"
	"Kandji"
	"Hexnode"
	"JumpCloud"
	"Workspace One"
	"MobileIron"
	"MaaS360"
	"Cisco"
	"IBM"
	"Airwatch"
	"Addigy"
	"Microsoft"
	"Zuludesk"
	"Mosyle"
	)

# -----------------------------------------------------------------------------------
# *** STATIC FUNCTIONS ***
# -----------------------------------------------------------------------------------

# Find if we are currently enrolled into any MDM currently. This function cannot be fully tested for all MDMs. If you're moving from an MDM besides JAMF please test this well prior to deployment.
function checkMosyle(){
    grep -Ril "Mosyle" "/private/var/db/ConfigurationProfiles/Settings/Managed Applications"; check_code="$?"

    echo "checkMosyle exit code = $check_code" 2>&1 | tee -a "$logfile"

    if [[ "$check_code" == 0 ]]; then 
    	#echo "Enrolled in Mosyle. Success." 2>&1 | tee -a "$logfile"

    	dialogCMD_Success="$dialogApp \
    		--title \"$title\" \
				--message \"$success_message\" \
				--alignment center \
				--small \
				--icon \"$icon\" \
				--centericon \
				--commandfile \"$dialog_command_file\" \
				--quitkey \"X\" \
				--moveable \
				--ontop \
				--timer 600 \
				--hidetimerbar \
				--helpmessage \"$helpmessage\" \
				--button1text \"Close\" \
				"
				
    	/bin/echo "$dialogCMD_Success" 2>&1 | tee -a "$logfile"
			eval "$dialogCMD_Success" &
			sleep .5
    	exit 0
    fi
}

# -----------------------------------------------------------------------------------
# *** VERIFY SWIFTDIALOG IS IN PLACE ***
# -----------------------------------------------------------------------------------

  # Get the URL of the latest PKG From the Dialog GitHub repo
  dialogURL=$(curl --silent --fail "https://api.github.com/repos/bartreardon/swiftDialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
  # Expected Team ID of the downloaded PKG
  dialogExpectedTeamID="PWA5E9TQ59"

  # Check for Dialog and install if not found
  if [ ! -e "/Library/Application Support/Dialog/Dialog.app" ]; then
    echo "Dialog not found. Installing..." 2>&1 | tee -a "$logfile"
    # Create temporary working directory
    workDirectory=$( /usr/bin/basename "$0" )
    tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
    # Download the installer package
    /usr/bin/curl --location --silent "$dialogURL" -o "$tempDirectory/Dialog.pkg"
    # Verify the download
    teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/Dialog.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
    # Install the package if Team ID validates
    if [ "$dialogExpectedTeamID" = "$teamID" ] || [ "$dialogExpectedTeamID" = "" ]; then
      /usr/sbin/installer -pkg "$tempDirectory/Dialog.pkg" -target /
    else
    	echo "Could not install SwiftDialog. Exiting." 2>&1 | tee -a "$logfile"
      exitCode=1
      exit $exitCode
    fi
    # Remove the temporary working directory when done
    /bin/rm -Rf "$tempDirectory"  
  else 
  	echo "Dialog already found. Proceeding..." 2>&1 | tee -a "$logfile"
  fi

# -----------------------------------------------------------------------------------
# *** VERIFY ENROLLMENT STATUS ***
# -----------------------------------------------------------------------------------

# Find if we are currently enrolled into any MDM currently. This function cannot be fully tested for all MDMs. If you're moving from an MDM besides JAMF please test this well prior to deployment.

 for MDM in "${MDMs[@]}"; do

	echo "Checking MDM enrollment for $MDM." 2>&1 | tee -a "$logfile"
  grep -Ril "$MDM" "/private/var/db/ConfigurationProfiles/Settings/Managed Applications"; check_code="$?"
  if [[ "$check_code" = 0 ]]; then 
  	if [[ "$MDM" = "Mosyle" ]]; then
  		echo "Device already enrolled in Mosyle. Exiting." 2>&1 | tee -a "$logfile"
    	exit 0
    fi
    echo "You must unenroll this device from $MDM, and assign it to Mosyle in Apple Business/School Manager before proceeding." 2>&1 | tee -a "$logfile"
    exit 0
	fi

done

# -----------------------------------------------------------------------------------
# *** VERIFY USER IS SIGNED IN ***
# -----------------------------------------------------------------------------------

# Check that a user is logged in currently.
setupAssistantProcess=$(pgrep -l "Setup Assistant")
until [ "$setupAssistantProcess" = "" ]; do
  	echo "$(date "+%a %h %d %H:%M:%S"): Setup Assistant Still Running. PID $setupAssistantProcess."
  	sleep 5
  	setupAssistantProcess=$(pgrep -l "Setup Assistant")
done
echo "$(date "+%a %h %d %H:%M:%S"): Out of Setup Assistant" 2>&1 | tee -a "$logfile"

		finderProcess=$(pgrep -l "Finder")
until [ "$finderProcess" != "" ]; do
  	echo "$(date "+%a %h %d %H:%M:%S"): Finder process not found. Assuming device is at login screen. PID $finderProcess"
  	sleep 5
  	finderProcess=$(pgrep -l "Finder")
done
echo "$(date "+%a %h %d %H:%M:%S"): Finder is running"  2>&1 | tee -a "$logfile"
echo "$(date "+%a %h %d %H:%M:%S"): Logged in user is $(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')" 2>&1 | tee -a "$logfile"

# -----------------------------------------------------------------------------------
# *** STARTING DIALOG WINDOW ***
# -----------------------------------------------------------------------------------

/bin/echo "$dialogCMD_Initial" 2>&1 | tee -a "$logfile"
eval "$dialogCMD_Initial"; return_code="$?"
sleep .5

case "$return_code" in 
	0)
		echo "User has pressed 'Start' on 'Initial' dialog. Continuing script." 2>&1 | tee -a "$logfile"

		sudo profiles renew -type enrollment

		/bin/echo "$dialogCMD_ADE_Enroll" 2>&1 | tee -a "$logfile"
		eval "$dialogCMD_ADE_Enroll"; return_code="$?"

		sleep .5

		case "$return_code" in 
			0)
				echo "User has pressed 'Done' on 'ADE' dialog. Checking enrollment success, and if not successful continuing to 'Safari' dialog." 2>&1 | tee -a "$logfile"

				checkMosyle

				open -a Safari "$enrollment_URL"

				/bin/echo "$dialogCMD_Safari_Enroll" 2>&1 | tee -a "$logfile"
				eval "$dialogCMD_Safari_Enroll"; return_code="$?"
				sleep .5

				case "$return_code" in 
					0)
						echo "User has pressed 'Done' on 'Safari' dialog. Checking if enrollment occurred and exiting code 10 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 10
					;;
					2)
						echo "User has pressed 'Couldn't complete enrollment...' on 'Safari' dialog. Checking if enrollment occurred and exiting code 2 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 2
					;;
					4)
						echo "Timer expired on 'Safari' dialog. Checking if enrollment occurred and exiting code 4 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 4
					;;
					*)
						echo "'Safari' dialog window closed. Checking if enrollment occurred and exiting code 1 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 1
					;;
				esac

			;;
			2)
				echo "User has pressed 'Didn't receive notification' on 'ADE' dialog. Checking for enrollment, and if not successful continuing to 'Safari' dialog." 2>&1 | tee -a "$logfile"

				checkMosyle

				open -a Safari "$enrollment_URL"

				/bin/echo "$dialogCMD_Safari_Enroll" 2>&1 | tee -a "$logfile"
				eval "$dialogCMD_Safari_Enroll"; return_code="$?"
				sleep .5

				case "$return_code" in 
					0)
						echo "User has pressed 'Done' on 'Safari' dialog. Checking if enrollment occurred and exiting code 10 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 10
					;;
					2)
						echo "User has pressed 'Couldn't complete enrollment...' on 'Safari' dialog. Checking if enrollment occurred and exiting code 2 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 2
					;;
					4)
						echo "Timer expired on 'Safari' dialog. Checking if enrollment occurred and exiting code 4 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 4
					;;
					*)
						echo "'Safari' dialog window closed. Checking if enrollment occurred and exiting code 1 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

						checkMosyle

						/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
						eval "$dialogCMD_Error" &
						sleep .5
						exit 1
					;;
				esac
			;;
			4)
				echo "Timer expired on 'ADE' dialog. Checking if enrollment occurred and exiting code 4 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

				checkMosyle

				/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
				eval "$dialogCMD_Error" &
				sleep .5
				exit 4
			;;
			*)
				echo "'ADE' dialog was closed. Checking if enrollment occurred and exiting code 1 with 'Error' dialog if not." 2>&1 | tee -a "$logfile"

				checkMosyle

				/bin/echo "$dialogCMD_Error" 2>&1 | tee -a "$logfile"
				eval "$dialogCMD_Error" &
				sleep .5
				exit 1
			;;
		esac
	;;
	4)
		echo "Timer expired on 'Initial' dialog. Exiting code 4." 2>&1 | tee -a "$logfile"

		exit 4
	;;
	*)
		echo "'Initial' dialog was closed. Exiting code 1." 2>&1 | tee -a "$logfile"

		exit 1
	;;
esac
