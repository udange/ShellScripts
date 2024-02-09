#!/bin/bash

<<Description
This script is for user management and
directory backup from source to destination
Description

# Function to display options
display_Options() {
    echo "---------------------------------"
    echo "User Management and Backup Script"
    echo "---------------------------------"
    echo "1. Add User"
    echo "2. Delete User"
    echo "3. Modify User Paswword"
    echo "4. Create Group"
    echo "5. Add User to Group"
    echo "6. Backup Directory"
    echo "7. Exit"
}

# Function to add user
add_user() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
    else
        sudo useradd -m "$username"
         echo "User '$username' created successfully."
    fi
}

# Function to delete user
delete_user() {
    read -p "Enter username to delete: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username" > /dev/null
		echo "User '$username'deleted."
    else
        echo "User '$username' does not exist."
    fi
}

# Function to reset password for user
reset_password() {
    read -p "Enter username to modify password: " username
    if id "$username" &>/dev/null; then
        sudo passwd "$username"
        echo "Password changed successfully for $username"
    else
        echo "User '$username' does not exist."
    fi
}

# Function to create group
create_group() {
    read -p "Enter group name: " groupname
    if grep -q "^$groupname:" /etc/group; then
        echo "Group '$groupname' already exists."
    else
        sudo groupadd "$groupname"
        echo "Group '$groupname' created."
    fi
}

# Function to add user to group
add_user_to_group() {
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    if id "$username" &>/dev/null && grep -q "^$groupname:" /etc/group; then
        sudo usermod -aG "$groupname" "$username"
        echo "User $username has been added to Group '$groupname'."
    else
	   echo "User $username and Group $groupname does not exist."
    fi
}

# Function to backup directory
backup_directory() {
    read -p "Enter directory to backup: " directory
    if [ -d "$directory" ]; then
        date=$(date +"%Y-%m-%d-%H-%M-%S")
        backup_file="backup_$date.tar.gz"
        tar -czvf "/home/ubuntu/Backup/$backup_file" "$directory"
        echo "Backup created: $backup_file"
    else
        echo "Directory '$directory' does not exist."
    fi
}

# Main script
while true; do
    display_Options
    read -p "Enter your option: " choice
    case $choice in
        1) add_user ;;
        2) delete_user ;;
        3) reset_password ;;
        4) create_group ;;
        5) add_user_to_group ;;
        6) backup_directory ;;
        7) echo "Exiting..."; break ;;
        *) echo "Invalid choice. Please enter a number from 1 to 7." ;;
    esac
done
