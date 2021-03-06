#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include openwarfare\_utils;

init()
{
	// Is player able to select all allowed weapons (unranked classes) or only the ones he has unlocked (ranked classes)
	level.rankedClasses = getdvarx( "scr_ranked_classes_enable", "int", 1, 0, 1 );
	
	// how many default classes are enabled (0 they are hidden and disabled, so only custom classes can be selected,
	// n=1-5, from the 1st to the nth default classes are displayed and enabled)
	level.classes_default_enable = getdvarx( "classes_default_enable", "int", 5, 0, 5 );
	// are custom classes enabled or user only gets default classes?
	level.classes_custom_enable = getdvarx( "classes_custom_enable", "int", 1, 0, 1 );
	
	// making sure players have at least some classes to pickup, or they can't play at all
	if( level.classes_default_enable == 0 )
		level.classes_custom_enable = 1;
	if( level.classes_default_enable == 0 && level.classes_custom_enable == 0 )
		level.classes_default_enable = 5;
	
	// Load allowed perks
	level.perk_allow_c4_mp = getdvarx( "perk_allow_c4_mp", "int", 1, 0, 1 );
	level.perk_allow_specialty_specialgrenade = getdvarx( "perk_allow_specialty_specialgrenade", "int", 1, 0, 1 );
	level.perk_allow_rpg_mp = getdvarx( "perk_allow_rpg_mp", "int", 0, 0, 1 );
	level.perk_allow_claymore_mp = getdvarx( "perk_allow_claymore_mp", "int", 0, 0, 1 );
	level.perk_allow_specialty_fraggrenade = getdvarx( "perk_allow_specialty_fraggrenade", "int", 1, 0, 1 );
	level.perk_allow_specialty_extraammo = getdvarx( "perk_allow_specialty_extraammo", "int", 1, 0, 1 );
	level.perk_allow_specialty_detectexplosive = getdvarx( "perk_allow_specialty_detectexplosive", "int", 1, 0, 1 );
	
	level.perk_allow_specialty_bulletdamage = getdvarx( "perk_allow_specialty_bulletdamage", "int", 1, 0, 1 );
	level.perk_allow_specialty_armorvest = getdvarx( "perk_allow_specialty_armorvest", "int", 0, 0, 1 );
	level.perk_allow_specialty_fastreload = getdvarx( "perk_allow_specialty_fastreload", "int", 1, 0, 1 );
	level.perk_allow_specialty_rof = getdvarx( "perk_allow_specialty_rof", "int", 1, 0, 1 );
	level.perk_allow_specialty_twoprimaries = getdvarx( "perk_allow_specialty_twoprimaries", "int", 1, 0, 1 );
	level.perk_allow_specialty_gpsjammer = getdvarx( "perk_allow_specialty_gpsjammer", "int", 1, 0, 1 );
	level.perk_allow_specialty_explosivedamage = getdvarx( "perk_allow_specialty_explosivedamage", "int", 1, 0, 1 );
	
	level.perk_allow_specialty_longersprint = getdvarx( "perk_allow_specialty_longersprint", "int", 1, 0, 1 );
	level.perk_allow_specialty_bulletaccuracy = getdvarx( "perk_allow_specialty_bulletaccuracy", "int", 1, 0, 1 );
	level.perk_allow_specialty_pistoldeath = getdvarx( "perk_allow_specialty_pistoldeath", "int", 0, 0, 1 );
	level.perk_allow_specialty_grenadepulldeath = getdvarx( "perk_allow_specialty_grenadepulldeath", "int", 0, 0, 1 );
	level.perk_allow_specialty_bulletpenetration = getdvarx( "perk_allow_specialty_bulletpenetration", "int", 1, 0, 1 );
	level.perk_allow_specialty_holdbreath = getdvarx( "perk_allow_specialty_holdbreath", "int", 1, 0, 1 );
	level.perk_allow_specialty_quieter = getdvarx( "perk_allow_specialty_quieter", "int", 1, 0, 1 );
	level.perk_allow_specialty_parabolic = getdvarx( "perk_allow_specialty_parabolic", "int", 1, 0, 1 );
	
	// Load allowed classes
	// Warning: TODO limitation
	level.limitClasses = getdvarx( "classes_limit_enable", "int", 0, 0, 1 );
	level.class_allies_assault_limit = getdvarx( "class_allies_assault_limit", "int", 64, 0, 64 );
	level.class_allies_specops_limit = getdvarx( "class_allies_specops_limit", "int", 64, 0, 64 );
	level.class_allies_heavygunner_limit = getdvarx( "class_allies_heavygunner_limit", "int", 64, 0, 64 );
	level.class_allies_demolitions_limit = getdvarx( "class_allies_demolitions_limit", "int", 64, 0, 64 );
	level.class_allies_sniper_limit = getdvarx( "class_allies_sniper_limit", "int", 64, 0, 64 );
	
	level.class_axis_assault_limit = getdvarx( "class_axis_assault_limit", "int", 64, 0, 64 );
	level.class_axis_specops_limit = getdvarx( "class_axis_specops_limit", "int", 64, 0, 64 );
	level.class_axis_heavygunner_limit = getdvarx( "class_axis_heavygunner_limit", "int", 64, 0, 64 );
	level.class_axis_demolitions_limit = getdvarx( "class_axis_demolitions_limit", "int", 64, 0, 64 );
	level.class_axis_sniper_limit = getdvarx( "class_axis_sniper_limit", "int", 64, 0, 64 );
	
	// at least one class type must be enabled for onlineClasses, else player can't select anything
	if ( level.limitClasses && (level.class_allies_assault_limit + level.class_allies_specops_limit + level.class_allies_heavygunner_limit + level.class_allies_demolitions_limit + level.class_allies_sniper_limit) == 0 )
		level.class_allies_assault_limit = 64;
		
	if ( level.limitClasses && (level.class_axis_assault_limit + level.class_axis_specops_limit + level.class_axis_heavygunner_limit + level.class_axis_demolitions_limit + level.class_axis_sniper_limit) == 0 )
		level.class_axis_assault_limit = 64;
		
	// Fill primary weapon magazine (full ammo). Useful for promod compatibility
	level.fillWeaponMags = getdvarx( "scr_weapon_fillmags", "int", 0, 0, 1 );
	
	// Load allowed weapons
	level.weap_allow_assault_m16 = getdvarx( "weap_allow_assault_m16", "int", 1, 0, 1 );
	level.weap_allow_assault_ak47 = getdvarx( "weap_allow_assault_ak47", "int", 1, 0, 1 );
	level.weap_allow_assault_m4 = getdvarx( "weap_allow_assault_m4", "int", 1, 0, 1 );
	level.weap_allow_assault_g3 = getdvarx( "weap_allow_assault_g3", "int", 1, 0, 1 );
	level.weap_allow_assault_g36c = getdvarx( "weap_allow_assault_g36c", "int", 1, 0, 1 );
	level.weap_allow_assault_m14 = getdvarx( "weap_allow_assault_m14", "int", 1, 0, 1 );
	level.weap_allow_assault_mp44 = getdvarx( "weap_allow_assault_mp44", "int", 1, 0, 1 );
	level.weap_allow_specops_mp5 = getdvarx( "weap_allow_specops_mp5", "int", 1, 0, 1 );
	level.weap_allow_specops_skorpion = getdvarx( "weap_allow_specops_skorpion", "int", 1, 0, 1 );
	level.weap_allow_specops_uzi = getdvarx( "weap_allow_specops_uzi", "int", 1, 0, 1 );
	level.weap_allow_specops_ak74u = getdvarx( "weap_allow_specops_ak74u", "int", 1, 0, 1 );
	level.weap_allow_specops_p90 = getdvarx( "weap_allow_specops_p90", "int", 1, 0, 1 );
	level.weap_allow_heavygunner_saw = getdvarx( "weap_allow_heavygunner_saw", "int", 0, 0, 1 );
	level.weap_allow_heavygunner_rpd = getdvarx( "weap_allow_heavygunner_rpd", "int", 0, 0, 1 );
	level.weap_allow_heavygunner_m60e4 = getdvarx( "weap_allow_heavygunner_m60e4", "int", 0, 0, 1 );
	level.weap_allow_demolitions_winchester1200 = getdvarx( "weap_allow_demolitions_winchester1200", "int", 1, 0, 1 );
	level.weap_allow_demolitions_m1014 = getdvarx( "weap_allow_demolitions_m1014", "int", 1, 0, 1 );
	level.weap_allow_sniper_m40a3 = getdvarx( "weap_allow_sniper_m40a3", "int", 1, 0, 1 );
	level.weap_allow_sniper_m21 = getdvarx( "weap_allow_sniper_m21", "int", 1, 0, 1 );
	level.weap_allow_sniper_dragunov = getdvarx( "weap_allow_sniper_dragunov", "int", 1, 0, 1 );
	level.weap_allow_sniper_remington700 = getdvarx( "weap_allow_sniper_remington700", "int", 1, 0, 1 );
	level.weap_allow_sniper_barrett = getdvarx( "weap_allow_sniper_barrett", "int", 1, 0, 1 );
	
	level.weap_allow_beretta = getdvarx( "weap_allow_beretta", "int", 1, 0, 1 );
	level.weap_allow_usp = getdvarx( "weap_allow_usp", "int", 1, 0, 1 );
	level.weap_allow_colt45 = getdvarx( "weap_allow_colt45", "int", 1, 0, 1 );
	level.weap_allow_deserteagle = getdvarx( "weap_allow_deserteagle", "int", 1, 0, 1 );
	level.weap_allow_deserteaglegold = getdvarx( "weap_allow_deserteaglegold", "int", 1, 0, 1 );
	
	// Load allowed grenade types
	level.weap_allow_frag_grenade = getdvarx( "weap_allow_frag_grenade", "int", 1, 0, 1 );
	level.weap_allow_concussion_grenade = getdvarx( "weap_allow_concussion_grenade", "int", 1, 0, 1 );
	level.weap_allow_flash_grenade = getdvarx( "weap_allow_flash_grenade", "int", 1, 0, 1 );
	level.weap_allow_smoke_grenade = getdvarx( "weap_allow_smoke_grenade", "int", 1, 0, 1 );
	
	// Load allowed attachments types
	level.attach_allow_silencer = getdvarx( "attach_allow_silencer", "int", 1, 0, 1 );
	level.attach_allow_reflex = getdvarx( "attach_allow_reflex", "int", 1, 0, 1 );
	level.attach_allow_acog = getdvarx( "attach_allow_acog", "int", 1, 0, 1 );
	level.attach_allow_grip = getdvarx( "attach_allow_grip", "int", 1, 0, 1 );
	level.attach_allow_assault_gl = getdvarx( "attach_allow_assault_gl", "int", 0, 0, 1 );
	
	level.attach_allow_pistol_none = getdvarx( "attach_allow_pistol_none", "int", 1, 0, 1);
	level.attach_allow_pistol_silencer = getdvarx( "attach_allow_pistol_silencer", "int", 1, 0, 1 );
	
	if( level.perk_allow_c4_mp )
		level.scr_c4_ammo_count = getdvarx( "scr_c4_ammo_count", "int", 1, 1, 2 );
	else
		level.scr_c4_ammo_count = 0;
	if( level.perk_allow_claymore_mp )
		level.scr_claymore_ammo_count = getdvarx( "scr_claymore_ammo_count", "int", 1, 1, 2 );
	else
		level.scr_claymore_ammo_count = 0;
	if( level.perk_allow_rpg_mp )
		level.scr_rpg_ammo_count = getdvarx( "scr_rpg_ammo_count", "int", 1, 1, 3 );
	else
		level.scr_rpg_ammo_count = 0;
	
	if( level.weap_allow_frag_grenade ) {
		level.scr_fraggrenade_ammo_count = getdvarx( "scr_fraggrenade_ammo_count", "int", 1, 0, 4 );
		if( level.perk_allow_specialty_fraggrenade )
			level.specialty_fraggrenade_ammo_count = getdvarx( "specialty_fraggrenade_ammo_count", "int", 1, 1, 4 );
		else
			level.specialty_fraggrenade_ammo_count = 0;
	} else {
		level.scr_fraggrenade_ammo_count = 0;
		level.specialty_fraggrenade_ammo_count = 0;
	}
	
	if( level.weap_allow_concussion_grenade || level.weap_allow_flash_grenade )
		level.scr_specialgrenade_ammo_count = getdvarx( "scr_specialgrenade_ammo_count", "int", 1, 0, 4 );
	else
		level.scr_specialgrenade_ammo_count = 0;
	
	if( level.perk_allow_specialty_specialgrenade )
		level.specialty_specialgrenade_ammo_count = getdvarx( "specialty_specialgrenade_ammo_count", "int", 1, 1, 4 );
	else
		level.specialty_specialgrenade_ammo_count = 0;
	
	level.clientHidePerk1Panel = 0;
	if ( !level.perk_allow_c4_mp && !level.perk_allow_specialty_specialgrenade && !level.perk_allow_rpg_mp && !level.perk_allow_claymore_mp && !level.perk_allow_specialty_fraggrenade && !level.perk_allow_specialty_extraammo && !level.perk_allow_specialty_detectexplosive )
		level.clientHidePerk1Panel = 1;
		
	level.clientHidePerk2Panel = 0;
	if ( !level.perk_allow_specialty_bulletdamage && !level.perk_allow_specialty_armorvest && !level.perk_allow_specialty_fastreload && !level.perk_allow_specialty_rof && !level.perk_allow_specialty_twoprimaries && !level.perk_allow_specialty_gpsjammer && !level.perk_allow_specialty_explosivedamage )
		level.clientHidePerk2Panel = 1;
		
	level.clientHidePerk3Panel = 0;
	if ( !level.perk_allow_specialty_longersprint && !level.perk_allow_specialty_bulletaccuracy && !level.perk_allow_specialty_pistoldeath && !level.perk_allow_specialty_grenadepulldeath && !level.perk_allow_specialty_bulletpenetration && !level.perk_allow_specialty_holdbreath && !level.perk_allow_specialty_quieter && !level.perk_allow_specialty_parabolic )
		level.clientHidePerk3Panel = 1;
		
	level.classMap["assault_mp"] = "CLASS_ASSAULT";
	level.classMap["specops_mp"] = "CLASS_SPECOPS";
	level.classMap["heavygunner_mp"] = "CLASS_HEAVYGUNNER";
	level.classMap["demolitions_mp"] = "CLASS_DEMOLITIONS";
	level.classMap["sniper_mp"] = "CLASS_SNIPER";
	
	level.classMap["custom1"] = "CLASS_CUSTOM1";
	level.classMap["custom2"] = "CLASS_CUSTOM2";
	level.classMap["custom3"] = "CLASS_CUSTOM3";
	level.classMap["custom4"] = "CLASS_CUSTOM4";
	level.classMap["custom5"] = "CLASS_CUSTOM5";
	level.classMap["custom6"] = "CLASS_CUSTOM6";
	level.classMap["custom7"] = "CLASS_CUSTOM7";
	level.classMap["custom8"] = "CLASS_CUSTOM8";
	level.classMap["custom9"] = "CLASS_CUSTOM9";
	
	level.defaultClass = "CLASS_ASSAULT";
	
	if( level.scr_grenade_allow_cooking )
		level.weapons["frag"] = "frag_grenade_mp";
	else
		level.weapons["frag"] = "frag_grenade_nocook_mp";
		
	level.weapons["smoke"] = "smoke_grenade_mp";
	level.weapons["flash"] = "flash_grenade_mp";
	level.weapons["concussion"] = "concussion_grenade_mp";
	level.weapons["c4"] = "c4_mp";
	level.weapons["claymore"] = "claymore_mp";
	level.weapons["rpg"] = "rpg_mp";
	
	// initializes create a class settings
	cac_init();
	
	readDefaultClasses("assault");
	readDefaultClasses("specops");
	readDefaultClasses("heavygunner");
	readDefaultClasses("demolitions");
	readDefaultClasses("sniper");
	
	load_default_loadout( "", "both", "CLASS_ASSAULT", 0 );			// assault
	load_default_loadout( "", "both", "CLASS_SPECOPS", 0 );			// spec ops
	load_default_loadout( "", "both", "CLASS_HEAVYGUNNER", 0 );		// heavy gunner
	load_default_loadout( "", "both", "CLASS_DEMOLITIONS", 0 );		// demolitions
	load_default_loadout( "", "both", "CLASS_SNIPER", 0 );			// sniper
	
	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ ) {
		if( !isDefined( level.tbl_weaponIDs[i] ) || level.tbl_weaponIDs[i]["group"] == "" )
			continue;
		if( !isDefined( level.tbl_weaponIDs[i] ) || level.tbl_weaponIDs[i]["reference"] == "" )
			continue;
			
		//statstablelookup( get_col, with_col, with_data )
		weapon_type = level.tbl_weaponIDs[i]["group"]; //statstablelookup( level.cac_cgroup, level.cac_cstat, i );
		weapon = level.tbl_weaponIDs[i]["reference"]; //statstablelookup( level.cac_creference, level.cac_cstat, i );
		attachment = level.tbl_weaponIDs[i]["attachment"]; //statstablelookup( level.cac_cstring, level.cac_cstat, i );
		
		weapon_class_register( weapon+"_mp", weapon_type );
		
		if( isDefined( attachment ) && attachment != "" ) {
			attachment_tokens = strtok( attachment, " " );
			if( isDefined( attachment_tokens ) ) {
				if( attachment_tokens.size == 0 )
					weapon_class_register( weapon+"_"+attachment+"_mp", weapon_type );
				else {
					// multiple attachment options
					for( k = 0; k < attachment_tokens.size; k++ )
						weapon_class_register( weapon+"_"+attachment_tokens[k]+"_mp", weapon_type );
				}
			}
		}
	}
	
	precacheShader( "waypoint_bombsquad" );
	
	level thread onPlayerConnecting();
}

