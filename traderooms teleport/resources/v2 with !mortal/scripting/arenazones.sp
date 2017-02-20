#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <devzones>

new bool:nodamage[MAXPLAYERS+1];
new bool:isinzone[MAXPLAYERS+1];

public Plugin:myinfo =
{
	name = "arenazones",
	author = "Wulfy",
	description = "Edited version of SM DEV Zones - NoDamage by Franc1sco franug to do the exact opposite.",
	version = "1.0",
	url = "http://www.gamebait.net"
}

public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);
	
	RegAdminCmd("sm_god", Command_God, 0, "Toggles Godmode on yourself");
	RegAdminCmd("sm_mortal", Command_Mortal, 0, "Turns yourself mortal");
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	nodamage[client] = true;
	isinzone[client] = false;
	
	PrintToChat(client,"\x01[SM] \x04Godmode enabled! \x01You can type \x04!mortal \x01to disable it!");
	CreateTimer(4.0, SpawnTimer, client);
}

public Action:SpawnTimer(Handle:timer, any:client)
{
	
	if (!IsClientInGame(client))
		return;
		
	nodamage[client] = true;
	
}

public Action:Command_God(client, args)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || isinzone[client])
	{
		return Plugin_Handled;
	}
	
	if (!nodamage[client])
	{
		nodamage[client] = true;
		PrintToChat(client,"\x01[SM] \x04Godmode enabled");
		return Plugin_Handled;
	}
	
	nodamage[client] = false;
	PrintToChat(client,"\x01[SM] \x04Godmode disabled");
	return Plugin_Handled;
}

public Action:Command_Mortal(client, args)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || !nodamage[client])
	{
		return Plugin_Handled;
	}
	
	nodamage[client] = false;
	PrintToChat(client,"\x01[SM] \x04Godmode disabled");
	return Plugin_Handled;
}

public Zone_OnClientEntry(client, String:zone[])
{
	if(StrContains(zone, "arena", false) != 0) return;
	isinzone[client] = true;
	
	if (!nodamage[client]) return;
	
	nodamage[client] = false;
	PrintToChat(client, "\x01[SM] You've entered an arena zone, \x04Godmode disabled!");
}

public Zone_OnClientLeave(client, String:zone[])
{
	if(StrContains(zone, "arena", false) != 0) return;
	
	nodamage[client] = true;
	isinzone[client] = false;
	PrintToChat(client, "\x01[SM] You've left an arena zone, \x04Godmode enabled!");
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnTakeDamage(client, &attacker, &inflictor, &Float:damage, &damagetype)
{
	//If fall damage should be enabled when godmode is off, use this instead: "if (attacker == 0 && nodamage[client]) return Plugin_Handled;"
	if (attacker == 0) return Plugin_Handled;
	
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