#!/bin/bash

# ANSI color codes
COLOR_BLUE="\e[1;34m"
COLOR_RED="\e[1;31m"
COLOR_GREEN="\e[1;32m"
COLOR_YELLOW="\e[1;33m"
COLOR_RESET="\e[0m"

# Function to display the header
display_header() {
    echo -e "${COLOR_BLUE}╔════════════════════════════════════════╗${COLOR_RESET}"
    echo -e "${COLOR_BLUE}║          Shadow@Bhanu Server Start      ║${COLOR_RESET}"
    echo -e "${COLOR_BLUE}╚════════════════════════════════════════╝${COLOR_RESET}"
}

# Function to get the current timestamp
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Display the header
display_header

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${COLOR_RED}Python 3 is not installed. Please install Python 3 to proceed.${COLOR_RESET}"
    exit 1
fi

# Get port number from user
read -p "Enter the port number to start the server: " port

# Validate port number
if [[ ! $port =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
    echo -e "${COLOR_RED}Invalid port number. Please use a number between 1 and 65535.${COLOR_RESET}"
    exit 1
fi

# Check if the port is already in use
if lsof -i:"$port" &> /dev/null; then
    echo -e "${COLOR_RED}Error: Port $port is already in use. Choose another port.${COLOR_RESET}"
    exit 1
fi

# Start the Python HTTP server
echo -e "${COLOR_GREEN}[$(get_timestamp)] Starting Python HTTP server on port $port...${COLOR_RESET}"
python3 -m http.server "$port" &

# Capture the PID of the server
PID=$!

# Provide feedback for stopping the server
echo -e "${COLOR_YELLOW}[$(get_timestamp)] Server is running with PID: $PID.${COLOR_RESET}"
echo -e "${COLOR_YELLOW}To stop the server, press CTRL+C or run: kill $PID${COLOR_RESET}"

# Function to stop the server gracefully
stop_server() {
    echo -e "\n${COLOR_RED}[$(get_timestamp)] Stopping server...${COLOR_RESET}"
    kill "$PID"
    wait "$PID" 2>/dev/null
    echo -e "${COLOR_RED}[$(get_timestamp)] Server stopped.${COLOR_RESET}"
    exit 0
}

# Trap CTRL+C to stop the server gracefully
trap stop_server SIGINT

# Wait for the server to run until stopped by the user
wait "$PID"
