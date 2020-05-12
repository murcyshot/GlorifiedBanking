
GlorifiedBanking.SQLQuery( "CREATE TABLE IF NOT EXISTS `gb_players`( `SteamID` VARCHAR(32) NOT NULL, `Balance` BIGINT(64) NOT NULL, `LastName` VARCHAR(64) NOT NULL , PRIMARY KEY( `SteamID` ) )" )

local startingBalance = GlorifiedBanking.Config.STARTING_BALANCE
hook.Add( "PlayerInitialSpawn", "GlorifiedBanking.SQLPlayer.PlayerInitialSpawn", function( ply )
    if ply:IsBot() then return end
    if not ply.GlorifiedBanking then ply.GlorifiedBanking = {} end
    GlorifiedBanking.SQLQuery( "SELECT * FROM `gb_players` WHERE `SteamID` = '" .. ply:SteamID() .. "' LIMIT 1", function( queryResult )
        if queryResult and table.IsEmpty( queryResult ) == false then
            ply.GlorifiedBanking.Balance = queryResult[1]["Balance"]
            ply:SetNWInt( "GlorifiedBanking.Balance", queryResult[1]["Balance"] )
            GlorifiedBanking.SQLQuery( "UPDATE `gb_players` SET `LastName` = '" .. GlorifiedBanking.SQLEscapeString( ply:Nick() ) .. "' WHERE `SteamID` = '" .. ply:SteamID() .. "'" )
        else
            ply.GlorifiedBanking.Balance = startingBalance
            ply:SetNWInt( "GlorifiedBanking.Balance", startingBalance )
            GlorifiedBanking.SQLQuery( "INSERT INTO `gb_players`( `SteamID`, `Balance`, `LastName` ) VALUES ( '" .. ply:SteamID() .. "', " .. startingBalance .. ", '" .. GlorifiedBanking.SQLEscapeString( ply:Nick() ) .. "' )" )
        end
    end )
end )