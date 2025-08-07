#!/bin/bash

# --- Configuration ---
GEOIP_COUNTRY_DB_URL="https://www.indaws.es/cloud/GeoLite2-Country.mmdb"
GEOIP_CITY_DB_URL="https://www.indaws.es/cloud/GeoLite2-City.mmdb"
DEST_DIR="/home/odoo/geoip"

# --- Script Logic ---

echo "--- GeoIP Database Download Script ---"
echo "$(date) - Starting the download script."

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Function to download and update a file
download_and_update() {
    local url="$1"
    local filename="$2"
    local temp_file="$DEST_DIR/$filename.new"
    local final_file="$DEST_DIR/$filename"

    echo "$(date) - Downloading $filename from $url..."

    # Use curl to download the file
    # -L: Follow redirects
    # -s: Silent mode, do not show progress meter or error messages
    # -o: Write to a specified file
    curl -L -sS -o "$temp_file" "$url"

    # Check if the download was successful (curl returns 0 on success)
    if [ $? -eq 0 ]; then
        # Move the temporary file to the final destination, overwriting the old one
        mv "$temp_file" "$final_file"
        echo "$(date) - Update of $filename completed."
    else
        echo "$(date) - ERROR: Download of $filename failed. Keeping the old version."
        # Remove the incomplete temporary file
        rm -f "$temp_file"
    fi
}

# Download and update the Country database
download_and_update "$GEOIP_COUNTRY_DB_URL" "GeoLite2-Country.mmdb"

# Download and update the City database
download_and_update "$GEOIP_CITY_DB_URL" "GeoLite2-City.mmdb"

# Fix permissions
chown -R odoo:odoo "$DEST_DIR"

echo "$(date) - Script finished."