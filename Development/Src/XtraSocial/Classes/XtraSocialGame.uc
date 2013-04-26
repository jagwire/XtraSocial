class XtraSocialGame extends UTDeathMatch;

simulated function postBeginPlay() {
    super.postBeginPlay();
}

defaultproperties
{
    DefaultPawnClass=class'XtraSocial.UDNPawn'
    PlayerControllerClass=class'XtraSocial.UDNPlayerController'
    DefaultInventory(0) = none
    bDelayedStart = false
    GameReplicationInfoClass=class'XtraSocial.XGameReplicationInfo'
}