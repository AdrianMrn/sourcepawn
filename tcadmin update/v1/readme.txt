
http://help.tcadmin.com/Service_Browser#Commandline_Parameters
	To stop a server: ./servicebrowser -service=2 -command=stop
	
	
http://help.tcadmin.com/Query_Monitoring
	Game monitor queries the service every 5 minutes (by default, see Query Interval) to see if any settings, and which, have changed.

	
--> http://151.80.109.201:8880/Interface/GameHosting/GameQueryMonitoring.aspx?gameid=97
	Rule Detection: Create a Sourcepawn plugin that changes a convar (updateavailable = 0 --> = 1) when the server gets an update request.

	
https://forums.alliedmods.net/showthread.php?t=282095
	Possible plugin (NEEDS sv_hibernate_when_empty 0 !!)

#pragma semicolon 1

#define PLUGIN_AUTHOR "Wulfy"
#define PLUGIN_VERSION "0.1"

#include <sourcemod>
#include <SteamWorks>

new Handle:updateAvailable;

public Plugin myinfo = 
{
	name = "tcadminupdate",
	author = PLUGIN_AUTHOR,
	description = "A plugin used to trigger a game update in TCAdmin",
	version = PLUGIN_VERSION,
	url = "http://gamebait.net/"
};

public void OnPluginStart()
{
	updateAvailable = CreateConVar("update_available", "0", "0 = No update is available, 1 = Update is available");
	SetConVarInt(updateAvailable, 0);
}

public Action:SteamWorks_RestartRequested() {
	SetConVarInt(updateAvailable, 1);
}

