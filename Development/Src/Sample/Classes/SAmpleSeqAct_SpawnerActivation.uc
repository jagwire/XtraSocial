class SAmpleSeqAct_SpawnerActivation extends SeqAct_Latent;


var() int waveSize, waveTimer;

event Activated() {
    if(SampleGame(GetWorldInfo().Game) != none) {
        SampleGame(GetWorldInfo().Game).startWave(waveSize, waveTimer);
        OutputLinks[0].bHasImpulse=true;
    }   
}

event bool update(float dt) {
    if(SampleGame(GetWorldInfo().Game) != none && SampleGame(GetWorldInfo().Game).nextWaveTime > 0) {
        return true;
    }
 
    OutputLinks[1].bHasImpulse=true;
    return false;   
}

defaultproperties 
{
    waveSize=10
    waveTimer=5
    ObjName="Spawner Activation"
    ObjCategory="Sample Game"  
    VariableLinks.empty 
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int', LinkDesc="Wave Size", PropertyName=WaveSize)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int', LinkDesc="Wave Timer", PropertyName=WaveTimer)
    OutputLinks(0) = (LinkDesc="Out")
    OutputLinks(1) = (LinkDesc="Finished")
    bAutoActivateOutputLinks=false
}