// assigns default class loadout to team from datatable
load_default_loadout( datatable, team, class, stat_num )
{
	if( team == "both" ) {
		// do not thread, tablelookup is demanding
		load_default_loadout_raw( datatable, "allies", class, stat_num );
		load_default_loadout_raw( datatable, "axis", class, stat_num );
	}
	else
		load_default_loadout_raw( datatable, team, class, stat_num );
}

load_default_loadout_raw( class_dataTable, team, class, stat_num )
{
	abbrClass = "assault";
	if( class_dataTable == "" ) {
		switch(class) {
			case "CLASS_SPECOPS":
				abbrClass = "specops";
				break;
			case "CLASS_HEAVYGUNNER":
				abbrClass = "heavygunner";
				break;
			case "CLASS_DEMOLITIONS":
				abbrClass = "demolitions";
				break;
			case "CLASS_SNIPER":
				abbrClass = "sniper";
				break;
		}
	}
	
	// give primary weapon and attachment
	if( class_dataTable == "" )
		primary_attachment = level.class_primary_attachment[abbrClass];
	else
		primary_attachment = tablelookup( class_dataTable, 1, stat_num + 2, 4 );
	if( primary_attachment == "" || primary_attachment == "none" ||
	    (primary_attachment == "acog" && !level.attach_allow_acog) || (primary_attachment == "reflex" && !level.attach_allow_reflex) ||
	    (primary_attachment == "silencer" && !level.attach_allow_silencer) || (primary_attachment == "grip" && !level.attach_allow_grip) ||
	    (primary_attachment == "gl" && !level.attach_allow_assault_gl) )
		if( class_dataTable == "" )
			level.classWeapons[team][class][0] = level.class_primary[abbrClass][team] + "_mp";
		else
			level.classWeapons[team][class][0] = tablelookup( class_dataTable, 1, stat_num + 1, 4 ) + "_mp";
	else if( class_dataTable == "" )
		level.classWeapons[team][class][0] = level.class_primary[abbrClass][team] + "_" + primary_attachment + "_mp";
	else
		level.classWeapons[team][class][0] = tablelookup( class_dataTable, 1, stat_num + 1, 4 ) + "_" + primary_attachment + "_mp";
		
	// give secondary weapon and attachment
	if( class_dataTable == "" )
		secondary_attachment = level.class_secondary_attachment[abbrClass];
	else
		secondary_attachment = tablelookup( class_dataTable, 1, stat_num + 4, 4 );
	if( secondary_attachment == "" || secondary_attachment == "none" || (secondary_attachment == "silencer" && !level.attach_allow_pistol_silencer) )
		if( class_dataTable == "" )
			level.classSidearm[team][class] = level.class_secondary[abbrClass][team] + "_mp";
		else
			level.classSidearm[team][class] = tablelookup( class_dataTable, 1, stat_num + 3, 4 ) + "_mp";
	else if( class_dataTable == "" )
		level.classSidearm[team][class] = level.class_secondary[abbrClass][team] + "_" + secondary_attachment + "_mp";
	else
		level.classSidearm[team][class] = tablelookup( class_dataTable, 1, stat_num + 3, 4 ) + "_" + secondary_attachment + "_mp";
		
	if( class_dataTable == "" ) {
		// give default class perks
		level.default_perk[class] = [];
		level.default_perk[class][0] = level.class_perk1[abbrClass];
		level.default_perk[class][1] = level.class_perk2[abbrClass];
		level.default_perk[class][2] = level.class_perk3[abbrClass];
	}
	else {
		// give default class perks
		level.default_perk[class] = [];
		level.default_perk[class][0] = tablelookup( class_dataTable, 1, stat_num + 5, 4 );
		level.default_perk[class][1] = tablelookup( class_dataTable, 1, stat_num + 6, 4 );
		level.default_perk[class][2] = tablelookup( class_dataTable, 1, stat_num + 7, 4 );
		
		//specialty something to index
		specialty1 = int( tableLookup( "mp/statsTable.csv", 6, level.default_perk[class][0], 1 ) );
		specialty2 = int( tableLookup( "mp/statsTable.csv", 6, level.default_perk[class][1], 1 ) );
		specialty3 = int( tableLookup( "mp/statsTable.csv", 6, level.default_perk[class][2], 1 ) );
		
		specialty1 = validatePerk(specialty1, 0);
		specialty2 = validatePerk(specialty2, 1);
		specialty3 = validatePerk(specialty3, 2);
		
		//reverse: index to specialty something
		level.default_perk[class][0] = tableLookup( "mp/statsTable.csv", 1, specialty1, 6 );
		level.default_perk[class][1] = tableLookup( "mp/statsTable.csv", 1, specialty2, 6 );
		level.default_perk[class][2] = tableLookup( "mp/statsTable.csv", 1, specialty3, 6 );
	}
	
	level.classGrenades[class]["primary"]["type"] = level.weapons["frag"];
	level.classGrenades[class]["primary"]["count"] = level.scr_fraggrenade_ammo_count;
	
	if( class_dataTable == "" )
		level.classGrenades[class]["secondary"]["type"] = level.class_sgrenade[abbrClass]+"_mp";
	else
		level.classGrenades[class]["secondary"]["type"] = tablelookup( class_dataTable, 1, stat_num + 8, 4 ) + "_mp";
	
	// in case it's a smoke grenade
	if( level.weap_allow_smoke_grenade )
		level.classGrenades[class]["secondary"]["count"] = 1;
	else
		level.classGrenades[class]["secondary"]["count"] = 0;
	
	switch( level.classGrenades[class]["secondary"]["type"] ) {
		case "concussion_grenade_mp":
			if( level.weap_allow_concussion_grenade )
				level.classGrenades[class]["secondary"]["count"] = level.scr_specialgrenade_ammo_count;
			else
				level.classGrenades[class]["secondary"]["count"] = 0;
			break;
		case "flash_grenade_mp":
			if( level.weap_allow_flash_grenade )
				level.classGrenades[class]["secondary"]["count"] = level.scr_specialgrenade_ammo_count;
			else
				level.classGrenades[class]["secondary"]["count"] = 0;
			break;
	}
	
	switch ( level.default_perk[class][0] ) {
		case "specialty_fraggrenade":
				level.classGrenades[class]["primary"]["count"] += level.specialty_fraggrenade_ammo_count;
			break;
		case "specialty_specialgrenade":
			if( level.weap_allow_concussion_grenade && level.classGrenades[class]["secondary"]["type"] == "concussion_grenade_mp" 
				|| level.weap_allow_flash_grenade && level.classGrenades[class]["secondary"]["type"] == "flash_grenade_mp" )
				level.classGrenades[class]["secondary"]["count"] += level.specialty_specialgrenade_ammo_count;
			break;
	}
	
	// give all inventory
	if( class_dataTable == "" )
		inventory_ref = level.default_perk[class][0];
	else
		inventory_ref = tablelookup( class_dataTable, 1, stat_num + 5, 4 );
	if( isDefined( inventory_ref ) && tablelookup( "mp/statsTable.csv", 6, inventory_ref, 2 ) == "inventory" ) {
		// new logic defined below overrites this one
		// (new logic gets the values from dvars instead of .csv file)
		inventory_count = int( tablelookup( "mp/statsTable.csv", 6, inventory_ref, 5 ) );
		
		switch ( inventory_ref ) {
			case "specialty_weapon_c4":
				inventory_count = level.scr_c4_ammo_count;
				break;
			case "specialty_weapon_claymore":
				inventory_count = level.scr_claymore_ammo_count;
				break;
			case "specialty_weapon_rpg":
				inventory_count = level.scr_rpg_ammo_count;
				break;
		}
		
		inventory_item_ref = tablelookup( "mp/statsTable.csv", 6, inventory_ref, 4 );
		assertex( isDefined( inventory_count ) && inventory_count != 0 && isDefined( inventory_item_ref ) && inventory_item_ref != "" , "Inventory in statsTable.csv not specified correctly" );
		
		level.classItem[team][class]["type"] = inventory_item_ref;
		level.classItem[team][class]["count"] = inventory_count;
	}
	else {
		level.classItem[team][class]["type"] = "";
		level.classItem[team][class]["count"] = 0;
	}
	// give all inventory
	//level.classItem[team][class]["type"] = inventory;
	//level.classItem[team][class]["count"] = inv_count;
}

