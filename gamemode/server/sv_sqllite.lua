function BOTCHED.FUNC.SQLQuery( queryStr, func, singleRow )
	local query
	if( not singleRow ) then
		query = sql.Query( queryStr )
	else
		query = sql.QueryRow( queryStr, 1 )
	end
	
	if( query == false ) then
		print( "[Botched SQLLite] ERROR", sql.LastError() )
	elseif( func ) then
		func( query )
	end
end

-- PLAYERS --
if( not sql.TableExists( "botched_players" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_players ( 
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
	); ]] )
end

-- PLAYERMODELS --
if( not sql.TableExists( "botched_owned_characters" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_owned_characters ( 
		userID int NOT NULL,
		characterKey varchar(25) NOT NULL
	); ]] )
end

-- EQUIPMENT --
if( not sql.TableExists( "botched_owned_equipment" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_owned_equipment (
		userID int NOT NULL,
		equipmentKey varchar(20) NOT NULL,
		stars int,
		rank int
	); ]] )
end

-- CHOSEN EQUIPMENT --
if( not sql.TableExists( "botched_chosen_equipment" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_chosen_equipment ( 
		userID int NOT NULL,
		primaryWeapon varchar(20),
		secondaryWeapon varchar(20),
		pickaxe varchar(20),
		hatchet varchar(20),
		trinket1 varchar(20),
		trinket2 varchar(20),
		armour varchar(20)
	); ]] )
end

-- INVENTORY --
if( not sql.TableExists( "botched_inventory" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_inventory (
		userID int NOT NULL,
		itemKey varchar(20) NOT NULL,
		amount int
	); ]] )
end

-- QUESTS --
if( not sql.TableExists( "botched_completed_quests" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_completed_quests (
		userID int NOT NULL,
		questLineKey int NOT NULL,
		questKey int NOT NULL,
		completionStars int
	); ]] )
end

-- TIME REWARDS --
if( not sql.TableExists( "botched_claimed_timerewards" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_claimed_timerewards (
		userID int NOT NULL,
		rewardKey int NOT NULL,
		claimTime int NOT NULL
	); ]] )
end

-- LOGIN REWARDS --
if( not sql.TableExists( "botched_claimed_loginrewards" ) ) then
	BOTCHED.FUNC.SQLQuery( [[ CREATE TABLE botched_claimed_loginrewards (
		userID int NOT NULL,
		daysClaimed int NOT NULL,
		claimTime int NOT NULL
	); ]] )
end

MsgC(Color( 0, 255, 0 ), "[Botched SQL] Loaded SQLLite module successfully!\n")