class SampleBoss extends SampleEnemy;


var bool bStageTwo;


replication
{
    if(bNetDirty)
        bStageTwo;   
}
auto state Seeking {
    simulated function beginState(name previousStateName) {
        //every 4 seconds, call attack()
        //if we had put false here instead of true, it would only call attack() once.
        setTimer(4.0, true, 'Attack');   
    }
    
    simulated function tick(float deltaTime) {
        local vector newLocation;
        
        if(enemy == none) {
            getEnemy();   
        }
        
        if(enemy != none) {
            `log("BOSS MOVING!");
            newLocation = location;
            newLocation += (enemy.location - location) * deltaTime * 0.1;
           // newLocation += normal((enemy.location - location) cross vect(0, 0, 1)) * deltaTime;
            setLocation(newLocation);   
        }
        
        if(bStageTwo && GetStateName() != 'StageTwo') {
            GoToState('StageTwo');       
        }
    }   
}

state StageTwo extends Seeking {
    
    simulated function beginState(name previousStateName) {
        setTimer(0.5, true, 'Attack');
    }
    simulated function attack() {
        local UTProj_Rocket myRocket;
     
        myRocket = spawn(class'UTProj_Rocket', self,, location);
        myRocket.init(normal(enemy.location - location));
        myMesh.setMaterial(0, attackingMaterial);
        setTimer(1, false, 'endAttack');
    }
}

function attack() {
    spawn(class'SampleEnemy_Minion',,, location);
    myMesh.setMaterial(0, attackingMaterial);
    setTimer(1, false, 'EndAttack');   
}


event takeDamage(int damageAmount,
                 controller eventInstigator,
                 vector hitLocation, 
                 vector momentum, 
                 class<DamageType> damageType, 
                 optional TraceHitInfo hitInfo, 
                 optional actor damageCauser) {
                     
     local SampleEnemy s_enemy;
     
     health--;
     `log("BOSS DAMAGED! LIFE LEFT: "@health);
     if(health == 0 && eventInstigator != none && eventInstigator.playerReplicationInfo != none) {
        WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo, 1);   
        
        foreach DynamicActors(class'SampleEnemy',s_enemy) {
        if(s_enemy != self) {
            s_enemy.runAway();
            } 
        }
    
        Destroy();
     }
    
    if(health == 10) {
        bStageTwo = true;
    }
}
defaultproperties
{
    health=30
    Begin Object Name=EnemyMesh
        Scale3D=(x=1, y=1, z=2);
    End Object
 
    Begin Object Name=CollisionCylinder
        CollisionRadius=128.0
        CollisionHeight=256.0
     End Object   
}