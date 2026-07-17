#!/bin/bash -e
ASSETS_PATH=../MenuBarTimer/Assets.xcassets
APPICON_SRC=MenuBarTimer.png
APPICON_ICONSET=${ASSETS_PATH}/AppIcon.appiconset

CONVERT="convert -verbose -background none +repage"

if [ "$1" == "appicon" ]; then
    ${CONVERT} -resize '!16x16' ${APPICON_SRC} ${APPICON_ICONSET}/icon_16x16.png
    ${CONVERT} -resize '!32x32' ${APPICON_SRC} ${APPICON_ICONSET}/icon_16x16@2x.png
    ${CONVERT} -resize '!32x32' ${APPICON_SRC} ${APPICON_ICONSET}/icon_32x32.png
    ${CONVERT} -resize '!64x64' ${APPICON_SRC} ${APPICON_ICONSET}/icon_32x32@2x.png
    ${CONVERT} -resize '!128x128' ${APPICON_SRC} ${APPICON_ICONSET}/icon_128x128.png
    ${CONVERT} -resize '!256x256' ${APPICON_SRC} ${APPICON_ICONSET}/icon_128x128@2x.png
    ${CONVERT} -resize '!256x256' ${APPICON_SRC} ${APPICON_ICONSET}/icon_256x256.png
    ${CONVERT} -resize '!512x512' ${APPICON_SRC} ${APPICON_ICONSET}/icon_256x256@2x.png
    ${CONVERT} -resize '!512x512' ${APPICON_SRC} ${APPICON_ICONSET}/icon_512x512.png
    ${CONVERT} -resize '!1024x1024' ${APPICON_SRC} ${APPICON_ICONSET}/icon_512x512@2x.png
fi
