#pragma semicolon 1

#define PLUGIN_AUTHOR "Wulfy"
#define PLUGIN_VERSION "0.1"

#include <sourcemod>
#include <SteamWorks>

new Handle:g_hibernate;
new Handle:g_updateAvailable;
new Handle:g_delayUpdate;

public Plugin myinfo = 
{
	name = "updaterestart",
	author = PLUGIN_AUTHOR,
	description = "Clears and shuts the server down when an update's available.",
	version = PLUGIN_VERSION,
	url = "http://gamebait.net/"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_stopupdate", Command_StopUpdate, ADMFLAG_GENERIC);
	RegAdminCmd("sm_update", Command_Update, ADMFLAG_GENERIC);
	
	g_updateAvailable = CreateConVar("update_available", "0", "0 = No update is available, 1 = Update is available");
	g_delayUpdate = CreateConVar("update_delay", "0", "0 = Update has not been delayed, 1 = Update has been delayed");
	
	//The plugin won't run if the server is in hibernation. Bad for RAM usage though.
	g_hibernate = FindConVar("sv_hibernate_when_empty");
	SetConVarInt(g_hibernate, 0, false, false);
}

public OnMapStart() {
	SetConVarInt(g_delayUpdate, 0, false, false);
	
	if (GetConVarInt(g_updateAvailable) == 1)
		RestartServer();
}

public Action:SteamWorks_RestartRequested() {
	CheckClients(0, 0);
}

public Action:Command_StopUpdate(client, args)
{
	SetConVarInt(g_delayUpdate, 1, false, false);
	PrintToChat(client, "\x01[SM] You have delayed the update by 10 minutes. You can type \x04!update \x01to resume it now.");
	PrintToChatAll("\x01[SM] \x04The update has been delayed by 10 minutes by an admin.");
	CreateTimer(600.0, ResumeUpdate);
}

public Action:Command_Update(client, args)
{
	SetConVarInt(g_delayUpdate, 0, false, false);
	CheckClients(0, 0);
}

public Action:ResumeUpdate(Handle timer)
{
	SetConVarInt(g_delayUpdate, 0, false, false);
	CheckClients(0, 0);
}

public Action:CheckClients(int client, int args){
	SetConVarInt(g_updateAvailable, 1);
	//Checking if there are players on the server. If there are, kick them all.
	new playerCount = GetClientCount(false);
	if (playerCount)
	{
		EmptyTheServer();
	}
	else
	{
		RestartServer();
	}
}

public Action:EmptyTheServer(){
	CreateTimer(0.1, UpdateSpam);
	CreateTimer(30.0, UpdateSpam);
	CreateTimer(60.0, KickAll);
}

public Action:RestartServer(){
	ServerCommand("_restart");
}

public Action:UpdateSpam(Handle timer) {
	if (GetConVarInt(g_delayUpdate) == 0)
	{
		for (new i = 0; i < 3; i++)
		{
			PrintToChatAll("\x01[SM] \x04A server update is imminent\x01, everyone will be kicked from the server within a minute. An admin can type \x04!stopupdate \x01to delay the update.");
		}
		PrintToServer("[SM] A server update is imminent, everyone will be kicked from the server within a minute. An admin can type stopupdate to delay the update.");
		PrintCenterTextAll("A server update is imminent, everyone will be kicked from the server within a minute. An admin can type stopupdate to delay the update.");
	}
}

public Action:KickAll(Handle Timer) {
	if (GetConVarInt(g_delayUpdate) == 0)
	{
		for (int i; i < MaxClients; i++)
		{
	    	if (!IsClientConnected(i) || IsFakeClient(i))
		        continue;
		
	        KickClient(i, "The server is updating. Rejoin in 3 minutes");
		}  
		RestartServer();
	}
}