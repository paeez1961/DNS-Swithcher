#!/bin/bash

# ==============================================================================
# Bash DNS Switcher
# Author: https://github.com/Linuxmaster14 (Fork by You)
# Description: A simple interactive Bash script to quickly switch between custom
#              DNS providers on Linux with backup and restore support.
#              Also includes an install function to setup prerequisites and clone repo.
# ==============================================================================

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

REPO_URL="https://github.com/paeez/dns-switcher.git"
INSTALL_DIR="$HOME/dns-switcher"

# ----------- Functions -----------

install_dependencies() {
    echo -e "${CYAN}Checking and installing git if needed...${NC}"
    if ! command -v git &> /dev/null; then
        echo "git not found. Installing git..."
        sudo apt update && sudo apt install -y git
    else
        echo "git is already installed."
    fi
}

clone_repo() {
    if [ -d "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}Removing existing directory $INSTALL_DIR${NC}"
        rm -rf "$INSTALL_DIR"
    fi
    echo -e "${CYAN}Cloning repository to $INSTALL_DIR...${NC}"
    git clone "$REPO_URL" "$INSTALL_DIR"
}

run_script() {
    cd "$INSTALL_DIR" || { echo -e "${RED}Failed to enter $INSTALL_DIR${NC}"; exit 1; }
    chmod +x dns-switcher.sh
    sudo ./dns-switcher.sh
}

install_all() {
    install_dependencies
    clone_repo
    run_script
}

# ----------- Main script -----------

if [ "$EUID" -ne 0 ] && [ "$1" != "install" ]; then
    echo -e "${RED}Error:${NC} Please run this script as root (use sudo) or run './dns-switcher.sh install' as a normal user first."
    exit 1
fi

providers=("Shecan" "Electro" "Begzar" "DNS Pro" "Google" "Cloudflare" "Quad9" "OpenDNS" "AlternateTest" "Reset to Default")
declare -A dns_servers=(
    ["Shecan"]="178.22.122.100 185.51.200.2"
    ["Electro"]="78.157.42.100 78.157.42.101"
    ["Begzar"]="185.55.226.26 185.55.226.25"
    ["DNS Pro"]="87.107.110.109 87.107.110.110"
    ["Google"]="8.8.8.8 8.8.4.4"
    ["Cloudflare"]="1.1.1.1 1.0.0.1"
    ["Quad9"]="9.9.9.9 149.112.112.112"
    ["OpenDNS"]="208.67.222.222 208.67.220.220"
    ["AlternateTest"]="5.5.5.5 6.6.6.6"
    ["Reset to Default"]="127.0.0.53"
)

show_current() {
    echo
    echo -e "${YELLOW}Current DNS:${NC}"
    grep "^nameserver" /etc/resolv.conf 2>/dev/null | awk '{print "  •", $2}' || echo "  (none)"
    echo
}

show_menu() {
    echo -e "${CYAN}Available DNS Providers:${NC}"
    for i in "${!providers[@]}"; do
        name="${providers[$i]}"
        printf "  %2d) %-17s %s\n" $((i + 1)) "$name" "${dns_servers[$name]}"
    done
    echo "   0) Exit"
    echo
}

backup_resolv() {
    local backup="/etc/resolv.conf.bak.$(date +%Y%m%d_%H%M%S)"
    cp /etc/resolv.conf "$backup"
    echo -e "${GREEN}Backup created:${NC} $backup"
}

update_resolv() {
    local provider="$1"
    local dns_list="$2"
    local tmp
    tmp=$(mktemp)

    {
        echo "# Updated on $(date)"
        if [ "$provider" != "Reset to Default" ]; then
            echo "# Provider: $provider"
        fi
        for dns in $dns_list; do
            echo "nameserver $dns"
        done

        if [ "$provider" = "Reset to Default" ]; then
            grep -E '^(options|search)' /etc/resolv.conf 2>/dev/null
        else
            echo "options edns0 trust-ad"
            local existing_search
            existing_search=$(grep "^search" /etc/resolv.conf 2>/dev/null)
            if [ -n "$existing_search" ]; then
                echo "$existing_search"
            fi
        fi
    } > "$tmp"

    # Loading animation
    echo -ne "${CYAN}Applying DNS settings"
    for i in {1..6}; do
        echo -n "."
        sleep 0.3
    done
    echo -e "${NC}"

    mv "$tmp" /etc/resolv.conf
    echo -e "${GREEN}✅ DNS updated:${NC} $provider (${dns_list// /, })"
}

main_menu() {
    show_current
    while true; do
        show_menu
        read -rp "Select (0-${#providers[@]}): " choice
        echo

        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}Invalid input${NC}, numbers only."
            continue
        fi

        if [ "$choice" -eq 0 ]; then
            echo -e "${CYAN}Bye.${NC}"
            exit 0
        fi

        if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#providers[@]}" ]; then
            echo -e "${RED}Invalid option.${NC}"
            continue
        fi

        provider="${providers[$((choice - 1))]}"
        backup_resolv
        update_resolv "$provider" "${dns_servers[$provider]}"
        show_current
        break
    done
}

# ---------- Entry point ----------

if [ "$1" == "install" ]; then
    install_all
else
    main_menu
fi