weapon_class_register( weapon, weapon_type )
{
	if( isSubstr( "weapon_smg weapon_assault weapon_projectile weapon_sniper weapon_shotgun weapon_lmg", weapon_type ) )
		level.primary_weapon_array[weapon] = weapon_type;
	else if( weapon_type == "weapon_pistol" )
		level.side_arm_array[weapon] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[weapon] = 1;
	else if( weapon_type == "weapon_explosive" )
		level.inventory_array[weapon] = 1;
	else
		assertex( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}

// create a class init
cac_init()
{
	// max create a class "class" allowed
	level.cac_size = 5;
	
	// init cac data table column definitions
	level.cac_numbering = 0;	// unique unsigned int - general numbering of all items
	level.cac_cstat = 1;		// unique unsigned int - stat number assigned
	level.cac_cgroup = 2;		// string - item group name, "primary" "secondary" "inventory" "specialty" "grenades" "special grenades" "stow back" "stow side" "attachment"
	level.cac_cname = 3;		// string - name of the item, "Extreme Conditioning"
	level.cac_creference = 4;	// string - reference string of the item, "m203" "m16" "bulletdamage" "c4"
	level.cac_ccount = 5;		// signed int - item count, if exists, -1 = has no count
	level.cac_cimage = 6;		// string - item's image file name
	level.cac_cdesc = 7;		// long string - item's description
	level.cac_cstring = 8;		// long string - item's other string data, reserved
	level.cac_cint = 9;			// signed int - item's other number data, used for attachment number representations
	level.cac_cunlock = 10;		// unsigned int - represents if item is unlocked by default
	level.cac_cint2 = 11;		// signed int - item's other number data, used for primary weapon camo skin number representations
	
	// generating camo/attachment data vars collected from attachmentTable.csv
	level.tbl_CamoSkin = [];
	for( i=0; i<8; i++ ) {
		// this for-loop is shared because there are equal number of attachments and camo skins.
		level.tbl_CamoSkin[i]["bitmask"] = int( tableLookup( "mp/attachmentTable.csv", 11, i, 10 ) );
		
		level.tbl_WeaponAttachment[i]["bitmask"] = int( tableLookup( "mp/attachmentTable.csv", 9, i, 10 ) );
		level.tbl_WeaponAttachment[i]["reference"] = tableLookup( "mp/attachmentTable.csv", 9, i, 4 );
	}
	
	level.tbl_weaponIDs = [];
	for( i=0; i<150; i++ ) {
		reference_s = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if( reference_s != "" ) {
			level.tbl_weaponIDs[i]["reference"] = reference_s;
			level.tbl_weaponIDs[i]["group"] = tablelookup( "mp/statstable.csv", 0, i, 2 );
			level.tbl_weaponIDs[i]["count"] = int( tablelookup( "mp/statstable.csv", 0, i, 5 ) );
			level.tbl_weaponIDs[i]["attachment"] = tablelookup( "mp/statstable.csv", 0, i, 8 );
		}
		else
			continue;
	}
	
	perkReferenceToIndex = [];
	
	level.perkNames = [];
	level.perkIcons = [];
	level.PerkData = [];
	// generating perk data vars collected form statsTable.csv
	for( i=150; i<194; i++ ) {
		reference_s = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if( reference_s != "" ) {
			level.tbl_PerkData[i]["reference"] = reference_s;
			level.tbl_PerkData[i]["reference_full"] = tableLookup( "mp/statsTable.csv", 0, i, 6 );
			level.tbl_PerkData[i]["count"] = int( tableLookup( "mp/statsTable.csv", 0, i, 5 ) );
			level.tbl_PerkData[i]["group"] = tableLookup( "mp/statsTable.csv", 0, i, 2 );
			level.tbl_PerkData[i]["name"] = tableLookupIString( "mp/statsTable.csv", 0, i, 3 );
			precacheString( level.tbl_PerkData[i]["name"] );
			level.tbl_PerkData[i]["perk_num"] = tableLookup( "mp/statsTable.csv", 0, i, 8 );
			
			perkReferenceToIndex[ level.tbl_PerkData[i]["reference_full"] ] = i;
			
			level.perkNames[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["name"];
			level.perkIcons[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["reference_full"];
			precacheShader( level.perkIcons[level.tbl_PerkData[i]["reference_full"]] );
		}
		else
			continue;
	}
	
	// allowed perks in each slot, for validation.
	level.allowedPerks[0] = [];
	level.allowedPerks[1] = [];
	level.allowedPerks[2] = [];
	
	// [0.0.1] Disable perks that have been disabled by the admin
	level.allowedPerks[0][ 0] = 190; // 190 through 193 are attachments and "none"
	level.allowedPerks[0][ 1] = 191;
	level.allowedPerks[0][ 2] = 192;
	level.allowedPerks[0][ 3] = 193;
	
	if ( level.perk_allow_c4_mp )
		level.allowedPerks[0][ 4] = perkReferenceToIndex[ "specialty_weapon_c4" ];
	else
		level.allowedPerks[0][ 4] = 0;
		
	if ( level.perk_allow_specialty_specialgrenade )
		level.allowedPerks[0][ 5] = perkReferenceToIndex[ "specialty_specialgrenade" ];
	else
		level.allowedPerks[0][ 5] = 0;
		
	if ( level.perk_allow_rpg_mp )
		level.allowedPerks[0][ 6] = perkReferenceToIndex[ "specialty_weapon_rpg" ];
	else
		level.allowedPerks[0][ 6] = 0;
		
	if ( level.perk_allow_claymore_mp )
		level.allowedPerks[0][ 7] = perkReferenceToIndex[ "specialty_weapon_claymore" ];
	else
		level.allowedPerks[0][ 7] = 0;
		
	if ( level.perk_allow_specialty_fraggrenade )
		level.allowedPerks[0][ 8] = perkReferenceToIndex[ "specialty_fraggrenade" ];
	else
		level.allowedPerks[0][ 8] = 0;
		
	if ( level.perk_allow_specialty_extraammo )
		level.allowedPerks[0][ 9] = perkReferenceToIndex[ "specialty_extraammo" ];
	else
		level.allowedPerks[0][ 9] = 0;
		
	if ( level.perk_allow_specialty_detectexplosive )
		level.allowedPerks[0][10] = perkReferenceToIndex[ "specialty_detectexplosive" ];
	else
		level.allowedPerks[0][10] = 0;
		
	level.allowedPerks[1][ 0] = 190;
	if ( level.perk_allow_specialty_bulletdamage )
		level.allowedPerks[1][ 1] = perkReferenceToIndex[ "specialty_bulletdamage" ];
	else
		level.allowedPerks[1][ 1] = 0;
		
	if ( level.perk_allow_specialty_armorvest )
		level.allowedPerks[1][ 2] = perkReferenceToIndex[ "specialty_armorvest" ];
	else
		level.allowedPerks[1][ 2] = 0;
		
	if ( level.perk_allow_specialty_fastreload )
		level.allowedPerks[1][ 3] = perkReferenceToIndex[ "specialty_fastreload" ];
	else
		level.allowedPerks[1][ 3] = 0;
		
	if ( level.perk_allow_specialty_rof )
		level.allowedPerks[1][ 4] = perkReferenceToIndex[ "specialty_rof" ];
	else
		level.allowedPerks[1][ 4] = 0;
		
	if ( level.perk_allow_specialty_twoprimaries )
		level.allowedPerks[1][ 5] = perkReferenceToIndex[ "specialty_twoprimaries" ];
	else
		level.allowedPerks[1][ 5] = 0;
		
	if ( level.perk_allow_specialty_gpsjammer )
		level.allowedPerks[1][ 6] = perkReferenceToIndex[ "specialty_gpsjammer" ];
	else
		level.allowedPerks[1][ 6] = 0;
		
	if ( level.perk_allow_specialty_explosivedamage )
		level.allowedPerks[1][ 7] = perkReferenceToIndex[ "specialty_explosivedamage" ];
	else
		level.allowedPerks[1][ 7] = 0;
		
	level.allowedPerks[2][ 0] = 190;
	if ( level.perk_allow_specialty_longersprint )
		level.allowedPerks[2][ 1] = perkReferenceToIndex[ "specialty_longersprint" ];
	else
		level.allowedPerks[2][ 1] = 0;
		
	if ( level.perk_allow_specialty_bulletaccuracy )
		level.allowedPerks[2][ 2] = perkReferenceToIndex[ "specialty_bulletaccuracy" ];
	else
		level.allowedPerks[2][ 2] = 0;
		
	if ( level.perk_allow_specialty_pistoldeath )
		level.allowedPerks[2][ 3] = perkReferenceToIndex[ "specialty_pistoldeath" ];
	else
		level.allowedPerks[2][ 3] = 0;
		
	if ( level.perk_allow_specialty_grenadepulldeath )
		level.allowedPerks[2][ 4] = perkReferenceToIndex[ "specialty_grenadepulldeath" ];
	else
		level.allowedPerks[2][ 4] = 0;
		
	if ( level.perk_allow_specialty_bulletpenetration )
		level.allowedPerks[2][ 5] = perkReferenceToIndex[ "specialty_bulletpenetration" ];
	else
		level.allowedPerks[2][ 5] = 0;
		
	if ( level.perk_allow_specialty_holdbreath )
		level.allowedPerks[2][ 6] = perkReferenceToIndex[ "specialty_holdbreath" ];
	else
		level.allowedPerks[2][ 6] = 0;
		
	if ( level.perk_allow_specialty_quieter )
		level.allowedPerks[2][ 7] = perkReferenceToIndex[ "specialty_quieter" ];
	else
		level.allowedPerks[2][ 7] = 0;
		
	if ( level.perk_allow_specialty_parabolic )
		level.allowedPerks[2][ 8] = perkReferenceToIndex[ "specialty_parabolic" ];
	else
		level.allowedPerks[2][ 8] = 0;
		
}

menuClass( response )
{
	self maps\mp\gametypes\_globallogic::closeMenus();
	
	// clears new status of unlocked classes
	if ( response == "demolitions_mp,0" && self getstat( int( tablelookup( "mp/statstable.csv", 4, "feature_demolitions", 1 ) ) ) != 1 ) {
		demolitions_stat = int( tablelookup( "mp/statstable.csv", 4, "feature_demolitions", 1 ) );
		self setstat( demolitions_stat, 1 );
		//println( "Demolitions class [new status cleared]: stat(" + demolitions_stat + ") = " + self getstat( demolitions_stat ) );
	}
	if ( response == "sniper_mp,0" && self getstat( int( tablelookup( "mp/statstable.csv", 4, "feature_sniper", 1 ) ) ) != 1 ) {
		sniper_stat = int( tablelookup( "mp/statstable.csv", 4, "feature_sniper", 1 ) );
		self setstat( sniper_stat, 1 );
		//println( "Sniper class [new status cleared]: stat(" + sniper_stat + ") = " + self getstat( sniper_stat ) );
	}
	assert( !level.oldschool );
	
	// this should probably be an assert
	if( !isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis") )
		return;
		
	tokens = strtok( response, "," );
	
	// by default assume that no default class was selected
	dfltClassSelectedIdx = 0;
	switch( tokens[0] ) {
		case "assault_mp":
			dfltClassSelectedIdx = 1;
			break;
		case "specops_mp":
			dfltClassSelectedIdx = 2;
			break;
		case "heavygunner_mp":
			dfltClassSelectedIdx = 3;
			break;
		case "demolitions_mp":
			dfltClassSelectedIdx = 4;
			break;
		case "sniper_mp":
			dfltClassSelectedIdx = 5;
			break;
		default:
			if( isSubstr( tokens[0], "custom" ) && !level.classes_custom_enable )
				return;
	}
	if( dfltClassSelectedIdx > level.classes_default_enable )
		return;
	
		
	class = self getClassChoice( response );
	primary = self getWeaponChoice( response );
	
	if ( class == "restricted" ) {
		self maps\mp\gametypes\_globallogic::beginClassChoice();
		return;
	}
	
	//if( (isDefined( self.pers["class"] ) && self.pers["class"] == class) &&
	//	(isDefined( self.pers["primary"] ) && self.pers["primary"] == primary) )
	//	return;
	
	if ( self.sessionstate == "playing" ) {
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;
		
		if ( game["state"] == "postgame" )
			return;
			
		if ( ( ( level.inGracePeriod || level.inStrategyPeriod ) && !self.hasDoneCombat && ( level.gametype != "ass" || !isDefined( self.isVIP ) || !self.isVIP ) ) || ( level.gametype == "ftag" && self.freezeTag["frozen"] ) ) {
			self thread deleteExplosives();
			
			//if ( !level.rankedClasses ) {
			//	self maps\mp\gametypes\_class_unranked::setClass( self.pers["class"] );
			//	self.tag_stowed_back = undefined;
			//	self.tag_stowed_hip = undefined;
			//	self maps\mp\gametypes\_class_unranked::giveLoadout( self.pers["team"], self.pers["class"] );
			//} else {
			self setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self giveLoadout( self.pers["team"], self.pers["class"] );
			//}
		}
		else if ( !level.splitScreen ) {
			self iPrintLn( game["strings"]["change_class"] );
		}
	}
	else {
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;
		
		if ( game["state"] == "postgame" )
			return;
			
		if ( game["state"] == "playing" )
			self thread [[level.spawnClient]]();
	}
	
	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
	
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	
	assert( isDefined( level.classMap[tokens[0]] ) );
	
	return ( level.classMap[tokens[0]] );
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}

// ============================================================================
// obtains custom class setup from stat values
cac_getdata()
{
	if ( isDefined( self.cac_initialized ) )
		return;
		
	/* custom class stat allocation order, example of custom class slot 1
	201  weapon_primary
	202  weapon_primary attachment
	203  weapon_secondary
	204  weapon_secondary attachment
	205  weapon_specialty1
	206  weapon_specialty2
	207  weapon_specialty3
	208  weapon_special_grenade_type
	209	 weapon_primary_camo_style
	*/
	
	for( i = 0; i < 9; i ++ ) {
		offset = 200;
		if( !level.rankedClasses )
			offset = 400;
		else if( i >= 5 )
			offset = 300;
		//assertex( self getstat ( i*10+offset ) == 1, "Custom class not initialized!" );
		
		// do not change the allocation and assignment of 0-299 stat bytes, or data will be misinterpreted by this function!
		primary_num = self getstat ( offset+(i*10)+1 );				// returns weapon number (also the unlock stat number from data table)
		primary_attachment_flag = self getstat ( offset+(i*10)+2 ); 	// returns attachment number (from data table)
		if ( !isDefined( level.tbl_WeaponAttachment[primary_attachment_flag] ) ) // handle bad attachment stat
			primary_attachment_flag = 0;
		primary_attachment_mask = level.tbl_WeaponAttachment[primary_attachment_flag]["bitmask"];
		secondary_num = self getstat ( offset+(i*10)+3 );				// returns weapon number (also the unlock stat number from data table)
		secondary_attachment_flag = self getstat ( offset+(i*10)+4 ); 	// returns attachment number (from data table)
		if ( !isDefined( level.tbl_WeaponAttachment[secondary_attachment_flag] ) ) // handle bad attachment stat
			secondary_attachment_flag = 0;
		secondary_attachment_mask = level.tbl_WeaponAttachment[secondary_attachment_flag]["bitmask"];
		specialty1 = self getstat ( offset+(i*10)+5 ); 				// returns specialty number (from data table)
		specialty2 = self getstat ( offset+(i*10)+6 ); 				// returns specialty number (from data table)
		specialty3 = self getstat ( offset+(i*10)+7 ); 				// returns specialty number (from data table)
		special_grenade = self getstat ( offset+(i*10)+8 );			// returns special grenade type as single special grenade items (from data table)
		camo_num = self getstat ( offset+(i*10)+9 );					// returns camo number (from data table)
		
		if ( camo_num < 0 || camo_num >= level.tbl_CamoSkin.size ) {
			println( "^1Warning: (" + self.name + ") camo " + camo_num + " is invalid. Setting to none." );
			camo_num = 0;
		}
		
		camo_mask = level.tbl_CamoSkin[camo_num]["bitmask"];
		
		m16WeaponIndex = 25;
		assert( level.tbl_weaponIDs[m16WeaponIndex]["reference"] == "m16" );
		// if a client manages to pick a disabled weapon by some weird way, we make sure to change it to another that is allowed
		if ( primary_num < 0 || !isDefined( level.tbl_weaponIDs[ primary_num ] ) || !isPrimaryEnabled(primary_num) ) {
			primary_num = numFirstEnabledPrimary();
			primary_attachment_flag = 0;
		}
		if ( secondary_num < 0 || !isDefined( level.tbl_weaponIDs[ secondary_num ] ) ) {
			secondary_num = 0;
			secondary_attachment_flag = 0;
		}
		
		specialty1 = validatePerk( specialty1, 0 );
		specialty2 = validatePerk( specialty2, 1 );
		specialty3 = validatePerk( specialty3, 2 );
		
		// if specialty2 is not Overkill, disallow anything besides pistols for secondary weapon
		if ( level.tbl_PerkData[specialty2]["reference_full"] != "specialty_twoprimaries" ) {
			if ( level.tbl_weaponIDs[secondary_num]["group"] != "weapon_pistol" ) {
				println( "^1Warning: (" + self.name + ") secondary weapon is not a pistol but perk 2 is not Overkill. Setting secondary weapon to pistol." );
				secondary_num = 0;
				secondary_attachment_flag = 0;
			}
		}
		// if certain attachments are used, make sure specialty1 is set right
		primary_attachment_ref = level.tbl_WeaponAttachment[primary_attachment_flag]["reference"];
		secondary_attachment_ref = level.tbl_WeaponAttachment[secondary_attachment_flag]["reference"];
		if ( primary_attachment_ref == "grip" || primary_attachment_ref == "gl" || secondary_attachment_ref == "grip" || secondary_attachment_ref == "gl" ) {
			if ( specialty1 != 190 && specialty1 != 191 && specialty1 != 192 && specialty1 != 193 ) {
				println( "^1Warning: (" + self.name + ") grip or grenade launcher is used but perk 1 was index " + specialty1 + ". Setting perk 1 to none." );
				specialty1 = 193; // 193 = there's an attachment, so no perk
			}
		}
		
		// validate weapon attachments, if faulty attachement found, reset to no attachments
		primary_ref = level.tbl_WeaponIDs[primary_num]["reference"];
		primary_attachment_set = level.tbl_weaponIDs[primary_num]["attachment"];
		secondary_ref = level.tbl_WeaponIDs[secondary_num]["reference"];
		secondary_attachment_set = level.tbl_weaponIDs[secondary_num]["attachment"];
		if ( !issubstr( primary_attachment_set, primary_attachment_ref ) ) {
			println( "^1Warning: (" + self.name + ") attachment [" + primary_attachment_ref + "] is not valid for [" + primary_ref + "]. Removing attachment." );
			primary_attachment_flag = 0;
		}
		if ( !issubstr( secondary_attachment_set, secondary_attachment_ref ) ) {
			println( "^1Warning: (" + self.name + ") attachment [" + secondary_attachment_ref + "] is not valid for [" + secondary_ref + "]. Removing attachment." );
			secondary_attachment_flag = 0;
		}
		
		// validate special grenade type
		flashGrenadeIndex = 101;
		assert( level.tbl_weaponIDs[flashGrenadeIndex]["reference"] == "flash_grenade" ); // if this fails we need to change flashGrenadeIndex
		if ( !isDefined( level.tbl_weaponIDs[special_grenade] ) )
			special_grenade = flashGrenadeIndex;
		specialGrenadeType = level.tbl_weaponIDs[special_grenade]["reference"];
		if ( specialGrenadeType != "flash_grenade" && specialGrenadeType != "smoke_grenade" && specialGrenadeType != "concussion_grenade" ) {
			println( "^1Warning: (" + self.name + ") special grenade " + special_grenade + " is invalid. Setting to flash grenade." );
			special_grenade = flashGrenadeIndex;
		}
		
		if ( specialGrenadeType == "smoke_grenade" && level.tbl_PerkData[specialty1]["reference_full"] == "specialty_specialgrenade" ) {
			println( "^1Warning: (" + self.name + ") smoke grenade may not be used with extra special grenades. Setting to flash grenade." );
			special_grenade = flashGrenadeIndex;
		}
		
		// apply attachment to primary weapon, getting weapon reference strings
		attachment_string = level.tbl_WeaponAttachment[primary_attachment_flag]["reference"];
		if( primary_attachment_flag != 0 && attachment_string != "" )
			self.custom_class[i]["primary"] = level.tbl_weaponIDs[primary_num]["reference"]+"_"+attachment_string+"_mp";
		else
			self.custom_class[i]["primary"] = level.tbl_weaponIDs[primary_num]["reference"]+"_mp";
			
		// apply attachment to secondary weapon, getting weapon reference strings
		attachment_string = level.tbl_WeaponAttachment[secondary_attachment_flag]["reference"];
		if( secondary_attachment_flag != 0 && attachment_string != "" )
			self.custom_class[i]["secondary"] = level.tbl_weaponIDs[secondary_num]["reference"]+"_"+attachment_string+"_mp";
		else
			self.custom_class[i]["secondary"] = level.tbl_weaponIDs[secondary_num]["reference"]+"_mp";
			
		// obtaining specialties, getting specialty reference strings
		assertex( isDefined( level.tbl_PerkData[specialty1] ), "Specialty #:"+specialty1+"'s data is undefined" );
		self.custom_class[i]["specialty1"] = level.tbl_PerkData[specialty1]["reference_full"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_cimage );
		self.custom_class[i]["specialty1_weaponref"] = level.tbl_PerkData[specialty1]["reference"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_creference );
		self.custom_class[i]["specialty1_count"] = level.tbl_PerkData[specialty1]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_ccount ) );
		self.custom_class[i]["specialty1_group"] = level.tbl_PerkData[specialty1]["group"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_cgroup );
		
		self.custom_class[i]["specialty2"] = level.tbl_PerkData[specialty2]["reference"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty2, level.cac_creference );
		self.custom_class[i]["specialty2_weaponref"] = self.custom_class[i]["specialty2"];
		self.custom_class[i]["specialty2_count"] = level.tbl_PerkData[specialty2]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_cstat, specialty2, level.cac_ccount ) );
		self.custom_class[i]["specialty2_group"] = level.tbl_PerkData[specialty2]["group"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty2, level.cac_cgroup );
		
		self.custom_class[i]["specialty3"] = level.tbl_PerkData[specialty3]["reference"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty3, level.cac_creference );
		self.custom_class[i]["specialty3_weaponref"] = self.custom_class[i]["specialty3"];
		self.custom_class[i]["specialty3_count"] = level.tbl_PerkData[specialty3]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_cstat, specialty3, level.cac_ccount ) );
		self.custom_class[i]["specialty3_group"] = level.tbl_PerkData[specialty3]["group"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty3, level.cac_cgroup );
		
		// builds the full special grenade reference string
		self.custom_class[i]["special_grenade"] = level.tbl_weaponIDs[special_grenade]["reference"]+"_mp"; //tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_creference ) + "_mp";
		self.custom_class[i]["special_grenade_count"] = level.tbl_weaponIDs[special_grenade]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_ccount ) );
		
		// camo selection, default 0 = no camo skin
		self.custom_class[i]["camo_num"] = camo_num;
		//self.cac_initialized = true;
		
		/* debug
		println( "\n ========== CLASS DEBUG INFO ========== \n" );
		println( "Primary: "+self.custom_class[i]["primary"] );
		println( "Secondary: "+self.custom_class[i]["secondary"] );
		println( "Specialty1: "+self.custom_class[i]["specialty1"]+" - Group: "+self.custom_class[i]["specialty1_group"]+" - Count: "+self.custom_class[i]["specialty1_count"] );
		println( "Specialty2: "+self.custom_class[i]["specialty2"] );
		println( "Specialty3: "+self.custom_class[i]["specialty3"] );
		println( "Special Grenade: "+self.custom_class[i]["special_grenade"]+" - Count: "+self.custom_class[i]["special_grenade_count"] );
		println( "Primary Camo: "+attachmenttablelookup( level.cac_cname, level.cac_cint2, camo_num ) );
		*/
	}
}

