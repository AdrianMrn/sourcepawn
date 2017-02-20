#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <devzones>

new bool:nodamage[MAXPLAYERS+1];

public Plugin:myinfo =
{
	name = "arenazones",
	author = "Wulfy",
	description = "Edited version of SM DEV Zones - NoDamage by Franc1sco franug to do the exact opposite.",
	version = "0.1",
	url = "http://www.gamebait.net"
};

public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	nodamage[client] = true;
	CreateTimer(4.0, SpawnTimer, client);
}

public Action:SpawnTimer(Handle:timer, any:client)
{
	
	if (!IsClientInGame(client))
		return;
		
	nodamage[client] = true;
	
}

public Zone_OnClientEntry(client, String:zone[])
{
	if(StrContains(zone, "arena", false) != 0) return;
	
	nodamage[client] = false;
	PrintHintText(client, "You've entered an arena zone, godmode disabled!");
}

public Zone_OnClientLeave(client, String:zone[])
{
	if(StrContains(zone, "arena", false) != 0) return;
	
	nodamage[client] = true;
	PrintHintText(client, "You've left an arena zone, godmode enabled!");
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnTakeDamage(client, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if(!IsValidClient(attacker) || !IsValidClient(client)) return Plugin_Continue;
	
	if(nodamage[attacker] || nodamage[client])
	{
		//PrintHintText(attacker, "You can't hurt players in this zone!");
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public IsValidClient( client ) 
{ 
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
        return false; 
     
    return true; 
}