#!/sbin/sh

# Based on Chainfire's work.

# get file descriptor for output
OUTFD=$(ps | grep -v "grep" | grep -o -E "update_binary(.*)" | cut -d " " -f 3);

# try looking for a differently named updater binary
if [ -z $OUTFD ]; then
  OUTFD=$(ps | grep -v "grep" | grep -o -E "updater(.*)" | cut -d " " -f 3);
fi

# same as progress command in updater-script, for example:
#
# progress 0.25 10
#
# will update the next 25% of the progress bar over a period of 10 seconds
progress() {
  if [ $OUTFD != "" ]; then
    echo "progress ${1} ${2} " 1>&$OUTFD;
  fi;
}

# same as set_progress command in updater-script, for example:
#
# set_progress 0.25
#
# sets progress bar to 25%
set_progress() {
  if [ $OUTFD != "" ]; then
    echo "set_progress ${1} " 1>&$OUTFD;
  fi;
}

# same as ui_print command in updater_script, for example:
#
# ui_print "hello world!"
#
# will output "hello world!" to recovery, while
#
# ui_print
#
# outputs an empty line
ui_print() {
  if [ $OUTFD != "" ]; then
    echo "ui_print ${1} " 1>&$OUTFD;
    echo "ui_print " 1>&$OUTFD;
  else
    echo "${1}";
  fi;
}

# Mounts the dir passed as argument 1, for example:
#
# "mount_fs /system" or "mount_fs system"
#
# will both mount the system partition on /system
#
mount_fs() {
  if [ -n ${1} ]; then
    FS_DIR=$(echo $1 | sed s'/\///'g)
    FS_TYPE=$(mount | grep "on /${FS_DIR}" | cut -d ' ' -f 5)

    if [ -z ${FS_TYPE} ]; then
        ui_print "Mounting /${FS_DIR}..."
        mount /${FS_DIR}
    fi
  fi
}

# Unmounts the dir passed as argument 1, for example:
#
# "umount_fs /system" or "umount_fs system"
#
# will both unmount the system partition on /system
#
umount_fs() {
  if [ -n ${1} ]; then
    FS_DIR=$(echo $1 | sed s'/\///'g)
    FS_TYPE=$(mount | grep "on /${FS_DIR}" | cut -d ' ' -f 5)

    if ! [ -z ${FS_TYPE} ]; then
        ui_print "Unmounting /${FS_DIR}..."
        umount /${FS_DIR}
    fi
  fi
}
