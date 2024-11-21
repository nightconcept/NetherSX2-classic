#!/bin/bash
# alias to display [Done] in green
display_done() {
	printf "\e[1;32m[Done]\e[0m\n"
}

# alias to display text in cyan
display_cyan() {
	printf "\e[1;36m%s\e[0m" "$1"
}

# alias to display text in light red
display_light_red() {
	printf "\e[1;91m%s\e[0m" "$1"
}

# start of script
clear
printf "\e[1;91m=================================\n"
printf " NetherSX2-Classic Patcher v1.9\n"
printf "=================================\e[0m\n"

# Check if an NetherSX2 APK exists and if it's named correctly
if [ ! -f "13930-v1.5-3668.apk" ]; then
	wget https://github.com/Trixarian/NetherSX2-classic/releases/download/0.0/13930-v1.5-3668.apk
	if [ ! $? -eq 0 ]; then
		printf "Failed to download unmodified APK!\n"
		exit 1
	fi
fi

# Check if the AetherSX2 APK is the right version
if [ "$(md5sum "13930-v1.5-3668.apk" | awk '{print $1}')" != "4a1751fa99bc4dcd647114c4d64e7985" ]; then
	printf "\e[0;31mError: Incorrect APK provided!\n"
	printf "Please provide a copy of AetherSX2 named 13930-v1.5-3668.apk!\e[0m\n"
	exit 1
fi

# Patching the AetherSX2 into a copy of NetherSX2
if [ ! -f "13930-v1.5-3668-mod.apk" ]; then
	display_cyan "Patching to "
	display_light_red "NetherSX2-Classic...              "
	lib/xdelta3 -d -f -s 13930-v1.5-3668.apk lib/patch.xdelta 13930-v1.5-3668-mod.apk
	if [ ! $? -eq 0 ]; then
		printf "Failed to apply NetherSX2 patch to APK!\n"
		exit 1
	else
		display_done
	fi
fi

# Let's leave a backup copy of the NetherSX2 APK
cp 13930-v1.5-3668-mod.apk 13930-v1.5-3668-mod[patched].apk

# Updates to Latest GameDB with features removed that are not supported by the libemucore.so from March 13th
display_cyan "Updating the "
display_light_red "GameDB...                        "
lib/aapt r 13930-v1.5-3668-mod[patched].apk assets/GameIndex.yaml
lib/aapt a 13930-v1.5-3668-mod[patched].apk assets/GameIndex.yaml					> /dev/null 2>&1
if [ $? -eq 0 ]; then
	display_done
fi

# Updates the Game Controller Database
display_cyan "Updating the "
display_light_red "Controller Database...           "
lib/aapt r 13930-v1.5-3668-mod[patched].apk assets/game_controller_db.txt
lib/aapt a 13930-v1.5-3668-mod[patched].apk assets/game_controller_db.txt				> /dev/null 2>&1
if [ $? -eq 0 ]; then
	display_done
fi

# Updates the Widescreen Patches
display_cyan "Updating the "
display_light_red "Widescreen Patches...            "
lib/aapt r 13930-v1.5-3668-mod[patched].apk assets/cheats_ws.zip
lib/aapt a 13930-v1.5-3668-mod[patched].apk assets/cheats_ws.zip					> /dev/null 2>&1
if [ $? -eq 0 ]; then
	display_done
fi

	# Updates the No-Interlacing Patches
display_cyan "Updating the "
display_light_red "No-Interlacing Patches...        "
lib/aapt r 13930-v1.5-3668-mod[patched].apk assets/cheats_ni.zip
lib/aapt a 13930-v1.5-3668-mod[patched].apk assets/cheats_ni.zip					> /dev/null 2>&1
if [ $? -eq 0 ]; then
	display_done
fi

# Resigns the APK before exiting
if command -v "apksigner" >/dev/null 2>&1; then
	display_cyan "Resigning the "
	display_light_red "NetherSX2 APK...                "
	apksigner sign --ks lib/android.jks --ks-pass pass:android_sign --key-pass pass:android_sign_alias 13930-v1.5-3668-mod[patched].apk
	if [ $? -eq 0 ]; then
		display_done
	fi
else
	display_cyan "Resigning the "
	display_light_red "NetherSX2-Classic APK...        "
	java -jar lib/apksigner.jar sign --ks lib/android.jks --ks-pass pass:android_sign --key-pass pass:android_sign_alias 13930-v1.5-3668-mod[patched].apk
	if [ $? -eq 0 ]; then
		display_done
	fi
fi
# Alternate Key:
# if command -v "apksigner" >/dev/null 2>&1; then
# 	display_cyan "Resigning the "
# 	display_light_red "NetherSX2 APK...                "
# 	apksigner sign --ks lib/public.jks --ks-pass pass:public 13930-v1.5-3668-mod[patched].apk
# 	if [ $? -eq 0 ]; then
# 		display_done
# 	fi
# else
# 	display_cyan "Resigning the "
# 	display_light_red "NetherSX2 APK...                "
# 	java -jar lib/apksigner.jar sign --ks lib/public.jks --ks-pass pass:public 13930-v1.5-3668-mod[patched].apk
# 	if [ $? -eq 0 ]; then
# 		display_done
# 	fi
# fi
