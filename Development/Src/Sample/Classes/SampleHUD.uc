class SampleHUD extends UTGFxHUDWrapper;

simulated function PostBeginPlay() {
    super.PostBeginPlay();
    `log("SAMPLE HUD SPAWNED!");   
}


event drawHUD() {
    super.drawHUD();
    
    Canvas.DrawColor = WhiteColor;
    Canvas.Font = class'Engine'.static.GetLargeFont();
    
    //if the owner of this HUD is a pawn and is holding an instance of SampleWeapon... 
    if(PlayerOwner.Pawn != none && SampleWeapon(PlayerOwner.Pawn.Weapon) != none) {
        Canvas.SetPos(Canvas.ClipX *0.1, Canvas.ClipY * 0.9);
        Canvas.DrawText("Weapon Level:" @ SampleWeapon(PlayerOwner.Pawn.Weapon).currentWeaponLevel);
        
        //if the currently running game is an instance of SampleGame...
        if(SampleGameReplicationInfo(WorldInfo.GRI) != none) {
            Canvas.setPos(Canvas.ClipX*0.1, Canvas.ClipY*0.95);

            if(!SampleGameReplicationInfo(WorldInfo.GRI).bSpawnBoss && SampleGameReplicationInfo(WorldInfo.GRI).nextWaveTime == 0) {
                 Canvas.DrawText("Enemies Left:" @SampleGame(WorldInfo.Game).enemiesLeft);
            } 
             else if(SampleGameReplicationInfo(WorldInfo.GRI).theBoss !=  none) {
                 Canvas.DrawText("Boss Health:"@SampleGameReplicationInfo(WorldInfo.GRI).theBoss.health);
                
                 if(SampleGameReplicationInfo(WorldInfo.GRI).theBoss.health <= 10) {
                    Canvas.setPos(Canvas.ClipX * 0.4, Canvas.ClipY * 0.7);
                    Canvas.DrawText("BOSS SUPER RAGE MODE");   
                }
            }
            
        }
    }   
}
defaultproperties
{
    
}