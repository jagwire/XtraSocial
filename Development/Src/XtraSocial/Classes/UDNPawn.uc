class UDNPawn extends UTPawn;

//override to make player mesh visible by default
simulated event BecomeViewTarget( PlayerController PC )
{
   local UTPlayerController UTPC;

   Super.BecomeViewTarget(PC);

   if (LocalPlayer(PC.Player) != None)
   {
      UTPC = UTPlayerController(PC);
      if (UTPC != None)
      {
         //set player controller to behind view and make mesh visible
         UTPC.SetBehindView(true);
         SetMeshVisibility(UTPC.bBehindView);
      }
   }
}

simulated function float getDesiredZOffsetBasedOnHealth() {
    
    local float heightOfCollisionCylinder;// = getCollisionHeight();
    local float heightOfPlayerInLevel ;//= Mesh.Translation.Z;
    if(health > 0) {
        heightOfCollisionCylinder = getCollisionHeight();
        heightOfPlayerInLevel = Mesh.Translation.Z;
        
        return (1.2 * heightOfCollisionCylinder + heightOfPlayerInLevel);
    }   
    
    return 0.f;
}

simulated function float getCameraZOffset(float timeBetweenFrames, float desiredOffset) {
    
    local float first;
    local float second;
    
    if(timeBetweenFrames < 0.2) {
        first = desiredOffset * 5 * timeBetweenFrames;
        second = (1 - 5*timeBetweenFrames) * CameraZOffset;
        
            return first + second;
    } 
    
    return desiredOffset;
}

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   local vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
   local float DesiredCameraZOffset;


    //set the camera to initially be at the player's location
   CamStart = Location;

    //set the offset to the intial offset
   CurrentCamOffset = CamOffset;
    
    //if the player's isn't dead, set the camera location height to be 1.2 times the height of the player's collision + the current height of the player's location.
    //if not, set the camera location height to 0.
    DesiredCameraZOffset = getDesiredZOffsetBasedOnHealth();
   
    //if the time between frames is less than 0.2 seconds, set the offset to be it's current time, times 5, times the time between frames + (1- 5 times the time between frames) * the camera height offset
    //otherwise, just make it the desired height offset.
    CameraZOffset = getCameraZOffset(fDeltaTime, desiredCameraZOffset);
   
    //if we're dead, i.e.: no health
   if ( Health <= 0 )
   {
    //set the camera offset to 0
      CurrentCamOffset = vect(0,0,0);

    //set the camera side offset to be the radius of our collision cylinder
    //basically: look at the player's dead body at ground level.
      CurrentCamOffset.X = GetCollisionRadius();
   }

    //set the camera to the height above the player that we want.
   CamStart.Z += CameraZOffset;

    //get our right, forward, and up vectors of the camera rotation.
   GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);

    //set our right camera vector to scale
   CamDirX *= CurrentCameraScale;


    //if we're dead, or we're faking...
   if ( (Health <= 0) || bFeigningDeath )
   {
      // adjust camera position to make sure it's not clipping into world
      // @todo fixmesteve.  Note that you can still get clipping if FindSpot fails (happens rarely)
      FindSpot(GetCollisionExtent(),CamStart);
   }

    
   if (CurrentCameraScale < CameraScale)
   {
      CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + 5 * FMax(CameraScale - CurrentCameraScale, 0.3)*fDeltaTime);
   }
   else if (CurrentCameraScale > CameraScale)
   {
      CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - 5 * FMax(CameraScale - CurrentCameraScale, 0.3)*fDeltaTime);
   }

   if (CamDirX.Z > GetCollisionHeight())
   {
      CamDirX *= square(cos(out_CamRot.Pitch * 0.0000958738)); // 0.0000958738 = 2*PI/65536
   }

   out_CamLoc = CamStart - CamDirX*CurrentCamOffset.X + CurrentCamOffset.Y*CamDirY + CurrentCamOffset.Z*CamDirZ;

   if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
   {
      out_CamLoc = HitLocation;
   }

   return true;
}   

defaultproperties
{
}