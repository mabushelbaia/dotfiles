#!/bin/env bash

# shellcheck disable=SC1091
if ! source "$(which hyde-shell)"; then
    echo "[wallbash] code :: Error: hyde-shell not found."
    echo "[wallbash] code :: Is HyDE installed?"
    exit 1
fi

#* This glyph Data is from `https://www.nerdfonts.com/cheat-sheet`
#* I don't own anything of it
#TODO:   Needed a way to fetch the glyph from the NerdFonts source.
#TODO:    find a way make the  DB update
#TODO:    make the update Script run on User space

glyphDir=${HYDE_DATA_HOME:-$HOME/.local/share/hyde}
glyphDATA="${glyphDir}/glyph.db"
cacheDir="${HYDE_CACHE_HOME:-$HOME/.cache/hyde}"
recentData="${cacheDir}/landing/show_glyph.recent"
confDir=${XDG_CONFIG_HOME:-$HOME/.config}

# Set rofi scaling
rofiScale="${ROFI_GLYPH_SCALE}"
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=${ROFI_SCALE:-10}
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"

save_recent() {
    #? Prepend the selected glyph to the top of the recentData file
    # sed -i "1i\\$selGlyph" "${recentData}"
    awk -v var="$dataGlyph" 'BEGIN{print var} {print}' "${recentData}" >temp && mv temp "${recentData}"
    #?  Use awk to remove duplicates and empty lines, moving the most recent glyph to the top
    awk 'NF' "${recentData}" | awk '!seen[$0]++' >temp && mv temp "${recentData}"
}

if [[ ! -f "${recentData}" ]]; then
    echo "  Arch linux I use Arch BTW" >"${recentData}"
fi
#? Read the contents of recent.db and main.db separately
recent_entries=$(cat "${recentData}")
main_entries=$(cat "${glyphDATA}")
#? Combine the recent entries with the main entries
combined_entries="${recent_entries}\n${main_entries}"
#? Remove duplicates from the combined entries
unique_entries=$(echo -e "${combined_entries}" | awk '!seen[$0]++')
rofi_position=$(get_rofi_pos)
rofi_config="$confDir/rofi/clipboard.rasi"
dataGlyph=$(echo "${unique_entries}" | rofi -dmenu -multi-select -i \
    -theme-str "entry { placeholder: \" 🔣 Glyph\";} ${rofi_position}" \
    -theme-str "${r_scale}" \
    -config "${rofi_config}")
# selGlyph=$(echo -n "${selGlyph}" | cut -d' ' -f1 | tr -d '\n' | wl-copy)
trap save_recent EXIT
selGlyph=$(printf "%s" "${dataGlyph}" | cut -d' ' -f1 | tr -d '\n\r')
wl-copy "${selGlyph}"
paste_string "${*}"
