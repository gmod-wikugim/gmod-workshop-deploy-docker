mkdir "/workshop" -p

# Check /server/addon.json exists
if ! [ -f /server/addon.json ]; then
    echo "/server/addon.json don't exists"
    exit 1
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
    cp . /workshop
fi

echo "Imporing maFile"
mkdir maFiles -p && echo '{"version":1,"entries":[]}' >> maFiles/manifest.json
echo $STEAM_MAFILE > /app/steamacoount.maFile
steamguard -m $PWD/maFiles import --files /app/steamacoount.maFile

cp /server/addon.json /workshop
ls -la /workshop

/app/fastgmad create -folder /workshop -out content.gma -warninvalid

# Create workshop.vdf if it does not exist
cat <<EOL > "/app/workshop.vdf"
"workshopitem"
{
    "appid"		"4000"
    "publishedfileid"	"$STEAM_WORKSHOPID"
    "visibility"		""
    "contentfolder"		"$PWD/content.gma"
    "changenote"		"Auto-uploaded: $(date +'%d-%B-%Y - %H:%M:%S')"
}
EOL

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
/app/Steam/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD $extracted_code +workshop_build_item /app/workshop.vdf +quit