validatePerk( perkIndex, perkSlotIndex )
{
	for ( i = 0; i < level.allowedPerks[ perkSlotIndex ].size; i++ ) {
		if ( perkIndex == level.allowedPerks[ perkSlotIndex ][i] )
			return perkIndex;
	}
	//self iprintln( "^1Warning^7: Perk ^2" + level.tbl_PerkData[perkIndex]["reference_full"] + "^7 is not allowed for perk slot index ^2" + perkSlotIndex + "^7; replacing with no perk" );
	return 190;
}


logClassChoice( class, primaryWeapon, specialType, perks )
{
	if ( class == self.lastClass )
		return;
		
	self logstring( "choseclass: " + class + " weapon: " + primaryWeapon + " special: " + specialType );
	for( i=0; i<perks.size; i++ )
		self logstring( "perk" + i + ": " + perks[i] );
		
	self.lastClass = class;
}

// distributes the specialties into the corrent slots; inventory, grenades, special grenades, generic specialties
get_specialtydata( class_num, specialty )
{
	cac_reference = self.custom_class[class_num][specialty];
	cac_weaponref = self.custom_class[class_num][specialty+"_weaponref"];	// for inventory whos string ref is the weapon ref
	cac_group = self.custom_class[class_num][specialty+"_group"];
	cac_count = self.custom_class[class_num][specialty+"_count"];
	class = getPlayerCustomClass( self.custom_class[class_num]["primary"] );
	
	assertex( isDefined( cac_group ), "Missing "+specialty+"'s group name" );
	
	// grenade classification and distribution ==================
	if( specialty == "specialty1" ) {
		if( isSubstr( cac_group, "grenade" ) ) {
			self.custom_class[class_num]["grenades"] = level.weapons["frag"];
			self.custom_class[class_num]["grenades_count"] = level.scr_fraggrenade_ammo_count;
			
			//# check if perk is available
			if( cac_reference == "specialty_fraggrenade" )
				self.custom_class[class_num]["grenades_count"] += level.specialty_fraggrenade_ammo_count;
			
			assertex( isDefined( self.custom_class[class_num]["special_grenade"] ) && isDefined( self.custom_class[class_num]["special_grenade_count"] ), "Special grenade missing from custom class loadout" );
			self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				
			// smoke grenade by default
			if( level.weap_allow_smoke_grenade )
				self.custom_class[class_num]["specialgrenades_count"] = 1;
			else
				self.custom_class[class_num]["specialgrenades_count"] = 0;
				
			switch( self.custom_class[class_num]["special_grenade"] ) {
				case "concussion_grenade_mp":
					if( level.weap_allow_concussion_grenade )
						self.custom_class[class_num]["specialgrenades_count"] = level.scr_specialgrenade_ammo_count;
					else
						self.custom_class[class_num]["specialgrenades_count"] = 0;
					break;
				case "flash_grenade_mp":
					if( level.weap_allow_flash_grenade )
						self.custom_class[class_num]["specialgrenades_count"] = level.scr_specialgrenade_ammo_count;
					else
						self.custom_class[class_num]["specialgrenades_count"] = 0;
					break;
			}
			
			//# check if perk is available
			if( cac_reference == "specialty_specialgrenade" ) {
				if( level.weap_allow_concussion_grenade && self.custom_class[class_num]["special_grenade"] == "concussion_grenade_mp" 
					|| level.weap_allow_flash_grenade && self.custom_class[class_num]["special_grenade"] == "flash_grenade_mp" )
					self.custom_class[class_num]["specialgrenades_count"] += level.specialty_specialgrenade_ammo_count;
			}
			return;
		}
		else {
			assertex( isDefined( self.custom_class[class_num]["special_grenade"] ), "Special grenade missing from custom class loadout" );
			self.custom_class[class_num]["grenades"] = level.weapons["frag"];
			self.custom_class[class_num]["grenades_count"] = level.scr_fraggrenade_ammo_count;
			self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
			
			// try smoke grenade first
			if( level.weap_allow_smoke_grenade )
				self.custom_class[class_num]["specialgrenades_count"] = 1;
			
			if( level.weap_allow_concussion_grenade && self.custom_class[class_num]["specialgrenades"] == "concussion_grenade_mp"
				|| level.weap_allow_flash_grenade && self.custom_class[class_num]["specialgrenades"] == "flash_grenade_mp" )
				self.custom_class[class_num]["specialgrenades_count"] = level.scr_specialgrenade_ammo_count;
			else
				self.custom_class[class_num]["specialgrenades_count"] = 0;
		}
	}
	
	// if user selected inventory items
	if( cac_group == "inventory" ) {
		// inventory distribution to action slot 3 - unique per class
		assertex( isDefined( cac_count ) && isDefined( cac_weaponref ), "Missing "+specialty+"'s reference or count data" );
		
		self.custom_class[class_num]["inventory"] = cac_weaponref;		// loads inventory into action slot 3
		// fix will go bellow, it rewrites this value
		self.custom_class[class_num]["inventory_count"] = cac_count;	// loads ammo count
		
		switch( cac_reference ) {
			case "specialty_weapon_c4":
				self.custom_class[class_num]["inventory_count"] = level.scr_c4_ammo_count;
				break;
			case "specialty_weapon_claymore":
				self.custom_class[class_num]["inventory_count"] = level.scr_claymore_ammo_count;
				break;
			case "specialty_weapon_rpg":
				self.custom_class[class_num]["inventory_count"] = level.scr_rpg_ammo_count;
				break;
		}
	}
	else if( cac_group == "specialty" ) {
		// building player's specialty, variable size array with size 3 max
		if( self.custom_class[class_num][specialty] != "" )
			self.specialty[self.specialty.size] = self.custom_class[class_num][specialty];
	}
}

