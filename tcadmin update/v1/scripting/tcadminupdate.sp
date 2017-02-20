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
