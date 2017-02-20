#pragma semicolon 1

#define PLUGIN_AUTHOR "Wulfy"
#define PLUGIN_VERSION "0.2"

#include <sourcemod>
#include <SteamWorks>

new Handle:g_tags;
new Handle:g_password;
new Handle:g_hibernate;
new Handle:g_updateAvailable;

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
	//Testing command (clears server)
	RegConsoleCmd("kickall", CheckClients);
	
	g_updateAvailable = CreateConVar("update_available", "0", "0 = No update is available, 1 = Update is available");
	
	g_tags = FindConVar("sv_tags");
	g_password = FindConVar("sv_password");
	
	//The plugin won't run if the server is in hibernation. Bad for RAM usage though.
	g_hibernate = FindConVar("sv_hibernate_when_empty");
	SetConVarInt(g_hibernate, 0, false, false);
}

public bool:OnClientConnect(client, String:rejectmsg[], maxlen){
	if (GetConVarInt(g_updateAvailable) == 1)
	{
		Format(rejectmsg, maxlen, "The server is updating. Rejoin in 5 minutes.");
		return false;
	}
	else
	{
		return true;
	}
}

public OnMapStart() {
	if (GetConVarInt(g_updateAvailable) == 1)
		SetUpdateConVars();
}

public Action:SteamWorks_RestartRequested() {
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
		SetUpdateConVars();
	}
}

public Action:EmptyTheServer(){
	UpdateSpam();
	CreateTimer(15.0, KickAll);
}

public Action:SetUpdateConVars(){
	SetConVarString(g_tags, "update", false, false);
	SetConVarString(g_password, "UpdateInc", false, false);
}

public Action:UpdateSpam() {
	for (new i = 0; i < 10; i++)
	{
		PrintToChatAll("A server update is imminent, everyone will be kicked from the server in 15 seconds.");
	}
	PrintToServer("A server update is imminent, everyone will be kicked from the server in 15 seconds.");
	PrintCenterTextAll("A server update is imminent, everyone will be kicked from the server in 15 seconds.");
}

public Action:KickAll(Handle Timer) {
	for (new i = 1; i <= 64; i++)
	{
	    if ((!IsFakeClient(i)) && IsClientConnected(i))
	    {
	        KickClient(i, "The server is updating. Rejoin in 5 minutes.");
	    }
	}
	
	SetUpdateConVars();
}