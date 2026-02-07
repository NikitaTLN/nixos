#!/usr/bin/env bash

get_volume_num() { pamixer --get-volume; }
is_muted() { pamixer --get-mute | grep -q true; }

get_volume_label() {
    if is_muted; then
        printf "Muted"
    else 
        printf "%s%%" "$(get_volume_num)"
    fi
}

notify_user() {
    local var label 
    if is_muted; then
        val 0
    else 
        val="$(get_volume_num)"
    fi
    label="$(get_volume_label)"
    notify-send -e \
        -h int:value:"$val" \
        -h string:x-canonical-private-synchronous:osd \
        -u low \
        "Volume" "$label"
}

inc_volume() {
    if is_muted; then
        toggle_mute
    else
        pamixer -i 5 --allow-boost --set-limit 150
        notify_user
    fi
}

dec_volume() {
    if is_muted; then
        toggle_mute
    else
        pamixer -d 5
        notify_user
    fi
}

toggle_mute() {
    if is_muted; then
        pamixer -u
    else
        pamixer -m 
    fi
    notify_user
}

case "$1" in
    --get)          notify_user ;;
    --inc)          inc_volume ;;
    --dec)          dec_volume ;;
    --toggle)       toggle_mute ;;
    *)              get_volume_label ;;
esac