/* interface function for code table lookup using class table data
classtablelookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "mp/classtable.csv", with_col, with_data, get_col );
	assertex( isDefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;
}

// interface function for code table lookup using weapon attachment table data
attachmenttablelookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "mp/attachmenttable.csv", with_col, with_data, get_col );
	assertex( isDefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;
}

// interface function for code table lookup using weapon stats table data
statstablelookup( get_col, with_col, with_data )
{
	// with_data = the data from the table
	// with_col = look in this column for the data
	// get_col = once data found, return the value of get_col in the same row
	return_value = tablelookup( "mp/statstable.csv", with_col, with_data, get_col );
	assertex( isDefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;
}
*/

// clears all player's custom class variables, prepare for update with new stat data
reset_specialty_slots( class_num )
{
	self.specialty = [];		// clear all specialties
	self.custom_class[class_num]["inventory"] = "";
	self.custom_class[class_num]["inventory_count"] = 0;
	self.custom_class[class_num]["inventory_group"] = "";
	self.custom_class[class_num]["grenades"] = "";
	self.custom_class[class_num]["grenades_count"] = 0;
	self.custom_class[class_num]["grenades_group"] = "";
	self.custom_class[class_num]["specialgrenades"] = "";
	self.custom_class[class_num]["specialgrenades_count"] = 0;
	self.custom_class[class_num]["specialgrenades_group"] = "";
}

