#!/system/bin/sh

LOG_TAG="link_telephony_dbs"
LOG_NAME="${0}:"

loge ()
{
  /system/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

OLD_TELEPHONY_DB_DIR=/data/user_de/0/com.android.providers.telephony/databases/
OLD_TELEPHONY_PREFS_DIR=/data/user_de/0/com.android.providers.telephony/shared_prefs/
NEW_TELEPHONY_DB_DIR=/data/data/com.android.providers.telephony/databases/
NEW_TELEPHONY_PREFS_DIR=/data/data/com.android.providers.telephony/shared_prefs/

PATH_LEN=$(echo ${OLD_TELEPHONY_DB_DIR} | wc -c)
PATH_LEN_PREFS=$(echo ${OLD_TELEPHONY_PREFS_DIR} | wc -c)

logi "Starting Link RIL Databases"

logi "Deleting directory..."
rm -rf ${NEW_TELEPHONY_DB_DIR}
rm -rf ${NEW_TELEPHONY_PREFS_DIR}

logi "Creating directory..."
mkdir -p ${NEW_TELEPHONY_DB_DIR}
mkdir -p ${NEW_TELEPHONY_PREFS_DIR}

for db in `find ${OLD_TELEPHONY_DB_DIR} -type f | cut -c ${PATH_LEN}-`; do
    if ! [ -e ${NEW_TELEPHONY_DB_DIR}/${db} ]; then
	    logi "Linking ${NEW_TELEPHONY_DB_DIR}${db}..."
	    ln -s ${OLD_TELEPHONY_DB_DIR}${db} ${NEW_TELEPHONY_DB_DIR}
    fi
done

for prefs in `find ${OLD_TELEPHONY_PREFS_DIR} -type f | cut -c ${PATH_LEN_PREFS}-`; do
    if ! [ -e ${NEW_TELEPHONY_PREFS_DIR}/${prefs} ]; then
	    logi "Linking ${NEW_TELEPHONY_PREFS_DIR}${prefs}..."
	    ln -s ${OLD_TELEPHONY_PREFS_DIR}${prefs} ${NEW_TELEPHONY_PREFS_DIR}
    fi
done

logi "Setting permissions..."
chmod 0751 ${NEW_TELEPHONY_DB_DIR}/..
chmod 0771 ${NEW_TELEPHONY_DB_DIR}
chmod 0751 ${NEW_TELEPHONY_PREFS_DIR}/..
chmod 0771 ${NEW_TELEPHONY_PREFS_DIR}
chown radio:radio ${NEW_TELEPHONY_DB_DIR} -R
chown radio:radio ${NEW_TELEPHONY_PREFS_DIR} -R
