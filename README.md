<h1> <p "font-size:200px;"><img align="left" src="https://github.com/SoftFever/OrcaSlicer/blob/main/resources/images/OrcaSlicer.ico" width="100"> Orca Slicer</p> </h1>

<a href="https://discord.gg/P4VE9UY9gJ"><img src="https://img.shields.io/static/v1?message=Discord&logo=discord&label=&color=7289DA&logoColor=white&labelColor=&style=for-the-badge" height="35" alt="discord logo"/> </a>

BCUA Remover is a tool that automates the removal of Blue Coat Unified Agent (BCUA) and its related components from a Windows system. This tool is designed for IT administrators and advanced users who need to fully uninstall BCUA, including registry entries, services, files, and processes.

## Usage
1. **Run as Administrator:**
   - Right-click `main.bat` and select **Run as administrator**.
   - If not run as admin, the script will attempt to relaunch itself with elevated privileges.
2. **Follow Prompts:**
   - The script will perform all removal steps automatically.
   - At the end, you will be prompted to restart your computer. Enter `Y` to restart or `N` to exit without restarting.

## How It Works

The `main.bat` script performs the following steps to ensure complete removal of Blue Coat Unified Agent (BCUA):

1. **Checks for Administrator Privileges:**
   - If not running as administrator, the script relaunches itself with elevated permissions.
2. **Removes Registry Keys:**
   - Deletes BCUA-related registry keys from `HKLM` and `HKCR`.
   - Searches for and removes any registry entries containing "bcua".
   - Removes Unified Agent entries from the Uninstall registry.
3. **Terminates BCUA Processes:**
   - Stops `bcua-service.exe` and `bcua-notifier.exe` if they are running.
4. **Deletes Files and Directories:**
   - Removes BCUA folders from `C:\ProgramData`, `C:\Program Files`, and deletes the driver file from `C:\Windows\System32\drivers`.
5. **Prompts for Restart:**
   - After removal, prompts the user to restart the computer to complete the process.

This process ensures that all traces of BCUA are removed from the system, following the official manual removal steps.

## Important Notes
- This script is based on the official BCUA removal instructions: [Broadcom Knowledge Base Article 169376](https://knowledge.broadcom.com/external/article/169376/manually-uninstall-unified-agent.html)
- Use with caution. The script makes permanent changes to the registry and deletes files/directories related to BCUA.
- Ensure you have backups or system restore points before running.

## License
This project is licensed under the GNU Affero General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## Disclaimer
This script is provided as-is, without warranty of any kind. Use at your own risk. HSP Studios is not responsible for any damage or data loss resulting from use of this script.
