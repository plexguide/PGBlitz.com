#!/bin/bash

# Configuration file path
CONFIG_FILE="/pg/config/config.cfg"

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
BOLD="\033[1m"
NC="\033[0m"  # No color

# Clear the screen at the start
clear

# Function to source the configuration file
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    else
        echo "VERSION=\"PG Alpha\"" > "$CONFIG_FILE"
        source "$CONFIG_FILE"
    fi
}

# Function for Apps Management
apps_management() {
    bash /pg/scripts/apps_starter_menu.sh
}

# Updated Function to Reinstall PlexGuide
reinstall_plexguide() {
    # Define the destination path
    INSTALL_SCRIPT_PATH="/pg/installer/install_menu.sh"

    # Create the directory if it doesn't exist
    mkdir -p /pg/installer

    # Download the install script from the specified URL
    curl -s https://raw.githubusercontent.com/plexguide/Installer/v11/install_menu.sh -o "$INSTALL_SCRIPT_PATH"

    # Set ownership to 1000:1000 and make the script executable
    chown 1000:1000 "$INSTALL_SCRIPT_PATH"
    chmod +x "$INSTALL_SCRIPT_PATH"

    # Execute the downloaded script
    bash "$INSTALL_SCRIPT_PATH"
    
    exit 0  # Ensure the script exits after executing the menu_exit.sh
}

# Function to exit the script
menu_exit() {
    bash /pg/installer/menu_exit.sh
    exit 0  # Ensure the script exits after executing the menu_exit.sh
}

# Function for HardDisk Management
harddisk_management() {
    bash /pg/scripts/drivemenu.sh
}

# Function for CloudFlare Tunnel Management
cloudflare_tunnel() {
    bash /pg/scripts/cf_tunnel.sh
}

# Function for Options Menu
options_menu() {
    bash /pg/scripts/options.sh
}

# Main menu loop
main_menu() {
    while true; do
        clear
        echo -e "${RED}${BOLD}════════════════════════════════════════════════${NC}"
        echo -e "${RED}${BOLD}Welcome to PlexGuide: $VERSION${NC}"
        echo -e "${RED}${BOLD}════════════════════════════════════════════════${NC}"
        echo ""  # Blank line for separation

        echo -e "${BOLD}A)${NC} Apps Management"
        echo -e "${BOLD}H)${NC} HardDisk Management"
        echo -e "${BOLD}C)${NC} CloudFlare Tunnel (Domains)"
        echo -e "${BOLD}O)${NC} Options"
        echo -e "${BOLD}R)${NC} Reinstall PlexGuide"
        echo -e "${BOLD}Z)${NC} Exit"
        echo ""  # Space between options and input prompt

        read -p "Enter your choice: " choice

        case ${choice,,} in
            a) apps_management ;;
            h) harddisk_management ;;
            c) cloudflare_tunnel ;;
            r) reinstall_plexguide ;;  # Call the updated function
            o) options_menu ;;
            z) menu_exit ;;  # Call the updated menu_exit function
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Run the script
load_config
main_menu