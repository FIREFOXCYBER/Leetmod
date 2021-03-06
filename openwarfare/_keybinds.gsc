#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	game["menu_clientcmd"] = "clientcmd";
	
	// OpenWarfare
	precacheMenu( game["menu_clientcmd"] );
	
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
	self thread onMenuResponse();
}

onMenuResponse()
{
	self endon("disconnect");
	
	while(1) {
		self waittill( "menuresponse", menu, response);
		
		if( menu == "-1" ) {
			switch( response ) {
				case "specviewmode":
					// Checking if the client GUID is a subString of the allowed GUIDs can be dangerous
					// (imagine if the player can set his GUID to just one character)
					if ( ( level.scr_allow_thirdperson == 1 || isSubStr( level.scr_allow_thirdperson_guids, self getGuid() ) ) && !isAlive( self ) ) {
						self maps\mp\gametypes\_globallogic::setThirdPerson( !self.spectatingThirdPerson );
					}
					break;
				case "zoomin":
					//if ( level.gametype == "hns" && self.pers["team"] == game["defenders"] ) {
					//	self thread maps\mp\gametypes\hns::rotateProp(5);
					//} else {
					self thread openwarfare\_sniperzoom::zoomIn();
					//}
					break;
				case "zoomout":
					//if ( level.gametype == "hns" && self.pers["team"] == game["defenders"] ) {
					//	self thread maps\mp\gametypes\hns::rotateProp(-5);
					//} else {
					self thread openwarfare\_sniperzoom::zoomOut();
					//}
					break;
				case "attachdetach":
					self thread openwarfare\_dynamicattachments::attachDetachAttachment();
					break;
				case "firingmode":
					//self thread openwarfare\_firingmode::switchFiringMode();
					break;
				case "objectdrop":
					if ( isDefined( self.carryObject ) ) {
						self.carryObject thread maps\mp\gametypes\_gameobjects::setDropped();
						if ( level.gametype == "sd" )
							self.isBombCarrier = false;
						self thread maps\mp\gametypes\_gameobjects::pickupObjectDelayTime( 3.0 );
					}
					break;
				case "weapondrop":
					if ( level.gametype != "gg" && level.gametype != "ss" && level.gametype != "oitc" ) {
						self thread openwarfare\_utils::weaponDrop();
					}
					break;
				case "bandage":
					if ( isDefined( self.isBleeding ) && self.isBleeding )
						self thread openwarfare\_healthsystem::bandageSelf();
					else
						self thread openwarfare\_healthsystem::medic();
					break;
				case "unjam":
					self thread openwarfare\_weaponjam::unjamWeapon();
					break;
				case "calltimeout":
					self thread openwarfare\_timeout::timeoutCalled();
					break;
				case "redirect":
					self thread openwarfare\_reservedslots::disconnectPlayer( true );
					break;
				case "cyclefpslag":
					self thread openwarfare\_cyclefpslag::cycleFPSLagometer();
					break;
				case "togglestats":
					if ( level.scr_realtime_stats_enable == 1 ) {
						self.pers["stats"]["show"] = !self.pers["stats"]["show"];
						self setClientDvar( "ui_hud_showstats", self.pers["stats"]["show"] );
						self playLocalSound( "mouse_click" );
					}
					break;
				case "advancedacp":
					if ( level.scr_aacp_enable != 0 ) {
						if ( isDefined( self.aacpAccess ) && self.aacpAccess != "" ) {
							self openMenu( "advancedacp" );
						}
						else {
							self iprintln( &"OW_AACP_NOACCESS", self getGUID() );
						}
					}
					else {
						self iprintln( &"OW_AACP_NOTENABLED" );
					}
					break;
				default:
					break;
			}
			continue;
		}
	}
}