# txAdmin Playtime Tracker
This standalone FiveM playtime tracker connects to a MySQL database and logs player playtime from `PlayersDB.json` (TxData). It’s packaged as an executable with no dependencies required - just configure the `config.json` to start tracking and storing playtime.

## Table of Contents
- [License](#license)
- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Running the Application](#running-the-application)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Contact](#contact)

## License
All Rights Reserved.
- This software is owned by @Tradie_/TradieKM/Kingsmen RP. Unauthorized distribution of any of these files, copying or modification is strictly prohibited.
© 2024, @Tradie_ / TradieKM / Kingsmen RP.

## Features
- Formats and tracks player playtime data using a MySQL database and pre-defined target PlayersDB file.
- Automatically creates a table if it doesn't exist.
- Easy configuration through a `config.json` file.
- Self-contained executable with no additional dependencies required.

## Requirements
- **Windows 10/11** (not tested on older versions).
- **MySQL Server** installed and running.
- A correctly configured `config.json` file (see below).

```
## -----------------------------------------------------------------------------------------------------------------------------------------------
## ███████ ███████ ████████ ██    ██ ██████  
## ██      ██         ██    ██    ██ ██   ██ 
## ███████ █████      ██    ██    ██ ██████  
##      ██ ██         ██    ██    ██ ██      
## ███████ ███████    ██     ██████  ██      
```                                        

### Step 1: `Install/Run MySQL`

### Step 2: Configure the `config.json`
1. Open the `config.json` file, and keep it in the same directory/folder as `storePlaytime.exe`.
2. Update the `dataFilePath` and `database` fields to match your environment:

## Your `config.json` should look similar to this (without the explanatory comments):

    ```json
    {
        "dataFilePath": "D:/KMRP/localhost-server/txData/default/data/playersDB.json", //PlayersDB.json location
        "database": {
            "host": "localhost", //locahost or host name
            "user": "root", //user or root
            "password": "", //password or empty
            "database": "qbcoreframework_0caee9" //database name
        }
    }
    ```

```
## -----------------------------------------------------------------------------------------------------------------------------------------------
## ██████   ██████  ███    ██ ███████ 
## ██   ██ ██    ██ ████   ██ ██      
## ██   ██ ██    ██ ██ ██  ██ █████   
## ██   ██ ██    ██ ██  ██ ██ ██      
## ██████   ██████  ██   ████ ███████ 
```   

## Running and storing Playtimes
1. Run `storePlaytime.exe`.

2. The application will automatically:
    - Connect to the MySQL database using the `config.json` settings.
    - Create the `player_playtimes` table if it doesn’t already exist.
    - Read player data from the specified `dataFilePath`.
    - Insert or update playtime records in the database if they are new or they exist.
    - The console will show detailed logs, such as database connections, read operations, and any errors encountered, it wil lthen exit once complete.
   

### Great! Your playtimes should now be in the pre-defined SQL table!

# Step 3: Enabling the Player Command
1. Run either my paid or free FiveM playtime resource (`td-playtime`) on your server.
**Links: (Completely free, but i offer a paid version)**
Free [[Link - Tebex](https://td-fivem.tebex.io/package/6480777)]
Paid [[Link - Tebex](https://td-fivem.tebex.io/package/6485639)]
2. The script will automatically detect several notification resources and core frameworks, and print the detection results in the server console on startup, if none are detected no worries, it will default to chat output.
3. Jump in-game and type `/playtime` to check your current playtime! 😊

### Detected notification resources: okokNotify, mythic_notify, QBCore, esx_notify


```
## -----------------------------------------------------------------------------------------------------------------------------------------------                                                     
## ██ ███    ███ ██████   ██████  ██████  ████████  █████  ███    ██ ████████ 
## ██ ████  ████ ██   ██ ██    ██ ██   ██    ██    ██   ██ ████   ██    ██    
## ██ ██ ████ ██ ██████  ██    ██ ██████     ██    ███████ ██ ██  ██    ██    
## ██ ██  ██  ██ ██      ██    ██ ██   ██    ██    ██   ██ ██  ██ ██    ██    
## ██ ██      ██ ██       ██████  ██   ██    ██    ██   ██ ██   ████    ██    
```                             
                                                                        
                                                                           
You must run the exe `storePlaytime.exe` each time you want to update playtime, its recommended to add it to the windows startup apps


## Troubleshooting
### I did not run into any of these but here you go
1. **Error: `ER_ACCESS_DENIED_ERROR`**
   - This error occurs if the MySQL user or password is incorrect.
   - Solution: Double-check the `user` and `password` fields in `config.json` and ensure they match the MySQL server.

2. **Error: `ENOTFOUND` or `ECONNREFUSED`**
   - This means the script is unable to connect to the MySQL server.
   - Solution: Ensure MySQL is running and the `host` in `config.json` is set to the correct IP address or hostname.

3. **Missing `config.json` File**
   - The executable won’t run without a valid `config.json`.
   - Solution: Make sure `config.json` is in the same directory as the executable and has the correct settings.

4. **No Playtime Data Processed**
   - If no data is processed, the `playersDB.json` file may be empty or not in the correct format.
   - Solution: Ensure the `dataFilePath` points to a valid JSON file with player data.

## FAQ
1. **Can I run this on a different operating system?**
   - Currently, the executable is built for Windows. If you need a Linux or macOS version, sorry..

2. **Does the executable support remote MySQL servers?**
   - Yes, you can use a remote MySQL server by updating the `host` field in `config.json` to the server’s IP address.

3. **Is the source code available?**
   - This executable is distributed as a standalone file, and the source code is not included.

## Contact
### For any questions or support, feel free to reach out, though i can't promise fast replies - @Tradie_ on discord
