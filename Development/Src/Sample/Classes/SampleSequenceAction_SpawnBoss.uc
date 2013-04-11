class SampleSequenceAction_SpawnBoss extends SequenceAction;


event activated() {
    if(SampleGame(GetWorldInfo().Game) != none) {
        SampleGame(GetWorldInfo().Game).spawnBoss();
    }   
}

defaultproperties 
{
    ObjName="Spawn Boss"
    ObjCategory ="Sample Game"
    VariableLinks.Empty
}