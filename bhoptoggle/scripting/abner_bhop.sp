#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#pragma newdecls required // 2015 rules 
#define PLUGIN_VERSION "2.0"

Bhop[MAXPLAYERS+1];
Handle hBhop;
Handle hAutoBhop;
bool CSGO;
int WATER_LIMIT;

public Plugin myinfo =
{
	name = "[CSS/CS:GO] AbNeR Bunny Hoping - Toggle",
	author = "AbNeR_CSS - Edited by Wulfy",
	description = "Auto BHOP",
	version = PLUGIN_VERSION,
	url = "www.tecnohardclan.com"
}

public void OnPluginStart()
{       
	AutoExecConfig(true, "abnerbhop");
	CreateConVar("abnerbhop_version", PLUGIN_VERSION, "Bhop Version", FCVAR_NOTIFY|FCVAR_REPLICATED);
	hBhop = CreateConVar("abner_bhop", "1", "Enable/disable Plugin", FCVAR_NOTIFY|FCVAR_REPLICATED);
	hAutoBhop = CreateConVar("abner_autobhop", "1", "Enable/Disable AutoBhop", FCVAR_NOTIFY|FCVAR_REPLICATED);
	
	RegConsoleCmd("sm_bhop", Command_bhop, "Toggle bhop");
 
	char theFolder[40];
	GetGameFolderName(theFolder, sizeof(theFolder));
	CSGO = StrEqual(theFolder, "csgo");
	(CSGO) ? (WATER_LIMIT = 2) : (WATER_LIMIT = 1);
}

public void OnConfigsExecuted()
{
	if(GetConVarInt(hBhop) == 1) BhopOn();
}

public void OnClientPutInServer(int client)
{
	Bhop[client] = false;

	if(!CSGO) // To boost in CSGO use together https://forums.alliedmods.net/showthread.php?t=244387
		SDKHook(client, SDKHook_PreThink, PreThink); //This make you fly in CSS;
}

public Action PreThink(int client)
{
	if(IsValidClient(client) && IsPlayerAlive(client) && GetConVarInt(hBhop) == 1)
	{
		SetEntPropFloat(client, Prop_Send, "m_flStamina", 0.0); 
	}
}

void BhopOn()
{
	if(!CSGO)
	{
		SetCvar("sv_enablebunnyhopping", "1");
		SetCvar("sv_airaccelerate", "15");
	}
	else 
	{
		SetCvar("sv_enablebunnyhopping", "1"); 
		SetCvar("sv_staminamax", "0");
		SetCvar("sv_airaccelerate", "15");
		SetCvar("sv_staminajumpcost", "0");
		SetCvar("sv_staminalandcost", "0");
	}
}

stock void SetCvar(char[] scvar, char[] svalue)
{
	Handle cvar = FindConVar(scvar);
	SetConVarString(cvar, svalue, true);
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if(Bhop[client])
		if(GetConVarInt(hBhop) == 1 && GetConVarInt(hAutoBhop) == 1) //Check if plugin and autobhop is enabled
			if (IsPlayerAlive(client) && buttons & IN_JUMP) //Check if player is alive and is in pressing space
				if(!(GetEntityMoveType(client) & MOVETYPE_LADDER) && !(GetEntityFlags(client) & FL_ONGROUND)) //Check if is not in ladder and is in air
					if(waterCheck(client) < WATER_LIMIT)
						buttons &= ~IN_JUMP; 
	return Plugin_Continue;
}

int waterCheck(int client)
{
	return GetEntProp(client, Prop_Data, "m_nWaterLevel");
}

stock bool IsValidClient(int client)
{
	if(client <= 0 ) return false;
	if(client > MaxClients) return false;
	if(!IsClientConnected(client)) return false;
	return IsClientInGame(client);
}

public Action Command_bhop(int client, int args)
{
	if(!IsValidClient(client))
	{
		return Plugin_Handled;
	}
	
	int target = client;
	
	if(IsValidClient(target))
	{
		Toggle(target);
		ReplyToCommand(client, " \x04[SM]\x01 Bhop toggled.");
		
		return Plugin_Handled;
	}
	
	else if(!IsPlayerAlive(target))
	{
		ReplyToCommand(client, " \x04[SM]\x01 You have to be alive to toggle bhop.");
		
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Toggle(int client)
{
	if(!Bhop[client])
	{
		Bhop[client] = true;
	}
	
	else
	{
		Bhop[client] = false;
	}
}

