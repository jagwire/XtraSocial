class SampleEnemySpawner extends SampleActor
    placeable;
    
    var SampleEnemy spawnedEnemy;
    
    var bool bBossSpawned;
    
function spawnEnemy() {
    `log("SpawnEnemy CALLED!");    

    spawnedEnemy = spawn(class'SampleEnemy_Minion',self,, location);    
}   

function SampleEnemy spawnBoss() {

    return spawn(class'SampleBoss', self,, location);  
    
}

function makeEnemyRunAway() {
    if(spawnedEnemy != none) {
        spawnedEnemy.runAway();
    }   
}
defaultproperties
{
    
        bBossSpawned = false;
        
    Begin Object class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=true
    End Object
    Components.add(Sprite)
}   