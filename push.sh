mkdir "/workshop" -p

# Check /server/addon.json exists
if ! [ -f /server/addon.json ]; then
    echo "/server/addon.json don't exists"
    exit 1
fi

# Parse "title" from addon json

# Parse title from /server/addon.json, fallback to STEAM_WORKSHOPID
workshop_title=$(jq -r '.title // empty' /server/addon.json)
if [ -z "$workshop_title" ]; then
    workshop_title="$STEAM_WORKSHOPID"
fi


# Check is workshop_include file exists
if [ -f /server/workshop_include ]; then
    while read -r line
    do
        if [ -n "$line" ]; then
            cp "/server/$line" /workshop -r
        fi
    done < "/server/workshop_include"
else
    cp /server/maps /workshop
    cp /server/backgrounds /workshop -r
    cp /server/gamemodes /workshop -r
    cp /server/materials /workshop -r
    cp /server/lua /workshop -r
    cp /server/scenes /workshop -r
    cp /server/models /workshop -r
    cp /server/scripts /workshop -r
    cp /server/particles /workshop -r
    cp /server/sound /workshop -r
    cp /server/resource /workshop -r
fi

echo "Imporing maFile"
mkdir maFiles -p && echo '{"version":1,"entries":[]}' >> maFiles/manifest.json
echo $STEAM_MAFILE > /app/steamacoount.maFile
steamguard -m $PWD/maFiles import --files /app/steamacoount.maFile

cp /server/addon.json /workshop
ls -la /workshop

/app/fastgmad create -folder /workshop -out content.gma -warninvalid -noprogress

# Create workshop.vdf with previewfile if /server/preview.png exists
if [ -f /server/preview.png ]; then
    cat <<EOL > "/app/workshop.vdf"
"workshopitem"
{
    "appid"        "4000"
    "publishedfileid"    "$STEAM_WORKSHOPID"
    "visibility"        ""
    "contentfolder"        "$PWD/content.gma"
    "title"		"$workshop_title"
    "previewfile"        "/server/preview.png"
    "changenote"        "Auto-uploaded: $(date +'%d-%B-%Y - %H:%M:%S')"
}
EOL
else
    cat <<EOL > "/app/workshop.vdf"
"workshopitem"
{
    "appid"        "4000"
    "publishedfileid"    "$STEAM_WORKSHOPID"
    "visibility"        ""
    "contentfolder"        "$PWD/content.gma"
    "title"		"$workshop_title"
    "changenote"        "Auto-uploaded: $(date +'%d-%B-%Y - %H:%M:%S')"
}
EOL
fi

# Function to get the steam guard code
get_steam_guard_code() {
    # Run the command and capture the output
    output=$(steamguard -m "$PWD/maFiles" code)

    # Parse the output to get the code
    code=$(echo "$output" | grep -E '^[A-Z0-9]{5,}$')

    # Return the code
    echo "$code"
}

echo "Extracting steam guard code..."
extracted_code=$(get_steam_guard_code)

echo "Extracted steam guard code: $extracted_code"

echo "Uploading changes to workshop... Can take a while..."
/app/Steam/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD $extracted_code +workshop_build_item /app/workshop.vdf +logout +exit