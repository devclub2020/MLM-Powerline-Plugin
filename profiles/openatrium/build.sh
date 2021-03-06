#!/bin/sh
# Script to build OpenAtrium 2.x
# Make sure the correct number of args was passed from the command line
if [ $# -eq 0 ]; then
  echo "Usage $0 target_build_dir"
  exit 1
fi
DRUSH_OPTS='--working-copy --no-gitinfofile'
MAKEFILE='build-openatrium.make'
TARGET=$1
# Make sure we have a target directory
if [ -z "$TARGET" ]; then
  echo "Usage $0 target_build_diri"
  exit 2
fi
CALLPATH=`dirname $0`
ABS_CALLPATH=`cd $CALLPATH; pwd -P`
BASE_PATH=`cd ..; pwd`

echo '_______      ___'
echo '| ___ |     /  |'
echo '| | | |    /   |'
echo '| |_| |   / /| |'
echo '|____ |  / / | |'
echo '   OpenAtrium   '
echo '================'

# Temp move settings
echo 'Backing up settings.php...'
mv $TARGET/sites/default/settings.php settings.php
# Remove current drupal dir
echo 'Wiping Drupal directory...'
rm -rf $TARGET
# Do the build
echo 'Running drush make...'
drush make $DRUSH_OPTS $ABS_CALLPATH/$MAKEFILE $TARGET
# Build Symlinks
echo 'Setting up symlinks...'
DRUPAL=`cd $TARGET; pwd -P`
ln -s $ABS_CALLPATH $DRUPAL/profiles/openatrium
ln -s /opt/files/openatrium $DRUPAL/sites/default/files
# Restore settings
echo 'Restoring settings...'
ln -s $BASE_PATH/settings.php $DRUPAL/sites/default/settings.php

# Move libraries from inherited profiles into site libraries
#   These instructions should be incorporated into the make file in the future
mkdir $DRUPAL/sites/all/libraries
mv -v $DRUPAL/profiles/panopoly/libraries/tinymce $DRUPAL/sites/all/libraries/tinymce
mv -v $DRUPAL/profiles/panopoly/libraries/markitup $DRUPAL/sites/all/libraries/markitup
mv -v $DRUPAL/profiles/panopoly/libraries/respondjs $DRUPAL/sites/all/libraries/respondjs
mv -v $DRUPAL/profiles/panopoly/libraries/SolrPhpClient $DRUPAL/sites/all/libraries/SolrPhpClient

# Clear caches and Run updates
cd $DRUPAL;
echo 'Clearing caches...'
drush cc all; drush cc all;
echo 'Running updates...'
drush updb -y;
echo 'Build complete.'
