class SampleGame extends UTDeathMatch;
//
//event onEngineHasLoaded() {
//    WorldInfo.Game.Broadcast(self,"Sample Game Type Active - Engine has loaded!!!");
//}
//
var int enemiesLeft;
var array<SampleEnemySpawner> enemySpawners;
var bool bSpawnBoss;

var SampleEnemy theBoss;

var int nextWaveTime;

simulated function PostBeginPlay() {
    
    local SampleEnemySpawner spawner;
    super.PostBeginPlay();
 
    
    GoalScore = 1;
    
    foreach DynamicActors(class'SampleEnemySpawner', spawner) {
        enemySpawners[enemySpawners.length] = spawner;   
    }       
    
    if(SampleGameReplicationInfo(GameReplicationInfo) != none) {
        SampleGameReplicationInfo(GameReplicationInfo).enemiesLeft = enemiesLeft;   
        SampleGameReplicationInfo(GameReplicationInfo).nextWaveTime = nextWaveTime;
    }
}

function activateSpawners() {
    local int i;
    local SamplePlayerController controller;
        
    foreach DynamicActors(class'SamplePlayerController', controller) {
           break;
    }
    
   if(controller.pawn == none) {
       SetTimer(1.0, false, 'activateSpawners');
        return;   
   }

    if(bSpawnBoss) {
        theBoss = enemySpawners[0].spawnBoss();
        
        if(SampleGameReplicationInfo(GameReplicationInfo) != none) {
            SampleGameReplicationInfo(GameReplicationInfo).theBoss = theBoss;   
        }
    }
    else 
    {         
        for(i = 0; i<enemySpawners.length; i++) {
            enemySpawners[i].spawnEnemy();
        }      
    }
   
}

function scoreObjective(PlayerReplicationInfo scorer, int score) {
    super.ScoreObjective(scorer, score);
}

function spawnBoss() {
    bSpawnBoss = true;
    
    if(SampleGameReplicationInfo(GameReplicationInfo) != none) {
        SampleGameReplicationInfo(GameReplicationInfo).bSpawnBoss = bSpawnBoss;   
    }
    
    activateSpawners();
}

function enemyKilled() {
    local int i;
    
    if(bSpawnBoss) {
        return;
    }
 
    `log("ENEMY KILLED!");
    enemiesLeft--;
    `log("ENEMIES LEFT:"@enemiesLeft);
 
    if(enemiesLeft <= 0) {
        for(i=0; i<enemySpawners.length;i++) {
            if(bSpawnBoss == true) {
                return;
            }
            enemySpawners[i].makeEnemyRunAway();
        }
        ClearTimer('ActivateSpawners');
        TriggerGlobalEventClass(class'SampleSequenceEvent_WaveComplete', self);
        nextWaveTime = -1;
    }
    
    if(SampleGameReplicationInfo(GameReplicationInfo) != none) {
        SampleGameReplicationInfo(GameReplicationInfo).enemiesLeft = enemiesLeft;
        SampleGameReplicationInfo(GameReplicationInfo).nextWaveTime = nextWaveTime;
    }      
        
    
}
 
function startWave(int waveSize, int waveTimer) {
    local SampleEnemy enemy;
    
    //destroy any enemies remaining from previous left.
    foreach DynamicActors(class'SampleEnemy', enemy) {
        enemy.destroy();   
    }
    
    //set the number of new enemies to the size of the wave
    enemiesLeft = waveSize;
    nextWaveTime = waveTimer;
    
    if(SampleGameReplicationInfo(GameReplicationInfo) != none) {
        SampleGameReplicationInfo(GameReplicationInfo).enemiesLeft = enemiesLeft;   
        SampleGameReplicationInfo(GameReplicationInfo).nextWaveTime = nextWaveTime;
    }
    
    
    broadcast(self, nextWaveTime);
    setTimer(1, true, 'WaveCountDown');

}


function WaveCountDown() {
    nextWaveTime--;
    if(nextWaveTime <= 0) {
        ClearTimer('WaveCountDown');
        bSpawnBoss=false;
        ActivateSpawners();
    }
    else {
        broadcast(self, nextWaveTime);
    }
    
    if(SampleGameReplicationInfo(GameReplicationInfo) != none) {
        SampleGameReplicationInfo(GameReplicationInfo).nextWaveTime = nextWaveTime; 
        SampleGameReplicationInfo(GameReplicationInfo).bSpawnBoss = bSpawnBoss;  
    }
}

defaultproperties
{
    nextWaveTime=5
    bSpawnBoss = false
    enemiesLeft=4 //deviated from book here, 5 kils is easier than 10.
    bScoreDeaths=false
    DefaultPawnClass=class'Sample.SamplePawn'
    PlayerControllerClass=class'Sample.SamplePlayerController'
    DefaultInventory(0) = none
    bDelayedStart=false
    GameReplicationInfoClass=class'Sample.SampleGameReplicationInfo'
}