giveLoadout( team, class )
{
	self takeAllWeapons();
	
	/*
	if ( level.splitscreen )
		primaryIndex = 0;
	else
		primaryIndex = self.pers["primary"];
	*/
	
	primaryIndex = 0;
	
	// initialize specialty array
	self.specialty = [];
	
	primaryWeapon = undefined;
	
	// class selected can be one of the defaults (defined by server) or a custom one (defined by player)
	classSelectedIsCustom = isSubstr( class, "CLASS_CUSTOM" );
	
	// only used on custom classes, but defined here because of the scope
	class_num = 0;
	if( classSelectedIsCustom ) {
		// gets custom class data from stat bytes
		self cac_getdata();
		
		// obtains the custom class number
		class_num = int( class[class.size-1] )-1;
		self.class_num = class_num;
		
		assertex( isDefined( self.custom_class[class_num]["primary"] ), "Custom class "+class_num+": primary weapon setting missing" );
		assertex( isDefined( self.custom_class[class_num]["secondary"] ), "Custom class "+class_num+": secondary weapon setting missing" );
		assertex( isDefined( self.custom_class[class_num]["specialty1"] ), "Custom class "+class_num+": specialty1 setting missing" );
		assertex( isDefined( self.custom_class[class_num]["specialty2"] ), "Custom class "+class_num+": specialty2 setting missing" );
		assertex( isDefined( self.custom_class[class_num]["specialty3"] ), "Custom class "+class_num+": specialty3 setting missing" );
		
		// clear of specialty slots, repopulate the current selected class' setup
		self reset_specialty_slots( class_num );
		self get_specialtydata( class_num, "specialty1" );
		self get_specialtydata( class_num, "specialty2" );
		self get_specialtydata( class_num, "specialty3" );
	}
	else {
		// load the selected default class's specialties
		assertex( isDefined(class), "Player during spawn and loadout got no class!" );
		selected_class = class;
		specialty_size = level.default_perk[selected_class].size;
		
		for( i = 0; i < specialty_size; i++ ) {
			if( isDefined( level.default_perk[selected_class][i] ) && level.default_perk[selected_class][i] != "" )
				self.specialty[self.specialty.size] = level.default_perk[selected_class][i];
		}
		assertex( isDefined( self.specialty ) && self.specialty.size > 0, "Default class: " + class + " is missing specialties " );
	}
	
	// re-registering perks to code since perks are cleared after respawn in case if players switch classes
	
	//PeZBot
	if( !isDefined(self.pers["isbot"]) )	//PeZBot/
		self register_perks();
	
	// weapon override for round based gametypes
	// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
	if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
		weapon = self.pers["weapon"];
	else {
		if( classSelectedIsCustom )
			weapon = self.custom_class[class_num]["primary"];
		else
			weapon = level.classWeapons[team][class][primaryIndex];
	}
	if( classSelectedIsCustom )
		sidearm = self.custom_class[class_num]["secondary"];
	else
		sidearm = level.classSidearm[team][class];
		
	//# check sidearm availability - warning: it could be != pistol if the overkill perk is used, so check it too
		
	self GiveWeapon( sidearm );
	if ( self cac_hasSpecialty( "specialty_extraammo" ) || level.fillWeaponMags )
		self giveMaxAmmo( sidearm );
	
	//# check primary weapon availability
	
	
	// give primary weapon
	primaryWeapon = weapon;
	
	if( classSelectedIsCustom )
		assertex( isDefined( self.custom_class[class_num]["camo_num"] ), "Player's camo skin is not defined, it should be at least initialized to 0" );
		
	primaryTokens = strtok( primaryWeapon, "_" );
	self.pers["primaryWeapon"] = primaryTokens[0];
	
	self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
	
	if( classSelectedIsCustom ) {
		self GiveWeapon( weapon, self.custom_class[class_num]["camo_num"] );
		self.camo_num = self.custom_class[class_num]["camo_num"];
	}
	else
		self GiveWeapon( weapon );
		
	if ( self cac_hasSpecialty( "specialty_extraammo" ) || level.fillWeaponMags )
		self giveMaxAmmo( weapon );
	
	if( isDefined(self.pers["primaryWeapon"]) && self.pers["primaryWeapon"] != "none" )
		self setSpawnWeapon( weapon );
	else
		self setSpawnWeapon( sidearm );
	
	if ( level.scr_enable_nightvision )
		self SetActionSlot( 1, "nightvision" );
		
	// give from inventory
	if( classSelectedIsCustom )
		secondaryWeapon = self.custom_class[class_num]["inventory"];
	else
		secondaryWeapon = level.classItem[team][class]["type"];
		
	//# check if inventory is available
	
	if ( secondaryWeapon != "" ) {
		self GiveWeapon( secondaryWeapon );
		
		if( classSelectedIsCustom )
			self setWeaponAmmoOverall( secondaryWeapon, self.custom_class[class_num]["inventory_count"] );
		else
			self setWeaponAmmoOverall( secondaryWeapon, level.classItem[team][class]["count"] );
			
		self thread giveActionSlot3AfterDelay( secondaryWeapon );
		self SetActionSlot( 4, "" );
	}
	else {
		self thread giveActionSlot3AfterDelay( "altMode" );
		self SetActionSlot( 4, "" );
	}
	
	//# check grenade availability (primary)
	
	if( classSelectedIsCustom )
		grenadeTypePrimary = self.custom_class[class_num]["grenades"];
	else
		grenadeTypePrimary = level.classGrenades[class]["primary"]["type"];
	if ( grenadeTypePrimary != "" ) {
		self.primarynade = grenadeTypePrimary;
		
		if( classSelectedIsCustom )
			grenadeCount = self.custom_class[class_num]["grenades_count"];
		else
			grenadeCount = level.classGrenades[class]["primary"]["count"];
			
		// Give grenades after a dvar specified delay
		if ( isDefined( grenadeCount ) && grenadeCount ) {
			self.primarynadecount = grenadeCount;
			self thread giveNadesAfterDelay( grenadeTypePrimary, grenadeCount, true );
		}
	}
	
	//# check grenade availability (secondary)
	
	// give special grenade
	if( classSelectedIsCustom )
		grenadeTypeSecondary = self.custom_class[class_num]["specialgrenades"];
	else
		grenadeTypeSecondary = level.classGrenades[class]["secondary"]["type"];
	if ( grenadeTypeSecondary != "" ) {
		if( classSelectedIsCustom )
			grenadeCount = self.custom_class[class_num]["specialgrenades_count"];
		else
			grenadeCount = level.classGrenades[class]["secondary"]["count"];
			
		if ( grenadeTypeSecondary == level.weapons["flash"])
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");
			
		// Give special grenades after a dvar specified delay
		if ( isDefined( grenadeCount ) && grenadeCount )
			self thread giveNadesAfterDelay( grenadeTypeSecondary, grenadeCount, false );
	}
	
	self thread logClassChoice( class, primaryWeapon, grenadeTypeSecondary, self.specialty );
	
	// [0.0.1] Load the movespeed depending on which gun the player is using as the primary weapon
	switch ( weaponClass( primaryWeapon ) ) {
		case "rifle":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_assault_movespeed", "float", 0.95, 0.5, 1.5 ) );
			break;
		case "pistol":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_sniper_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		case "mg":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_heavygunner_movespeed", "float", 0.875, 0.5, 1.5 )  );
			break;
		case "smg":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_specops_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		case "spread":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_demolitions_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		default:
			self thread openwarfare\_speedcontrol::setBaseSpeed( 1.0 );
			break;
	}
	// [0.0.1]
	
	
	// cac specialties that require loop threads
	self cac_selector();
	
	[[level.onLoadoutGiven]]();
}

// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
setWeaponAmmoOverall( weaponname, amount )
{
	if ( isWeaponClipOnly( weaponname ) ) {
		self setWeaponAmmoClip( weaponname, amount );
	}
	else {
		self setWeaponAmmoClip( weaponname, amount );
		diff = amount - self getWeaponAmmoClip( weaponname );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weaponname, diff );
	}
}

replenishLoadout() // used by ammo hardpoint.
{
	team = self.pers["team"];
	class = self.pers["class"];
	
	weaponsList = self GetWeaponsList();
	for( idx = 0; idx < weaponsList.size; idx++ ) {
		weapon = weaponsList[idx];
		
		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );
		
		if ( weapon == "claymore_mp" || weapon == "claymore_detonator_mp" )
			self setWeaponAmmoStock( weapon, getdvarx( "scr_claymore_ammo_count", "int", 2, 1, 2 ) );
	}
	
	if ( self getAmmoCount( level.classGrenades[class]["primary"]["type"] ) < level.classGrenades[class]["primary"]["count"] )
		self SetWeaponAmmoClip( level.classGrenades[class]["primary"]["type"], level.classGrenades[class]["primary"]["count"] );
		
	if ( self getAmmoCount( level.classGrenades[class]["secondary"]["type"] ) < level.classGrenades[class]["secondary"]["count"] )
		self SetWeaponAmmoClip( level.classGrenades[class]["secondary"]["type"], level.classGrenades[class]["secondary"]["count"] );
}

onPlayerConnecting()
{
	while(1) {
		level waittill( "connecting", player );
		
		if ( !level.oldschool ) {
			if ( !isDefined( player.pers["class"] ) ) {
				player.pers["class"] = undefined;
			}
			player.class = player.pers["class"];
			player.lastClass = "";
		}
		player.detectExplosives = false;
		player.bombSquadIcons = [];
		player.bombSquadIds = [];
	}
}


fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}


setClass( newClass )
{
	self.curClass = newClass;
}


// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

initPerkDvars()
{
	level.cac_bulletdamage_data = getdvarx( "perk_bulletdamage", "int", 40, 10, 100 );		// increased bullet damage by this %
	level.cac_armorvest_data = getdvarx( "perk_armorvest", "int", 75, 10, 100 );				// increased health by this %
	level.cac_explosivedamage_data = getdvarx( "perk_explosivedamage", "int", 25, 10, 100 );	// increased explosive damage by this %
}

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	perks = self.specialty;
	
	self.detectExplosives = false;
	for( i=0; i<perks.size; i++ ) {
		perk = perks[i];
		// run scripted perk that thread loops
		if( perk == "specialty_detectexplosive" )
			self.detectExplosives = true;
	}
	
	maps\mp\gametypes\_weapons::setupBombSquad();
}

