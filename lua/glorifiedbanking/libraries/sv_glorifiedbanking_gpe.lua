
-- Edited version of GlorifiedPersistentEnts specifically for GlorifiedBanking.

GlorifiedBanking.GlorifiedPersistentEnts = {
    TableName = "GlorifiedBanking",
    Identifier = "glorifiedbanking_", -- No spaces. For usage in concommands.
    EntClasses = {
        ["glorifiedbanking_atm"] = true
    }
}

sql.Query( "CREATE TABLE IF NOT EXISTS `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "` ( `Class` VARCHAR(48) NOT NULL , `Map` VARCHAR(64) NOT NULL , `PosInfo` JSON NOT NULL )" )

function GlorifiedBanking.GlorifiedPersistentEnts.SaveEntityInfo( ent )
    if not GlorifiedBanking.GlorifiedPersistentEnts.EntClasses[ent:GetClass()] then return end
    local posInfoJSON = {
        Pos = ent:GetPos(),
        Angles = ent:GetAngles(),
        EntInfo = {
            WithdrawalFee = ent:GetWithdrawalFee(),
            DepositFee = ent:GetDepositFee(),
            TransferFee = ent:GetTransferFee(),
            SignText = ent:GetSignText()
        }
    }
    posInfoJSON = util.TableToJSON( posInfoJSON )
    if ent.GB_EntID != nil then
        sql.Query( "UPDATE `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "` SET `PosInfo` = '" .. posInfoJSON .. "' WHERE `RowID` = " .. ent.GB_EntID )
    else
        sql.Query( "INSERT INTO `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "` (`Class`, `Map`, `PosInfo`) VALUES ('" .. ent:GetClass() .. "', '" .. game.GetMap() .. "', '" .. posInfoJSON .. "')" )
        local lastRowID = sql.Query( "SELECT last_insert_rowid() AS last_insert" )[1].last_insert -- {{ user_id sha256 key }}
        ent.GB_EntID = lastRowID
    end
end

function GlorifiedBanking.GlorifiedPersistentEnts.RemoveEntityFromDB( ent )
    if not GlorifiedBanking.GlorifiedPersistentEnts.EntClasses[ent:GetClass()] then return end
    if ent.GB_EntID then
        print( "[GlorifiedBanking.GlorifiedPersistentEnts] Deleted Entity ID " .. ent.GB_EntID .. " from table `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "`" )
        sql.Query( "DELETE FROM `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "` WHERE `RowID` = " .. ent.GB_EntID )
        SafeRemoveEntity( ent )
    end
end

function GlorifiedBanking.GlorifiedPersistentEnts.LoadEntities()
    local queryResults = sql.Query( "SELECT * FROM `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "`" )
    if queryResults == nil or not istable( queryResults ) then return end
    for k, v in pairs( queryResults ) do
        if v["Map"] != game.GetMap() then continue end
        local gpeEntityInfo = util.JSONToTable( v["PosInfo"] )
        local gpeEntity = ents.Create( v["Class"] )
        gpeEntity:SetPos( gpeEntityInfo.Pos )
        gpeEntity:SetAngles( gpeEntityInfo.Angles )
        gpeEntity:SetWithdrawalFee( gpeEntityInfo.EntInfo.WithdrawalFee )
        gpeEntity:SetDepositFee( gpeEntityInfo.EntInfo.DepositFee )
        gpeEntity:SetTransferFee( gpeEntityInfo.EntInfo.TransferFee )
        gpeEntity:SetSignText( gpeEntityInfo.EntInfo.SignText )
        gpeEntity:Spawn()
        if gpeEntity:GetPhysicsObject():IsValid() then
            gpeEntity:GetPhysicsObject():EnableMotion( false )
        end
        gpeEntity.GB_EntID = k
    end
end

hook.Add( "PostCleanupMap", GlorifiedBanking.GlorifiedPersistentEnts.Identifier .. ".GPE.PostCleanupMap", function()
    GlorifiedBanking.GlorifiedPersistentEnts.LoadEntities()
end )

hook.Add( "OnPhysgunFreeze", GlorifiedBanking.GlorifiedPersistentEnts.Identifier .. ".GPE.OnPhysgunFreeze", function( wep, physObj, ent, ply )
    if GlorifiedBanking.GlorifiedPersistentEnts.EntClasses[ent:GetClass()] then
        GlorifiedBanking.GlorifiedPersistentEnts.SaveEntityInfo( ent )
    end
end )

hook.Add( "PhysgunDrop", GlorifiedBanking.GlorifiedPersistentEnts.Identifier .. ".GPE.PhysgunDrop", function( ply, ent )
    if GlorifiedBanking.GlorifiedPersistentEnts.EntClasses[ent:GetClass()] then
        GlorifiedBanking.GlorifiedPersistentEnts.SaveEntityInfo( ent )
    end
end )

hook.Add( "PlayerSpawnedSENT", GlorifiedBanking.GlorifiedPersistentEnts.Identifier .. ".GPE.PlayerSpawnedSENT", function( ply, ent )
    if GlorifiedBanking.GlorifiedPersistentEnts.EntClasses[ent:GetClass()] then
        GlorifiedBanking.GlorifiedPersistentEnts.SaveEntityInfo( ent )
    end
end )

hook.Add( "InitPostEntity", GlorifiedBanking.GlorifiedPersistentEnts.Identifier .. ".GPE.InitPostEntity", GlorifiedBanking.GlorifiedPersistentEnts.LoadEntities )

concommand.Add( GlorifiedBanking.GlorifiedPersistentEnts.Identifier .. "removeents", function( ply )
    if ply == NULL or ply:IsSuperAdmin() then
        print( "[GlorifiedBanking.GlorifiedPersistentEnts] Cleared table `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "`" )
        sql.Query( "DELETE FROM `" .. GlorifiedBanking.GlorifiedPersistentEnts.TableName .. "`")
        for k, v in pairs( GlorifiedBanking.GlorifiedPersistentEnts.EntClasses ) do
            for k2, v2 in pairs( ents.FindByClass( k ) ) do
                SafeRemoveEntity( v2 )
            end
        end
    end
end )

concommand.Add( GlorifiedBanking.GlorifiedPersistentEnts.Identifier .. "removeent", function( ply )
    if ply:IsSuperAdmin() then
        local lookingAtEnt = ply:GetEyeTrace().Entity
        if lookingAtEnt:IsValid() and GlorifiedBanking.GlorifiedPersistentEnts.EntClasses[lookingAtEnt:GetClass()] then
            GlorifiedBanking.GlorifiedPersistentEnts.RemoveEntityFromDB( lookingAtEnt )
        end
    end
end )
