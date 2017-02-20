#include <sourcemod>
#include <sdktools>

public Plugin:myinfo =
{
	name = "teleport",
	author = "Wulfy",
	description = "Teleport to coordinates.",
	version = "1.0",
	url = "http://www.gamebait.net"
}
 
public OnPluginStart()
{
	RegAdminCmd("sm_disco", Command_Disco, ADMFLAG_GENERIC);
	RegAdminCmd("sm_disco", Command_Disco, ADMFLAG_CUSTOM2);

	RegAdminCmd("sm_skybox", Command_Skybox, ADMFLAG_GENERIC);
	RegAdminCmd("sm_skybox", Command_Skybox, ADMFLAG_CUSTOM2);
	
	RegAdminCmd("sm_arena", Command_Arena, 0);
	
	RegAdminCmd("sm_surf", Command_Surf, 0);
	
	RegAdminCmd("sm_bhop", Command_Bhop, 0);

	RegAdminCmd("sm_traderooms", Command_Traderooms, 0);
	
	RegAdminCmd("sm_screenshots", Command_Screenshots, 0);
	
	RegAdminCmd("sm_town", Command_Town, 0);
	
	RegAdminCmd("sm_knifearena", Command_Knifearena, 0);
	
}

public Action:Command_Disco(client, args)
{
	new Float:hwLoc[3] = {2494.695801, -425.405304, 580.093811};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Knifearena(client, args)
{
	new Float:hwLoc[3] = {-1872.70704, -1588.73011, -23.51496};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Town(client, args)
{
	new Float:hwLoc[3] = {112.480110, -411.220764, 336.093811};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Screenshots(client, args)
{
	new Float:hwLoc[3] = {11495.843750, -11005.592773, -979.906189};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Arena(client, args)
{
	new Float:hwLoc[3] = {5489.221680, 529.345886, 72.093811};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Skybox(client, args)
{
	new Float:hwLoc[3] = {7491.47, -9189.92, 2522.26};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Surf(client, args)
{
	new Float:hwLoc[3] = {14615.706055, 6297.798340, -3419.906250};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Bhop(client, args)
{
	new Float:hwLoc[3] = {9411.472656, -1352.929688, -9467.906250};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}

public Action:Command_Traderooms(client, args)
{
	new Float:hwLoc[3] = {-721.146179, -2246.814453, 70.403297};
	TeleportEntity(client, hwLoc, NULL_VECTOR, NULL_VECTOR);
	return Plugin_Handled;
}