register_perks()
{
	perks = self.specialty;
	self clearPerks();
	for( i=0; i<perks.size; i++ ) {
		perk = perks[i];
		
		// TO DO: ask code to register the inventory perks and null perk
		// not registering inventory and null perks to code
		if ( perk == "specialty_null" || perk == "specialty_none" || isSubStr( perk, "specialty_weapon_" ) )
			continue;
			
		self setPerk( perk );
	}
	
	/#
	maps\mp\gametypes\_dev::giveExtraPerks();
#/
}

// returns dvar value in int
cac_get_dvar_int( dvar, def )
{
	return int( cac_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
cac_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else {
		setdvar( dvar, def );
		return def;
	}
}

// CAC: Selected feature check function, returns boolean if a specialty is selected by the current class
// Info: Called on "player" as self, "feature" parameter is a string reference of the specialty in question
cac_hasSpecialty( perk_reference )
{
	return_value = self hasPerk( perk_reference );
	return return_value;
	
	/*
	perks = self.specialty;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if( perk == perk_reference )
			return true;
	}
	return false;
	*/
}

// CAC: Weapon Specialty: Increased bullet damage feature
// CAC: Weapon Specialty: Armor Vest feature
// CAC: Ability: Increased explosive damage feature
cac_modified_damage( victim, attacker, damage, meansofdeath )
{
	// skip conditions
	if( !isDefined( victim) || !isDefined( attacker ) || !isplayer( attacker ) || !isplayer( victim ) )
		return damage;
	if( attacker.sessionstate != "playing" || !isDefined( damage ) || !isDefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;
		
	old_damage = damage;
	final_damage = damage;
	
	/* Cases =======================
	attacker - bullet damage
		victim - none
		victim - armor
	attacker - explosive damage
		victim - none
		victim - armor
	attacker - none
		victim - none
		victim - armor
	===============================*/
	
	// if attacker has bullet damage then increase bullet damage
	if( attacker cac_hasSpecialty( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) ) {
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased
		
		if( isDefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) ) {
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
#/
		}
		else {
			final_damage = damage*(100+level.cac_bulletdamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
#/
		}
	}
	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isExplosiveDamage( meansofdeath ) ) {
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased
		
		if( isDefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) ) {
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased explosive damage" );
#/
		}
		else {
			final_damage = damage*(100+level.cac_explosivedamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
#/
		}
	}
	else {
		// if attacker has no bullet damage then check if victim has armor
		// if victim has armor then less damage is taken, else damage unchanged
		
		if( isDefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) ) {
			final_damage = old_damage*(level.cac_armorvest_data/100);
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor decreased " + attacker.name + "'s damage" );
#/
		}
		else {
			final_damage = old_damage;
		}
	}
	
	// debug
	/#
	if ( getdvarint("scr_perkdebug") )
		println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
#/
		
	// return unchanged damage
	return int( final_damage );
}

// including grenade launcher, grenade, RPG, C4, claymore
isExplosiveDamage( meansofdeath )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";
	if( isSubstr( explosivedamage, meansofdeath ) )
		return true;
	return false;
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
}

getPlayerCustomClass( primaryWeapon )
{
	playerClass = "CLASS_UNKNOWN";
	
	switch ( weaponClass( primaryWeapon ) ) {
		case "rifle":
			playerClass = "CLASS_ASSAULT";
			break;
		case "pistol":
			playerClass = "CLASS_SNIPER";
			break;
		case "mg":
			playerClass = "CLASS_HEAVYGUNNER";
			break;
		case "smg":
			playerClass = "CLASS_SPECOPS";
			break;
		case "spread":
			playerClass = "CLASS_DEMOLITIONS";
			break;
	}
	
	return playerClass;
}

readDefaultClasses(class)
{
	primaryDefault = "ak47";
	primaryAttach = "none";
	secondaryDefault = "deserteagle";
	secondaryAttach = "none";
	perk1Default = "specialty_fraggrenade";
	perk2Default = "specialty_explosivedamage";
	perk3Default = "specialty_longersprint";
	sgrenadeDefault = "flash_grenade";
	
	switch(class) {
		case "specops":
			primaryDefault = "m4";
			primaryAttach = "reflex";
			secondaryDefault = "usp";
			secondaryAttach = "none";
			perk1Default = "specialty_extraammo";
			perk2Default = "specialty_rof";
			perk3Default = "specialty_bulletpenetration";
			sgrenadeDefault = "flash_grenade";
			break;
		case "heavygunner":
			primaryDefault = "m16";
			primaryAttach = "silencer";
			secondaryDefault = "usp";
			secondaryAttach = "none";
			perk1Default = "specialty_specialgrenade";
			perk2Default = "specialty_bulletdamage";
			perk3Default = "specialty_quieter";
			sgrenadeDefault = "concussion_grenade";
			break;
		case "demolitions":
			primaryDefault = "winchester1200";
			primaryAttach = "none";
			secondaryDefault = "deserteagle";
			secondaryAttach = "none";
			perk1Default = "specialty_weapon_c4";
			perk2Default = "specialty_fastreload";
			perk3Default = "specialty_longersprint";
			sgrenadeDefault = "smoke_grenade";
			break;
		case "sniper":
			primaryDefault = "m40a3";
			primaryAttach = "none";
			secondaryDefault = "usp";
			secondaryAttach = "none";
			perk1Default = "specialty_extraammo";
			perk2Default = "specialty_bulletdamage";
			perk3Default = "specialty_bulletpenetration";
			sgrenadeDefault = "smoke_grenade";
			break;
	}
	
	// set primary defaults based on team
	tmp_class_primary[class] = getdvarx( "class_"+class+"_primary", "string", primaryDefault );
	tmp_class_primary[class] = strTok( tmp_class_primary[class], ";" );
	
	level.class_primary[class] = [];
	
	if( isPrimaryEnabled( int( tableLookup( "mp/statsTable.csv", 4, tmp_class_primary[class][0], 0 ) ) ) )
		level.class_primary[class]["none"] = tmp_class_primary[class][0];
	else
		level.class_primary[class]["none"] = ""+tableLookup( "mp/statsTable.csv", 0, numFirstEnabledPrimary(), 4 );
		
	if( isDefined( tmp_class_primary[class][1] ) && isPrimaryEnabled( int( tableLookup( "mp/statsTable.csv", 4, tmp_class_primary[class][1], 0 ) ) ) )
		level.class_primary[class]["allies"] = tmp_class_primary[class][1];
	else
		level.class_primary[class]["allies"] = tmp_class_primary[class][0];
		
	if( isDefined( tmp_class_primary[class][2] ) && isPrimaryEnabled( int( tableLookup( "mp/statsTable.csv", 4, tmp_class_primary[class][2], 0 ) ) ) )
		level.class_primary[class]["axis"] = tmp_class_primary[class][2];
	else
		level.class_primary[class]["axis"] = tmp_class_primary[class][0];
		
	// set secondary defaults based on team
	tmp_class_secondary[class] = getdvarx( "class_"+class+"_secondary", "string", secondaryDefault );
	tmp_class_secondary[class] = strTok( tmp_class_secondary[class], ";" );
	
	level.class_secondary[class] = [];
	if( isSecondaryEnabled( int( tableLookup( "mp/statsTable.csv", 4, tmp_class_secondary[class][0], 0 ) ) ) )
		level.class_secondary[class]["none"] = tmp_class_secondary[class][0];
	else
		level.class_secondary[class]["none"] = ""+tableLookup( "mp/statsTable.csv", 0, numFirstEnabledSecondary(), 4 );
		
	if( isDefined( tmp_class_secondary[class][1] ) && isSecondaryEnabled( int( tableLookup( "mp/statsTable.csv", 4, tmp_class_secondary[class][1], 0 ) ) )  )
		level.class_secondary[class]["allies"] = tmp_class_secondary[class][1];
	else
		level.class_secondary[class]["allies"] = tmp_class_secondary[class][0];
		
	if( isDefined( tmp_class_secondary[class][2] ) && isSecondaryEnabled( int( tableLookup( "mp/statsTable.csv", 4, tmp_class_secondary[class][2], 0 ) ) ) )
		level.class_secondary[class]["axis"] = tmp_class_secondary[class][2];
	else
		level.class_secondary[class]["axis"] = tmp_class_secondary[class][0];
		
	level.class_primary_attachment[class] = getdvarx( "class_"+class+"_primary_attachment", "string", primaryAttach );
	level.class_secondary_attachment[class] = getdvarx( "class_"+class+"_secondary_attachment", "string", secondaryAttach );
	
	// check if perks are enabled
	perk1FromCfg = getdvarx( "class_"+class+"_perk1", "string", perk1Default );
	perk2FromCfg = getdvarx( "class_"+class+"_perk2", "string", perk2Default );
	perk3FromCfg = getdvarx( "class_"+class+"_perk3", "string", perk3Default );
	
	tmp_perk1Index = int( tableLookup( "mp/statsTable.csv", 6, perk1FromCfg, 0 ) );
	tmp_perk2Index = int( tableLookup( "mp/statsTable.csv", 6, perk2FromCfg, 0 ) );
	tmp_perk3Index = int( tableLookup( "mp/statsTable.csv", 6, perk3FromCfg, 0 ) );
	
	perk1FromCfg = ""+tableLookup( "mp/statsTable.csv", 0, validatePerk(tmp_perk1Index, 0), 6 );
	perk2FromCfg = ""+tableLookup( "mp/statsTable.csv", 0, validatePerk(tmp_perk2Index, 1), 6 );
	perk3FromCfg = ""+tableLookup( "mp/statsTable.csv", 0, validatePerk(tmp_perk3Index, 2), 6 );
	
	level.class_perk1[class] = perk1FromCfg;
	level.class_perk2[class] = perk2FromCfg;
	level.class_perk3[class] = perk3FromCfg;
	level.class_sgrenade[class] = getdvarx( "class_"+class+"_sgrenade", "string", sgrenadeDefault );
}

setDefaultClasses(class)
{
	if( isDefined(self.team) && (self.team == "allies" || self.team == "axis") )
		team = self.team;
	else
		team = "none";
	stat = 200;
	dlfClassName = "Assault";
	switch(class) {
		case "specops":
			stat = 210;
			dlfClassName = "Commando";
			break;
		case "heavygunner":
			stat = 220;
			dlfClassName = "Stealth";
			break;
		case "demolitions":
			stat = 230;
			dlfClassName = "Demolition";
			break;
		case "sniper":
			stat = 240;
			dlfClassName = "Sniper";
			break;
	}
	
	self setClientDvar("tmp_class_name_"+stat, getdvarx("class_"+class+"_displayname", "string", dlfClassName) );
	
	self setClientDvars(
	    "tmp_class_prim_"+stat, level.class_primary[class][team],
	    "tmp_class_prim_att_"+stat, level.class_primary_attachment[class],
	    "tmp_class_second_"+stat, level.class_secondary[class][team],
	    "tmp_class_second_att_"+stat, level.class_secondary_attachment[class],
	    "tmp_class_perk1_"+stat, level.class_perk1[class],
	    "tmp_class_perk2_"+stat, level.class_perk2[class],
	    "tmp_class_perk3_"+stat, level.class_perk3[class],
	    "tmp_class_specialg_"+stat, level.class_sgrenade[class]);
}

