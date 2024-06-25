# Pip Updater

This project is a automatic updater for any python virtual environment. It's written in bash.

## Functionalities

- Automatically updates any Python virtual environment.
- Create a backup of installed packages before update.
- Checks for updates in the installed packages.
- Ask the user if he wants to update pip.
- Ask the user if he wants to updates other dependencies.

## Prerequisites

- Python virtual environment
- Bash

## Installation

To install the Pip Updater, follow these steps:

```bash
git clone https://github.com/gylfirst/pip-updater.git
cd pip-updater
chmod +x ./pip_updater.sh
```

Once you have cloned the repository and navigated to the `pip-updater` directory, make the `pip_updater.sh` script executable by running the command `chmod +x ./pip_updater.sh`.

## Usage

```bash
./pip_updater.sh
```

1. Enter the absolute path of the virtual env.
2. Tell if you want to do a backup of your dependencies.
3. Tell if you want to update pip.
4. Tell if you want to update all outdated packages.

# Author
[Gylfirst](https://github.com/gylfirst)

# License
This project is licensed under the MIT License.
