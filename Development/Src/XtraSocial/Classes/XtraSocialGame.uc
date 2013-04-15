class XtraSocialGame extends UTDeathMatch;

simulated function postBeginPlay() {
	super.postBeginPlay();
}

defaultproperties
{
	DefaultPawnClass=class'XtraSocial.XPawn'
	PlayerControllerClass=class'XtraSocial.XPlayerController'
	DefaultInventory(0) = none
	bDelayedStart = false
	GameReplicationInfoClass=class'XtraSocial.XGameReplicationInfo'
}