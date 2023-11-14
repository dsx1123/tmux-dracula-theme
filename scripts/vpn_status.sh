#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh


icon_status_connected='🔒'
icon_status_disconnected='🔓'

vpn_bin="/opt/cisco/secureclient/bin/vpn"

vpn_state() {
    local state=`$vpn_bin state | grep state | head -1 | tr ":" "\n" | tail -1 | xargs`
    echo $state
}

vpn_session_duration() {
    local duration=`$vpn_bin stats | grep Duration | xargs | tr " " "\n" | tail -1 `
    echo $duration
}


main() {
    local status=$(vpn_state)

    if [[ $status =~ (^Connected) ]]; then
        status_icon=$icon_status_connected
    elif [[ $status =~ (^Disconnected) ]]; then
        status_icon=$icon_status_disconnected
    fi

    local session_duration=$(vpn_session_duration)

    echo "$status_icon $status $session_duration"
}

main
