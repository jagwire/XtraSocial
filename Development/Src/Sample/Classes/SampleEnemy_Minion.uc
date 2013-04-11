class SampleEnemy_Minion extends SampleEnemy;

event TakeDamage(int damageAmount,
                 Controller eventInstigator,
                 vector hitLocation,
                 vector momentum,
                 class<DamageType> damageType,
                 optional TraceHitInfo hitInfo,
                 optional Actor damageCauser)                                   
{                
    if(SampleGame(WorldInfo.game) != none) {
        SampleGame(WorldInfo.game).enemyKilled();   
    }
   
    Destroy();
}


simulated function runAway() {
    GoToState('Fleeing');
    bFleeing = true;
}

defaultproperties
{
}
      