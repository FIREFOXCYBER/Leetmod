init()
{
	level.persistentDataInfo = [];
	
	// previously this was:
	//if ( !level.rankedMatch ) {
	// it was changed to:
	//if ( !level.rankedClasses ) {
	//	maps\mp\gametypes\_class_unranked::init();
	//} else {
	maps\mp\gametypes\_class::init();
	//}
	
	maps\mp\gametypes\_rank::init();
	maps\mp\gametypes\_missions::init();
	
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	while(1) {
		level waittill( "connected", player );
		
		player setClientDvar("ui_xpText", "1");
		player.enableText = true;
	}
}

// ==========================================
// Script persistent data functions
// These are made for convenience, so persistent data can be tracked by strings.
// They make use of code functions which are prototyped below.

/*
=============
statGet

Returns the value of the named stat
=============
*/
statGet( dataName )
{
	if ( !level.rankedMatch )
		return 0;
		
	return self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
}

/*
=============
setStat

Sets the value of the named stat
=============
*/
statSet( dataName, value )
{
	if ( !level.rankedMatch )
		return;
		
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value );
}

/*
=============
statAdd

Adds the passed value to the value of the named stat
=============
*/
statAdd( dataName, value )
{
	if ( !level.rankedMatch )
		return;
		
	curValue = self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value + curValue );
}
