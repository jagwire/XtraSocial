class XPlayerController extends UTPlayerController;

var vector PlayerViewOffset;
var vector currentCameraLocation, desiredCameraLocation;
var rotator currentCameraRotation;

simulated function postBeginPlay() {
    super.postBeginPlay();
    bNoCrossHair = true;
}

simulated event getPlayerViewPoint(out vector outLocation, out Rotator outRotation) {
    super.getPlayerViewPoint(outLocation, outRotation);

    if(pawn != none) {
        outLocation = currentCameraLocation;
        outRotation = rotator((outLocation * vect(1, 1, 0)) - outLocation);
    }
    currentCameraRotation = outRotation;
}

function Rotator getAdjustedAimFor(Weapon w, vector startFireLoc) {
    return Pawn.rotation;
}

function PlayerTick(float deltaTime) {
    super.playerTick(deltaTime);

    if(pawn != none) {
        desiredCameraLocation = Pawn.location + (PlayerViewOffset >> Pawn.Rotation);
        currentCameraLocation += (DesiredCameraLocation - currentCameraLocation) * deltaTime * 3;
    }
}

state PlayerWalking {
    function playerMove(float deltaTime) {
        local Vector X, Y, Z, altAcceleration;
        local rotator oldRotation;

        getAxes(currentCameraRotation, X, Y, Z);

        altAcceleration = PlayerInput.aForward*Z + PlayerInput.aStrafe*Y;
        altAcceleration.Z = 0;
        altAcceleration = Pawn.accelRate * normal(altAcceleration);
        oldRotation = rotation;
        
        updateRotation(deltaTime);

        if(ROLE < ROLE_Authority) {
            replicateMove(deltaTime, altAcceleration, DCLICK_None, oldRotation - rotation);
        }
        else {
            processMove(deltaTime, altAcceleration, DCLICK_None, oldRotation - rotation);
        }

    }
}

defaultproperties
{
    PlayerViewOffset=(X=385, Y=0, Z=1024)
}

