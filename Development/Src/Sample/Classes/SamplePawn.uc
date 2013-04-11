Class SamplePawn extends UTPawn;

var bool bInvulnerable;
var float invulnerableTime;

simulated function PostBeginPlay() {
    super.PostBeginPlay();
 
    if(ArmsMesh[0] != none) {
        ArmsMesh[0].setHidden(true);
    }
    
   if(ArmsMesh[1] != none) {
       ArmsMesh[1].setHidden(true);    
   }
    
    `log("SamplePawn SPAWNED!!! ====");   
}

event bump(Actor other, PrimitiveComponent otherComponent, vector hitNormal) {
    `log("BUMP!");
 
    if(SampleEnemy(Other)!= none && !bInvulnerable) {
        bInvulnerable = true;
        SetTimer(invulnerableTime, false, 'EndInvulnerable');
        TakeDamage(SampleEnemy(Other).bumpDamage, none, location, vect(0, 0, 0), class'UTDmgType_LinkPlasma');
    }   
}

function EndInvulnerable() {
    bInvulnerable = false;   
}

simulated function SetMeshVisibility(bool bVisible) {
    super.setMeshVisibility(bVisible);
    Mesh.setOwnerNoSee(false);   
}

function OnToggle(SeqAct_Toggle inAction) {
    `log("I have been toggled!"); 
    callTheClient(4.0);  
}


reliable client function callTheClient(float myFloat) {
    `log("Reliable client function called!");   
}
defaultproperties 
{
    invulnerableTime=0.6
}