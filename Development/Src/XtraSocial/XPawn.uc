class XPawn extends UTPawn;

simulated function PostBeginPlay() {
	super.postBeginPlay();

	if(armsMesh[0] != none) {
		armsMesh[0].setHidden(true);
	}
	
	if(armsMesh[1] != none) {
		armsMesh[1].setHidden(true);
	}
}

simulated function setMeshVisibility(bool bVisible) {

	super.setMeshVisibility(bVisible);
	mesh.setOwnerNoSee(false);
}

defaultproperties
{
}