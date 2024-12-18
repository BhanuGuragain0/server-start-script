#!/bin/bash

# Shadow@Bhanu header with robust error handling
echo -e "\e[1;34m╔════════════════════════════════════════╗\e[0m"
echo -e "\e[1;34m║          Shadow@Bhanu Server Start      ║\e[0m"
echo -e "\e[1;34m╚════════════════════════════════════════╝\e[0m"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "\e[1;31mPython 3 is not installed. Please install Python 3 to proceed.\e[0m"
    exit 1
fi

# Check if user has permission to bind ports (root privilege check for lower ports)
if [ "$EUID" -eq 0 ] && [ "$port" -lt 1024 ]; then
    echo -e "\e[1;31mWarning: You need elevated privileges to bind to ports below 1024.\e[0m"
    exit 1
fi

# Get port number from user
read -p "Enter the port number to start the server: " port

# Validate port number
if [[ ! $port =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
    echo -e "\e[1;31mInvalid port number. Please use a number between 1 and 65535.\e[0m"
    exit 1
fi

# Check if the port is already in use
if lsof -i:$port &> /dev/null; then
    echo -e "\e[1;31mError: Port $port is already in use. Choose another port.\e[0m"
    exit 1
fi

# Start the Python HTTP server
echo -e "\e[1;32mStarting Python HTTP server on port $port...\e[0m"
python3 -m http.server "$port" &

# Capture the PID of the server
PID=$!

# Provide feedback for stopping the server
echo -e "\e[1;33mServer is running with PID: $PID.\e[0m"
echo -e "\e[1;33mTo stop the server, press CTRL+C or run: kill $PID\e[0m"

# Wait for the server to run until stopped by the user
wait $PID

# Server stopped message
echo -e "\e[1;31mServer stopped.\e[0m"

