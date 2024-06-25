#!/bin/bash
# Script by gylfirst

activate_virtualenv() {
    # Ask the user the virtualenv path in order to activate it
    read -p "Enter the absolute path of your python virtualenv folder: " VENV_PATH
    # Check if the virtual environment path is valid
    if [ ! -d "$VENV_PATH" ]; then
        echo "Error: The specified virtual environment path does not exist."
        exit 1
    fi
    # Check if the activation script exists
    if [ ! -f "$VENV_PATH/bin/activate" ]; then
        echo "Error: The activation script for the virtual environment does not exist."
        exit 1
    fi
    # Activate the virtual environment
    source $VENV_PATH/bin/activate
    echo "Virtual environment activated: $(python --version)"
}

set_default_choice() {
    local input_choice="$1"
    # Check if the user has entered a valid option
    if [ -z "$input_choice" ] || [ "$input_choice" == "Y" ]; then
        echo "y"
    else
        echo "$input_choice"
    fi
}

check_updates() {
    echo 'Checking if package updates are available...'
    # Capture the output of 'pip list -o'
    output=$(pip list -o 2>/dev/null)
}

ask_backup() {
    # Ask the user if he wants to create a backup
    read -p "Do you want to create a backup of your current installed packages? (Y/n) " choice
    choice=$(set_default_choice "$choice")
    case $choice in
        y)
            read -p "Enter the absolute path of your backup file: " backup_path
            echo 'Doing backup...'
            pip3 freeze > $backup_path
            echo 'Backup done'
            ;;
        n)
            echo "No backup will be created"
            ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
    esac
}

backup() {
    # Ask the user the backup file path in order to create it
    if [ -z "$output" ]; then
        echo "All packages are up-to-date"
    else
        echo "There are outdated packages"
    fi
    ask_backup
}

remove_pip() {
    # Remove the 'pip' line from the output
    output=$(echo "$output" | grep -v "^pip ")
}

pip_update() {
    if echo "$output" | grep -q "^pip "; then
        echo "Package 'pip' is outdated"
        read -p "Do you want to update it? (Y/n) " choice
        choice=$(set_default_choice "$choice")
        case $choice in
            y)
                pip install -U pip
                remove_pip
                echo "Package 'pip' is up-to-date"
                ;;
            n)
                remove_pip
                echo "Package 'pip' is outdated and won't be updated"
                ;;
            *)
                echo "Invalid option"
                exit 1
                ;;
        esac
    else
        echo "Package 'pip' is up-to-date"
    fi
}

update_packages() {
    echo 'Updating packages...'
    echo "$output" | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip3 install -U
    echo 'Python packages update done'
}

check_other_updates() {
    # Check if the output is empty or not
    if [ -z "$output" ]; then
        echo "All packages are up-to-date"
    else
        echo "There are outdated packages"
        read -p "Do you want to update them? (Y/n) " choice
        choice=$(set_default_choice "$choice")
        case $choice in
            y)
                update_packages
                ;;
            n)
                echo "Packages are outdated and won't be updated"
                ;;
            *)
                echo "Invalid option"
                exit 1
                ;;
        esac
    fi
    }

main() {
    # Activate the virtualenv
    activate_virtualenv
    # Check if there are updates available
    check_updates
    # Backup the current installed packages
    backup
    # Update the 'pip' package
    pip_update
    # Update the other packages
    check_other_updates
}

# Call the main function
main
