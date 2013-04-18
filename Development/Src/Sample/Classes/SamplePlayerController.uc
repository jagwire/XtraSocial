class SamplePlayerController extends UTPlayerController;

var vector PlayerViewOffset;
var vector CurrentCameraLocation, DesiredCameraLocation;
var rotator CurrentCameraRotation;

simulated function PostBeginPlay() {
    WorldInfo.Game.Broadcast(self,"Sample Player Controller Active - Engine has loaded!!!");
    `log("SAMPLE PLAYER CONTROLLER ACTIVE!");
    super.PostBeginPlay();
    
    bNoCrosshair = true;

}

simulated event GetPlayerViewPoint(out vector outLocation, out Rotator outRotation) 
{
    super.GetPlayerViewPoint(outLocation, outRotation);
 
    if(Pawn != none) 
    {      
        outLocation = CurrentCameraLocation;
        outRotation = rotator((outLocation * vect(1, 1, 0)) - outLocation);
    }   
    CurrentCameraRotation = outRotation;
}

function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
 return Pawn.Rotation;   
}

exec function StartFire(optional byte FireModeNum) {
 super.StartFire(FireModeNum);   

    if(Pawn != none && UTWeap_RocketLauncher(Pawn.Weapon) != none) {
        Pawn.setHidden(false);
        SetTimer(1, false, 'MakeMeInvisible'); 
    }
 
}

exec function Use() {
    `log("I have been used!");
        CallTheServer(3);
}
    
reliable server function CallTheServer(int myInt) {
    `log("Reliable server function called!");   
}

function NotifyChangedWeapon(Weapon previousWeapon, Weapon newWeapon) {
    super.notifyChangedWeapon(previousWeapon, newWeapon);
    NewWeapon.SetHidden(true);
    
    if(Pawn == none) {
        return;
    }   
    
    if(UTWeap_RocketLauncher(newWeapon) != none) {
        Pawn.SetHidden(true);   
    }
    else {
        Pawn.SetHidden(false);   
    }
}

function PlayerTick(float deltaTime) {
    super.PlayerTick(deltaTime);
    
    if(Pawn != none) {
        DesiredCameraLocation = Pawn.Location + (PlayerViewOFfset >> Pawn.Rotation);
        CurrentCameraLocation += (DesiredCameraLocation - CurrentCameraLocation) * deltaTime * 3;   
    }
    
}

function MakeMeInvisible() {
    if(Pawn != none && UTWeap_RocketLauncher(Pawn.Weapon) != none) {
        Pawn.SetHidden(true);
    }   
}

state PlayerWalking {
    
    function PlayerMove(float deltaTime) {
        local vector X, Y, Z, altAcceleration;
        local rotator oldRotation;
     
        GetAxes(currentCameraRotation, X, Y, Z);
     
       altAcceleration = PlayerInput.aForward*Z + PlayerInput.aStrafe*Y;
       altAcceleration.Z = 0;
        altAcceleration = Pawn.AccelRate * normal(altAcceleration);  
        oldRotation = rotation;
        updateRotation(deltaTime); 
        
        if(Role < ROLE_Authority) {
            ReplicateMove(deltaTime, altAcceleration, DCLICK_None, oldRotation - rotation);   
        }
        else {
            processMove(deltaTime, altAcceleration, DCLICK_None, oldRotation - rotation);
        }
    }
}

reliable client function clientSetHUD(class<HUD> newHUDType) {
    if(myHUD != none) {
        myHUD.Destroy();
    }   
    
    myHUD = spawn(class'SampleHUD', self);
}

defaultproperties
{
    PlayerViewOffset=(X=384,Y=0,Z=1024)
|}
    
    