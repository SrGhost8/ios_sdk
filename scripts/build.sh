#!/usr/bin/env bash

set -e

# ======================================== #

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# ======================================== #

# Directories and paths of interest for the script.
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
cd ${ROOT_DIR}

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Removing framework targets folders ... ${NC}"
rm -rf frameworks
rm -rf Carthage
rm -rf build
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Creating framework targets folders ... ${NC}"
mkdir -p frameworks/static
mkdir -p frameworks/dynamic/ios
mkdir -p frameworks/dynamic/tvos
mkdir -p frameworks/dynamic/imessage
# TODO: UNCOMMENT THE FOLLOWING CODE WHEN IT WILL BECOME RELEVANT
#mkdir -p frameworks/dynamic/webbridge
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Bulding static SDK framework and copying it to destination folder ... ${NC}"
xcodebuild -target AdjustStatic -configuration Release clean build
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Bulding universal tvOS SDK framework (device + simulator) and copying it to destination folder ... ${NC}"
xcodebuild -configuration Release -target AdjustSdkTv -arch x86_64 -sdk appletvsimulator clean build
xcodebuild -configuration Release -target AdjustSdkTv -arch arm64 -sdk appletvos build
cp -Rv build/Release-appletvos/AdjustSdkTv.framework frameworks/static
lipo -create -output frameworks/static/AdjustSdkTv.framework/AdjustSdkTv build/Release-appletvos/AdjustSdkTv.framework/AdjustSdkTv build/Release-appletvsimulator/AdjustSdkTv.framework/AdjustSdkTv
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Moving shared schemas to generate dynamic iOS and tvOS SDK framework using Carthage ... ${NC}"
# TODO: UNCOMMENT THE FOLLOWING CODE WHEN IT WILL BECOME RELEVANT
#mv Adjust.xcodeproj/xcshareddata/xcschemes/AdjustSdkIm.xcscheme \
#   Adjust.xcodeproj/xcshareddata/xcschemes/AdjustSdkWebBridge.xcscheme .
# TODO: DELETE THE FOLLOWING CODE WHEN ABOVE WILL BECOME RELEVANT
mv Adjust.xcodeproj/xcshareddata/xcschemes/AdjustSdkIm.xcscheme .
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Bulding dynamic iOS and tvOS targets with Carthage ... ${NC}"
arch -x86_64 /bin/bash ./scripts/carthage_xcode.sh build --no-skip-current
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Move Carthage generated dynamic iOS SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/ios
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Move Carthage generated dynamic tvOs SDK framework to destination folder ... ${NC}"
mv Carthage/Build/tvOS/* frameworks/dynamic/tvos/
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Moving shared schemas to generate dynamic iMessage SDK framework using Carthage ... ${NC}"
mv Adjust.xcodeproj/xcshareddata/xcschemes/AdjustSdk.xcscheme \
   Adjust.xcodeproj/xcshareddata/xcschemes/AdjustSdkTv.xcscheme .
mv AdjustSdkIm.xcscheme Adjust.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Bulding dynamic iMessage target with Carthage ... ${NC}"
arch -x86_64 /bin/bash ./scripts/carthage_xcode.sh build --no-skip-current
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Move Carthage generated dynamic iMessage SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/imessage/
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Moving shared schemas to generate dynamic WebBridge SDK framework using Carthage ... ${NC}"
mv Adjust.xcodeproj/xcshareddata/xcschemes/AdjustSdkIm.xcscheme .
# TODO: UNCOMMENT THE FOLLOWING CODE WHEN IT WILL BECOME RELEVANT
#mv AdjustSdkWebBridge.xcscheme Adjust.xcodeproj/xcshareddata/xcschemes
# TODO: DELETE THE FOLLOWING CODE WHEN ABOVE WILL BECOME RELEVANT
echo -e "${CYAN}[ADJUST][BUILD]:${RED} AdjustWebBridge is not supported! ${NC}"
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Bulding dynamic WebBridge target with Carthage ... ${NC}"
# TODO: UNCOMMENT THE FOLLOWING CODE WHEN IT WILL BECOME RELEVANT
#arch -x86_64 /bin/bash ./scripts/carthage_xcode.sh build --no-skip-current
# TODO: DELETE THE FOLLOWING CODE WHEN ABOVE WILL BECOME RELEVANT
echo -e "${CYAN}[ADJUST][BUILD]:${RED} AdjustWebBridge is not supported! ${NC}"
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Move Carthage generated dynamic WebBridge SDK framework to destination folder ... ${NC}"
# TODO: UNCOMMENT THE FOLLOWING CODE WHEN IT WILL BECOME RELEVANT
#mv Carthage/Build/iOS/* frameworks/dynamic/webbridge/
# TODO: DELETE THE FOLLOWING CODE WHEN ABOVE WILL BECOME RELEVANT
echo -e "${CYAN}[ADJUST][BUILD]:${RED} AdjustWebBridge is not supported! ${NC}"
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Moving shared schemas back ... ${NC}"
mv *.xcscheme Adjust.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Bulding static test library framework and copying it to destination folder ... ${NC}"
# TODO: UNCOMMENT THE FOLLOWING CODE WHEN IT WILL BECOME RELEVANT
#cd ${ROOT_DIR}/AdjustTests/AdjustTestLibrary
#xcodebuild -target AdjustTestLibraryStatic -configuration Debug clean build
# TODO: DELETE THE FOLLOWING CODE WHEN ABOVE WILL BECOME RELEVANT
echo -e "${CYAN}[ADJUST][BUILD]:${RED} AdjustTestLibraryStatic is not supported! ${NC}"
echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD]:${GREEN} Script completed! ${NC}"
