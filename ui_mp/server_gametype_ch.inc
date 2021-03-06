#undef CHOICE_GROUP
#define CHOICE_GROUP ch

#define G_GAMETYPE_CH (dvarString( "settings_config_gametype" ) == "ch")

CHOICE_DVAREDIT_NUMERIC_VIS( 2, "@OW_TIMELIMIT", scr_ch_timelimit, 5, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 3, "@OW_SCORELIMIT", scr_ch_scorelimit, 3, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 4, "@OW_ROUNDLIMIT", scr_ch_roundlimit, 3, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 5, "@OW_ROUND_SWITCH", scr_ch_roundswitch, 3, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 6, "@OW_PLAYER_RESPAWN_DELAY", scr_ch_playerrespawndelay, 3, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 7, "@OW_WAVE_RESPAWN_DELAY", scr_ch_waverespawndelay, 3, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 8, "@OW_NUMBER_OF_LIVES", scr_ch_numlives, 3, ; , when(G_GAMETYPE_CH) )
CHOICE_DVARYESNO_VIS( 9, "@OW_TEAM_BALANCE_EOR", scr_ch_teambalanceendofround, ; , when(G_GAMETYPE_CH) )

//CH TODO
CHOICE_DVARFLOATLIST_VIS( 10, "@OW_CTF_MODE", scr_ch_chmode, { "Win after holding flag continuously during x seconds" 0 "Win when reaching x amount of points for holding flag" 1 }, ; , when(G_GAMETYPE_CH) )

CHOICE_DVARYESNO_VIS( 11, "@OW_SUDDEN_SHOW_ENEMIES", scr_ch_suddendeath_show_enemies, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 12, "@OW_SUDDEN_TIMELIMIT", scr_ch_suddendeath_timelimit, 3, ; , when(G_GAMETYPE_CH) )

CHOICE_DVARYESNO_VIS( 13, "@OW_SHOW_SCOREBOARD_BOMBER", scr_ch_scoreboard_flag_carrier, ; , when(G_GAMETYPE_CH) )


CHOICE_DVARFLOATLIST_VIS( 14, "@OW_SHOW_BOMB_CARRIER", scr_ch_show_flag_carrier, { "Disabled" 0 "Always enabled" 1 "Anti Flag-Camping" 2 }, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 15, "@OW_SHOW_BOMB_CARRIER_TIME", scr_ch_show_flag_carrier_time, 3, ; , when(G_GAMETYPE_CH && dvarInt(scr_ch_show_flag_carrier) == 1) )
CHOICE_DVAREDIT_NUMERIC_VIS( 15, "@OW_SHOW_BOMB_CARRIER_TIME_DISTANCE", scr_ch_show_flag_carrier_time, 3, ; , when(G_GAMETYPE_CH && dvarInt(scr_ch_show_flag_carrier) == 2) )
CHOICE_DVAREDIT_NUMERIC_VIS( 16, "@OW_SHOW_BOMB_CARRIER_DISTANCE", scr_ch_show_flag_carrier_distance, 5, ; , when(G_GAMETYPE_CH && dvarInt(scr_ch_show_flag_carrier) == 2) )


CHOICE_DVAREDIT_NUMERIC_VIS( 17, "@OW_CH_HOLDTIME", scr_ch_holdtime, 3, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 18, "@OW_CH_NEUTRALTIME", scr_ch_neutraltime, 2, ; , when(G_GAMETYPE_CH) )
CHOICE_DVAREDIT_NUMERIC_VIS( 19, "@OW_CH_OWNERSPAWNDELAY", scr_ch_ownerspawndelay, 2, ; , when(G_GAMETYPE_CH) )

itemDef
{
	name			resetch
	text			"@OW_RESET_GT_TO_DEFAULT"
	type			1
	style			WINDOW_STYLE_FILLED
	forecolor		TEXTBUTTON_COLOR
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	rect			-150 -26 100 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	textfont		UI_FONT_NORMAL
	textalign		ITEM_ALIGN_LEFT
	textscale		TEXTSIZE_SMALL
	textaligny		18
	visible				when(G_GAMETYPE_CH)
	mouseEnter		{ play "mouse_over"; }
	action
	{
		play "mouse_click";
		exec "exec menudvars/_defcfg/gametypes/captureandhold.cfg";
	}
}