class SampleEnemy extends SampleActor
    abstract;
             
  var float bumpDamage;
    var Pawn enemy;
    var float followDistance;
    var float attackDistance;
    
    var Material seekingMaterial, attackingMaterial, fleeingMaterial;
    var StaticMeshComponent myMesh;
    var bool bAttacking;
    
    var int Health;
    var bool bFleeing;
    
replication
{
    if(bNetDirty)
    enemy, bAttacking, Health, bFleeing;   
}
    
function getEnemy() {
    local SamplePlayerController controller;
    //look thorugh all the local players (representing a human player)
    foreach DynamicActors(class'SamplePlayerController', controller) {
        if(controller.pawn != none) {
            //assign our enemy variable to the last player controller found's pawn.
            enemy = controller.pawn;
        }   
    }
}    
    
auto state Seeking {
    
    simulated function beginState(Name previousStateName) {
        if(!bAttacking)  {
            myMesh.setMaterial(0, seekingMaterial);  
        }  
    }
    
    simulated function tick(float deltaTime) {
        local vector newLocation;
        
        `log(enemy);
        
        if(bAttacking) {
            return;   
        }
        
        if(bFleeing) {
            GoToState('Fleeing');
            return;   
        }
        
        
        //if we haven't defined an enemy of this class...
        if(enemy == none) {
            getEnemy();
        }
        
        if(enemy != none) {
            newLocation = Location;
            newLocation += (enemy.location - location) * deltaTime;
            SetLocation(newLocation);
            
            if(VSize(NewLocation - enemy.location) < attackDistance) {
                GoToState('Attacking');   
            }
        }
    }
}

state Attacking {
    simulated function beginState(Name previousStateName) {
        myMesh.setMaterial(0, attackingMaterial);   
    }
    
    simulated function tick(float deltaTime) {
        
        if(bFleeing){
            GoToState('Fleeing');
            return;
        }
        
        bAttacking = true;
       if(enemy == none) {
            getEnemy();   
       }
        
        if(enemy != none) {
            enemy.bump(self, collisionComponent, vect(0,0,0));   
            
            if(VSize(Location - enemy.location) > attackDistance) {
                GoToState('Seeking');   
            }
        }
    }
 
    simulated function endState(name nextStateName) {
        SetTimer(1, false, 'EndAttack');
    }   
}

state Fleeing {
    
    simulated function beginState(Name previousStateName) {
        myMesh.setMaterial(0, fleeingMaterial);   
    }
    
    
    simulated function tick(float deltaTime) {
        local vector newLocation;
        
        if(enemy == none) {
            getEnemy();   
        }
        
        if(enemy != none) {
            NewLocation = Location;
            newLocation -= normal(enemy.location - location) * deltaTime;
            SetLocation(newLocation);    
        }
    }    
}

simulated function endAttack() {
    bAttacking = false;
 
    if(getStateName() == 'Seeking' || isChildState(GetStateName(), 'Seeking')) {
        myMesh.setMaterial(0, seekingMaterial);
    } 
}

simulated function runAway() {

}

defaultproperties
{
    bBlockActors = True
    bCollideActors = True
    bumpDamage=5.0
    followDistance=512.0
    attackDistance=96.0
    
    seekingMaterial=Material'EditorMaterials.WidgetMaterial_X'
    attackingMaterial=Material'EditorMaterials.WidgetMaterial_Z'
    fleeingMaterial=Material'EditorMaterials.WidgetMaterial_Y';
    
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment bEnabled=true
    End Object
    Components.Add(MyLightEnvironment)
    
    Begin Object Class=StaticMeshComponent Name=EnemyMesh
        StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
        Materials(0)=Material'EditorMaterials.WidgetMaterial_X'
        LightEnvironment=MyLightEnvironment
        Scale3D=(X=0.25, Y=0.25, Z=0.5)
    End Object
    Components.Add(EnemyMesh)
    myMesh = EnemyMesh
    
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=32.0
        CollisionHeight=64.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
}
      