class SampleGameReplicationInfo extends UTGameReplicationInfo;

var bool bSpawnBoss;
var float nextWaveTime;
var int enemiesLeft;
var SampleEnemy theBoss;

replication
{
    if(bNetDirty)
        bSpawnBoss, nextWaveTime, enemiesLeft, theBoss;
}
    
defaultproperties
{
}   