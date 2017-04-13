#!/system/bin/sh

LOG_TAG="link_db"
LOG_NAME="${0}:"

loge ()
{
  /system/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

OLD_TELEPHONY_DIR=/data/user_de/0/com.android.providers.telephony
NEW_TELEPHONY_DIR=/data/data/com.android.providers.telephony
TELEPHONY_DB=telephony.db

if ! [ -e ${NEW_TELEPHONY_DIR}/databases/${TELEPHONY_DB} ]; then
    logi "Starting Link RIL Database"
    mkdir -p ${NEW_TELEPHONY_DIR}/databases

    logi "Linking database..."
    ln -s ${OLD_TELEPHONY_DIR}/databases/${TELEPHONY_DB} ${NEW_TELEPHONY_DIR}/databases/${TELEPHONY_DB}

    logi "Setting permissions..."
    chown radio:radio ${NEW_TELEPHONY_DIR} -R
    chmod 0751 ${NEW_TELEPHONY_DIR}
    chmod 0771 ${NEW_TELEPHONY_DIR}/databases/
    chmod 0660 ${NEW_TELEPHONY_DIR}/databases/${TELEPHONY_DB}
fi
