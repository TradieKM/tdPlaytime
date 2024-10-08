const mysql = require('mysql');
const fs = require('fs');

// Use an environment variable to get the path of the config file, or default to './config.json'
const configPath = process.env.CONFIG_PATH || './config.json';
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

// MySQL connection setup
const connection = mysql.createConnection({
    host: config.database.host,
    user: config.database.user,
    password: config.database.password,
    database: config.database.database
});

console.log('Attempting to connect to the MySQL database...');
connection.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL!');

    // Now that we're connected, create the table with id and unique constraints
    console.log('Checking or creating the table if not exists...');
    connection.query(`CREATE TABLE IF NOT EXISTS player_playtimes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        license VARCHAR(50) UNIQUE NOT NULL,
        playtime INT DEFAULT 0 NOT NULL
    )`, (err, result) => {
        if (err) throw err;
        console.log('Table created or already exists.');

        // After ensuring the table is created, process the JSON file
        processJSON();
    });
});

// Function to read and process the JSON file
function processJSON() {
    console.log('Reading data from the JSON file...');
    fs.readFile(config.dataFilePath, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading the JSON file:', err);
            return;
        }

        try {
            const jsonData = JSON.parse(data);
            let totalPlayers = jsonData.players.length;
            let processedCount = 0;

            jsonData.players.forEach(player => {
                const license = player.license;
                const playTime = player.playTime;

                console.log(`Inserting/updating data for license: ${license}, playtime: ${playTime}...`);

                // Insert or update playtime in the SQL database
                connection.query(
                    `INSERT INTO player_playtimes (license, playtime) VALUES (?, ?)
                    ON DUPLICATE KEY UPDATE playtime = ?`,
                    [license, playTime, playTime],
                    (err, results) => {
                        if (err) {
                            console.error('Error inserting/updating data:', err);
                        } else {
                            processedCount++;
                            if (processedCount === totalPlayers) {
                                console.log('Data processed and stored successfully.');
                                // Close the connection after all queries are done
                                console.log('Closing MySQL connection...');
                                connection.end((err) => {
                                    if (err) {
                                        console.error('Error closing the MySQL connection:', err);
                                    } else {
                                        console.log('MySQL connection closed.');
                                    }
                                });
                            }
                        }
                    }
                );
            });
        } catch (err) {
            console.error('Error parsing JSON:', err);
        }
    });
}
