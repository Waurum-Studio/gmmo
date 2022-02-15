// Import module
require('mysqloo')

// Edit those to fit your needs
local BotchedMySQL = {
    ["Host"] = "127.0.0.1",
    ["Username"] = "gmod_sql",
    ["Password"] = "user_password",
    ["Database"] = "gmod_database",
    ["Port"] = 3306
} 

// Contains all needed SQL tables + their structure
local BotchedSQLTables = {
    ["botched_players"] = [[ CREATE TABLE IF NOT EXISTS botched_players ( 
		userID INTEGER PRIMARY KEY AUTOINCREMENT,
		steamID64 varchar(20) NOT NULL UNIQUE,
		stamina int,
		gems int,
		mana int,
		magicCoins int,
		level int,
		experience int,
		timePlayed int,
		lastPlayed int,
		character varchar(25)
	); ]],
    ["botched_owned_characters"] = [[ CREATE TABLE IF NOT EXISTS botched_owned_characters ( 
		userID int NOT NULL,
		characterKey varchar(25) NOT NULL
	); ]],
    ["botched_owned_equipment"] = [[ CREATE TABLE IF NOT EXISTS botched_owned_equipment (
		userID int NOT NULL,
		equipmentKey varchar(20) NOT NULL,
		stars int,
		rank int
	); ]],
    ["botched_chosen_equipment"] = [[ CREATE TABLE IF NOT EXISTS botched_chosen_equipment ( 
		userID int NOT NULL,
		primaryWeapon varchar(20),
		secondaryWeapon varchar(20),
		pickaxe varchar(20),
		hatchet varchar(20),
		trinket1 varchar(20),
		trinket2 varchar(20),
		armour varchar(20)
	); ]],
    ["botched_inventory"] = [[ CREATE TABLE IF NOT EXISTS botched_inventory (
		userID int NOT NULL,
		itemKey varchar(20) NOT NULL,
		amount int
	); ]],
    ["botched_completed_quests"] = [[ CREATE TABLE IF NOT EXISTS botched_completed_quests (
		userID int NOT NULL,
		questLineKey int NOT NULL,
		questKey int NOT NULL,
		completionStars int
	); ]],
    ["botched_claimed_timerewards"] = [[ CREATE TABLE IF NOT EXISTS botched_claimed_timerewards (
		userID int NOT NULL,
		rewardKey int NOT NULL,
		claimTime int NOT NULL
	); ]],
    ["botched_claimed_loginrewards"] = [[ CREATE TABLE IF NOT EXISTS botched_claimed_loginrewards (
		userID int NOT NULL,
		daysClaimed int NOT NULL,
		claimTime int NOT NULL
	); ]],
}

// Initialize BOTCHED_DB object and attempt connecting to DB
local function BotchedSqlConnection()
    BOTCHED_DB = mysqloo.connect(
        BotchedMySQL["Host"],
        BotchedMySQL["Username"],
        BotchedMySQL["Password"],
        BotchedMySQL["Database"],
        BotchedMySQL["Port"]
    )
    BOTCHED_DB.onConnected = function() print("[Botched SQL] Successfully connected to database!") end
    BOTCHED_DB.onConnectionFailed = function(database, error)
        print("[Botched SQL] Connection to database failed!")
        print("[Botched SQL] Error: " .. error)
    end
    BOTCHED_DB:connect()

    BotchedSqlInitialize(BOTCHED_DB)
end
BotchedSqlConnection()

// Initialize the database content if it's empty 
local function BotchedSqlInitialize(db)
    for k,v in pairs(BotchedSQLTables) do
        local newQuery = db:query(v)

        function newQuery:onSuccess(data)
            print("[Botched SQL] " .. k .. " table initialized!")
        end
        function newQuery:onError(error)
            print("[Botched SQL] Error: " .. error)
        end

        newQuery:start()
    end
end

/*
    Botched - MySQL query function
*/
function BOTCHED.FUNC.SQLQuery(query, func, singleRow)
	local newQuery = BOTCHED_DB:query(query)

    if (func) then
        function newQuery:onSuccess(data)
            data = data or {}

            if (singleRow) then
                data = data[1] or {}
            end
        end
    end
    function newQuery:onError(error)
         print("[Botched SQL] Error: " .. error)
    end

    newQuery:start()
end

MsgC(Color( 0, 255, 0 ), "[Botched SQL] Loaded MySQLoo module successfully!\n")