#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin myinfo =
{
	name = "Weapon Swapper",
	author = "Wulfy (original by Neuro Toxin)",
	description = "Allows players to give, take and swap weapons and knives with each other! Original plugin by Neuro Toxin.",
	version = "1.0",
	url = "www.gamebait.net"
}

public void OnPluginStart()
{
	HookEvent("round_start", OnPostRoundStart, EventHookMode_PostNoCopy);
}

public Action:OnPostRoundStart(Handle event, const char[] name, bool dontBroadcast) {
	for (new i = 1; i <= 64; i++)
	{
	    if ((!IsFakeClient(i)) && IsClientConnected(i))
	    {
	    	ClearWeapons(i);
	    }
	}
}
public Action:ClearWeapons(int client) {
	//Primary
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	if (weapon != -1)
	{
		RemovePlayerItem(client, weapon);
	}
	
	//Secondary
	weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
	if (weapon != -1)
	{
		RemovePlayerItem(client, weapon);
	}
	
	//Knife
	weapon = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	if (weapon != -1)
	{
		RemovePlayerItem(client, weapon);
	}
	
	//Grenade
	//weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
	//if (weapon != -1)
	//{
	//	RemovePlayerItem(client, weapon);
	//}
}