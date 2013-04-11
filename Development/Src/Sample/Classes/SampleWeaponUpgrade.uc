class SampleWeaponUpgrade extends SampleActor
    placeable;
    
    var StaticMeshComponent myMesh;
    var Material bigMaterial;
    
    event Touch(Actor other, PrimitiveComponent otherComponent, vector hitLocation, vector hitNormal) {
        if(Pawn(Other) != none && SampleWeapon(Pawn(Other).Weapon) != none) {            
           
            SampleWeapon(Pawn(Other).Weapon).upgradeWeapon();
            TriggerEventClass(class'SampleSequenceEvent_PickedUp', self);
            Destroy();   
        }
    }
    
    
   simulated function PostBeginPlay() {

    }  
    
   //handler function
   function onToggle(SeqAct_Toggle action) {
        myMesh.SetScale(2.0);
        myMesh.setMaterial(0, bigMaterial);     
    } 
    
    
    defaultproperties
    {
        bCollideActors=true
        bigMaterial = Material'EditorMaterials.WidgetMaterial_Z'
        SupportedEvents.add(class'SampleSequenceEvent_PickedUp')
        
        RemoteRole=ROLE_SimulatedProxy
        bAlwaysRelevant=true
        
        Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment bEnabled=true
        End Object
        Components.add(MyLightEnvironment);
     
        Begin Object Class=StaticMeshComponent Name=PickupMesh
            StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
            Materials(0)=Material'EditorMaterials.WidgetMaterial_Y'
            LightEnvironment=MyLightEnvironment
            Scale3D=(X=0.125,Y=0.125,Z=0.125)
        End Object
        Components.add(PickupMesh)
        myMesh=PickupMesh
        
        
        Begin Object Class=CylinderComponent Name=CollisionCylinder
            CollisionRadius=16.0
            CollisionHeight=16.0
            BlockNonZeroExtent=true
            BlockZeroExtent=true
            BlockActors=true
            CollideActors=true
        End Object
        CollisionComponent=CollisionCylinder
        Components.add(CollisionCylinder)
    }