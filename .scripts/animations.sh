#!/usr/bin/env bash

# shellcheck source=$HOME/.local/bin/hyde-shell
# shellcheck disable=SC1091
if ! source "$(which hyde-shell)"; then
    echo "[wallbash] code :: Error: hyde-shell not found."
    echo "[wallbash] code :: Is HyDE installed?"
    exit 1
fi

# Set variables
confDir="${confDir:-$XDG_CONFIG_HOME}"
animations_dir="$confDir/hypr/animations"

# Ensure the animations directory exists
if [ ! -d "$animations_dir" ]; then
    notify-send -i "preferences-desktop-display" "Error" "Animations directory does not exist at $animations_dir"
    exit 1
fi

# List available .conf files in animations directory
animation_items=$(find "$animations_dir" -name "*.conf" ! -name "disable.conf" ! -name "theme.conf" 2>/dev/null | sed 's/\.conf$//')

if [ -z "$animation_items" ]; then
    notify-send -i "preferences-desktop-display" "Error" "No .conf files found in $animations_dir"
    exit 1
fi

fn_select() {
    rofi_config="$confDir/rofi/clipboard.rasi"

    # Set rofi scaling
    rofiScale="${ROFI_ANIMATION_SCALE}"
    [[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=${ROFI_SCALE:-10}
    r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"

    # Window and element styling
    hypr_border=${hypr_border:-"$(hyprctl -j getoption decoration:rounding | jq '.int')"}
    wind_border=$((hypr_border * 3 / 2))
    elem_border=$((hypr_border == 0 ? 5 : hypr_border))
    hypr_width=${hypr_width:-"$(hyprctl -j getoption general:border_size | jq '.int')"}
    r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"

    animation_items="Disable Animation
Theme Preference
$animation_items"
    rofi_select="${HYPR_ANIMATION/theme/Theme Preference}"
    rofi_select="${rofi_select/disable/Disable Animation}"

    # Display options using Rofi with custom scaling, positioning, and placeholder
    selected_animation=$(awk -F/ '{print $NF}' <<<"$animation_items" |
        rofi -dmenu -i -select "$rofi_select" \
            -p "Select animation" \
            -theme-str "entry { placeholder: \"Select animation...\"; }" \
            -theme-str "${r_scale}" \
            -theme-str "${r_override}" \
            -theme-str "$(get_rofi_pos)" \
            -theme "$rofi_config")

    # Exit if no selection was made
    if [ -z "$selected_animation" ]; then
        exit 0
    fi
    case $selected_animation in
    "Disable Animation")
        selected_animation="disable"
        ;;
    "Theme Preference")
        selected_animation="theme"
        ;;
    esac

    set_conf "HYPR_ANIMATION" "$selected_animation"
    fn_update
    # Notify the user
    notify-send -i "preferences-desktop-display" "Animation:" "$selected_animation"
}

fn_update() {
    [ -f "$HYDE_STATE_HOME/config" ] && source "$HYDE_STATE_HOME/config"
    [ -f "$HYDE_STATE_HOME/staterc" ] && source "$HYDE_STATE_HOME/staterc"
    local animDir="$confDir/hypr/animations"
    current_animation=${HYPR_ANIMATION:-"theme"}
    echo "Animation updated to: $current_animation"
    cat <<EOF >"${confDir}/hypr/animations.conf"

#! ▄▀█ █▄░█ █ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
#! █▀█ █░▀█ █ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█

# See https://wiki.hyprland.org/Configuring/Animations/
# HyDE Controlled content // DO NOT EDIT
# Edit or add animations in the ./hypr/animations/ directory
# and run the 'animations.sh select' command to update this file

\$ANIMATION=${current_animation}
\$ANIMATION_PATH=${animDir}/${current_animation}.conf

EOF
    # cat "${animDir}/${current_animation}.conf" >>"${confDir}/hypr/animations.conf"
}

if declare -f "fn_${1}" >/dev/null; then
    "fn_${1}"
else
    cat <<HELP
Usage:
    select    Select an animation from the available options
    update    Update the animation to the selected option

HELP
fi