isClassAvailable()
{
//## TODO: change to current usage of the class
	return true;
	
	///if( level.limitClasses )
	///...
	
	//return false;
	/*
	  if( !isDefined(self.pers["team"]) )
	    team = "undefined";
	
	  switch(self.classesIndex) {
	  // assault
	    case 0:
	      if( team == "axis" )
	        return level.class_axis_assault_limit;
	      else
	        return level.class_allies_assault_limit;
	    break;
	  // specops
	    case 1:
	      if( team == "axis" )
	        return level.class_axis_specops_limit;
	      else
	        return level.class_allies_specops_limit;
	    break;
	  // heavygunner
	    case 2:
	      if( team == "axis" )
	        return level.class_axis_heavygunner_limit;
	      else
	        return level.class_allies_heavygunner_limit;
	    break;
	  // demolitions
	    case 3:
	      if( team == "axis" )
	        return level.class_axis_demolitions_limit;
	      else
	        return level.class_allies_demolitions_limit;
	    break;
	  // sniper
	    case 4:
	      if( team == "axis" )
	        return level.class_axis_sniper_limit;
	      else
	        return level.class_allies_sniper_limit;
	    break;
	  }
	  return false;
	*/
}

numFirstAvailableClass()
{
	// for each class type: assault, specops...
	for( i=0; i < 5; i++)
		if( self isClassAvailable(i) )
			return i;
	return 0;
}

isPrimaryEnabled(weaponNum)
{
	if(weaponNum == 25 && level.weap_allow_assault_m16 )
		return true;
	if(weaponNum == 20 && level.weap_allow_assault_ak47 )
		return true;
	if(weaponNum == 26 && level.weap_allow_assault_m4 )
		return true;
	if(weaponNum == 23 && level.weap_allow_assault_g3 )
		return true;
	if(weaponNum == 24 && level.weap_allow_assault_g36c )
		return true;
	if(weaponNum == 21 && level.weap_allow_assault_m14 )
		return true;
	if(weaponNum == 22 && level.weap_allow_assault_mp44 )
		return true;
	if(weaponNum == 10 && level.weap_allow_specops_mp5 )
		return true;
	if(weaponNum == 11 && level.weap_allow_specops_skorpion )
		return true;
	if(weaponNum == 12 && level.weap_allow_specops_uzi )
		return true;
	if(weaponNum == 13 && level.weap_allow_specops_ak74u )
		return true;
	if(weaponNum == 14 && level.weap_allow_specops_p90 )
		return true;
	if(weaponNum == 81 && level.weap_allow_heavygunner_saw )
		return true;
	if(weaponNum == 80 && level.weap_allow_heavygunner_rpd )
		return true;
	if(weaponNum == 82 && level.weap_allow_heavygunner_m60e4 )
		return true;
	if(weaponNum == 71 && level.weap_allow_demolitions_winchester1200 )
		return true;
	if(weaponNum == 70 && level.weap_allow_demolitions_m1014 )
		return true;
	if(weaponNum == 61 && level.weap_allow_sniper_m40a3 )
		return true;
	if(weaponNum == 65 && level.weap_allow_sniper_m21 )
		return true;
	if(weaponNum == 60 && level.weap_allow_sniper_dragunov )
		return true;
	if(weaponNum == 64 && level.weap_allow_sniper_remington700 )
		return true;
	if(weaponNum == 62 && level.weap_allow_sniper_barrett )
		return true;
		
	return false;
}

numFirstEnabledPrimary()
{
	// first return weapons that are available from the start (lvl 1)
	if( level.weap_allow_assault_ak47 )
		return 20;
	if( level.weap_allow_assault_m16 )
		return 25;
	if( level.weap_allow_specops_mp5 )
		return 10;
	if( level.weap_allow_specops_skorpion )
		return 11;
	if( level.weap_allow_demolitions_winchester1200 )
		return 71;
	if( level.weap_allow_sniper_m40a3 )
		return 61;
	if( level.weap_allow_heavygunner_rpd )
		return 80;
	if( level.weap_allow_heavygunner_saw )
		return 81;
		
	// then return the others, order is the level it is unlocked on (ascendent)
	if( level.weap_allow_sniper_m21 )
		return 65;
	if( level.weap_allow_assault_m4 )
		return 26;
	if( level.weap_allow_specops_uzi )
		return 12;
	if( level.weap_allow_heavygunner_m60e4 )
		return 82;
	if( level.weap_allow_sniper_dragunov )
		return 60;
	if( level.weap_allow_assault_g3 )
		return 23;
	if( level.weap_allow_specops_ak74u )
		return 13;
	if( level.weap_allow_demolitions_m1014 )
		return 70;
	if( level.weap_allow_sniper_remington700 )
		return 64;
	if( level.weap_allow_assault_g36c )
		return 24;
	if( level.weap_allow_specops_p90 )
		return 14;
	if( level.weap_allow_assault_m14 )
		return 21;
	if( level.weap_allow_sniper_barrett )
		return 62;
	if( level.weap_allow_assault_mp44 )
		return 22;
		
	return -1;
}

isSecondaryEnabled(secondaryNum)
{
	if(secondaryNum == 0 && level.weap_allow_beretta )
		return true;
	if(secondaryNum == 1 && level.weap_allow_colt45 )
		return true;
	if(secondaryNum == 2 && level.weap_allow_usp )
		return true;
	if(secondaryNum == 3 && level.weap_allow_deserteagle )
		return true;
	if(secondaryNum == 4 && level.weap_allow_deserteaglegold )
		return true;
		
	return false;
}

numFirstEnabledSecondary()
{
	// first return weapons that are available from the start (lvl 1)
	if( level.weap_allow_beretta )
		return 0;
	if( level.weap_allow_usp )
		return 2;
		
	// then return the others, order is the level it is unlocked on (ascendent)
	if( level.weap_allow_colt45 )
		return 1;
	if( level.weap_allow_deserteagle )
		return 3;
	if( level.weap_allow_deserteaglegold )
		return 4;
		
	return -1;
}

WeaponHasAttachment( weapon, attach )
{
	// for speed up we compare attachments against integers
	attachNum = AttachmentNameToNum(attach);
	
	if(attachNum == 0)
		return true;
		
	if(attachNum < 0 || attachNum > 5 )
		return false;
		
	if( weapon == "deserteagle" || weapon == "deserteaglegold" || weapon == "mp44" )
		return false;
		
	if( (weapon == "colt45" || weapon == "beretta" || weapon == "usp" ) && attachNum != 3)
		return false;
		
	if( (weapon == "m16" || weapon == "m4" || weapon == "ak47" || weapon == "m14" || weapon == "g3" || weapon == "g36c") && attachNum == 4 )
		return false;
		
	if( (weapon == "mp5" || weapon == "skorpion" || weapon == "uzi" || weapon == "ak74u" || weapon == "p90") && (attachNum == 4 || attachNum == 5) )
		return false;
		
	if( (weapon == "rpd" || weapon == "saw" || weapon == "m60e4") && (attachNum == 3 || attachNum == 5) )
		return false;
		
	if( (weapon == "m1014" || weapon == "winchester1200" ) && (attachNum == 3 || attachNum == 1 || attachNum == 5) )
		return false;
		
	if( (weapon == "dragunov" || weapon == "m40a3" || weapon == "barrett" || weapon == "remington700" || weapon == "m21" ) && (attachNum == 3 || attachNum == 2 || attachNum == 4 || attachNum == 5) )
		return false;
		
	return true;
}

WeaponHasCamo( weapon, camoNum )
{
	if(camoNum == 0)
		return true;
		
	if(camoNum < 0 || camoNum > 6 )
		return false;
		
	// if camo_gold and weapon doesn't have it
	if( camoNum == 6 && weapon != "ak47" && weapon != "uzi" && weapon != "m60e4" && weapon != "m1014" && weapon != "dragunov" )
		return false;
		
	return true;
}

AttachmentNameToNum(attachName)
{
	switch( attachName ) {
		case "none":
			return 0;
		case "acog":
			return 1;
		case "reflex":
			return 2;
		case "silencer":
			return 3;
		case "grip":
			return 4;
		case "gl":
			return 5;
	}
	return 0;
}

CamoNameToNum(camoName)
{
	switch( camoName ) {
		case "camo_none":
			return 0;
		case "camo_brockhaurd":
			return 1;
		case "camo_bushdweller":
			return 2;
		case "camo_blackwhitemarpat":
			return 3;
		case "camo_tigerred":
			return 4;
		case "camo_stagger":
			return 5;
		case "camo_gold":
			return 6;
	}
	return 0;
}

openAllClasses()
{
	//If the first custom class is unlocked then in order
	//to display all of the classes in the class selection
	//menu without having to exit game and edit them
	//then we need to unlock them on initialization of the menu
	//so players can edit and then select from any custom class.
	if ( self getStat( 200 ) < 1 )
		self setStat( 200, 1 );
	if ( self getStat( 210 ) < 1 )
		self setStat( 210, 1 );
	if ( self getStat( 220 ) < 1 )
		self setStat( 220, 1 );
	if ( self getStat( 230 ) < 1 )
		self setStat( 230, 1 );
	if ( self getStat( 240 ) < 1 )
		self setStat( 240, 1 );
		
	// initialize extra classes for the first time with m16 by default
	if ( self getStat( 350 ) < 1 )
		self setClassFirstTime(350, 25);
	if ( self getStat( 360 ) < 1 )
		self setClassFirstTime(360, 25);
	if ( self getStat( 370 ) < 1 )
		self setClassFirstTime(370, 25);
	if ( self getStat( 380 ) < 1 )
		self setClassFirstTime(380, 25);
	if ( self getStat( 390 ) < 1 )
		self setClassFirstTime(390, 25);
		
	// m16
	if ( self getStat( 400 ) < 1 )
		self setClassFirstTime(400, 25);
	// mp5
	if ( self getStat( 410 ) < 1 )
		self setClassFirstTime(410, 10);
	// saw
	if ( self getStat( 420 ) < 1 )
		self setClassFirstTime(420, 81);
	// winchester
	if ( self getStat( 430 ) < 1 )
		self setClassFirstTime(430, 71);
	// m40a3
	if ( self getStat( 440 ) < 1 )
		self setClassFirstTime(440, 61);
	// m16
	if ( self getStat( 450 ) < 1 )
		self setClassFirstTime(450, 25);
	// mp5
	if ( self getStat( 460 ) < 1 )
		self setClassFirstTime(460, 10);
	// saw
	if ( self getStat( 470 ) < 1 )
		self setClassFirstTime(470, 81);
	// winchester
	if ( self getStat( 480 ) < 1 )
		self setClassFirstTime(480, 71);
	// m40a3
	if ( self getStat( 490 ) < 1 )
		self setClassFirstTime(490, 61);
}

setClassFirstTime(classNum, weaponNum)
{
	wait (0.1);
	// setting this first so that this class isn't writted again (defaulted)
	self setStat( classNum, 1 );
	// set m16
	self setStat( classNum+1, weaponNum );
	self setStat( classNum+2, 0 );
	self setStat( classNum+3, 0 );
	self setStat( classNum+4, 0 );
	// null perks
	self setStat( classNum+5, 190 );
	self setStat( classNum+6, 190 );
	self setStat( classNum+7, 190 );
	// flash
	self setStat( classNum+8, 101 );
	self setStat( classNum+9, 0 );
}