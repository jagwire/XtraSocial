class SampleWeapon extends UTWeapon
    abstract;

const MAX_LEVEL = 5;

var int currentWeaponLevel;
var float FireRates[MAX_LEVEL];

replication
{
    if(bNetDirty) 
        currentWeaponLevel;
   
}

function upgradeWeapon() {
    if(currentWeaponLevel < MAX_LEVEL) {
        currentWeaponLevel++;
        FireInterval[0] = FireRates[currentWeaponLevel - 1];
     
        if(IsInState('WeaponFiring')) {
            ClearTimer(nameof(RefireCheckTimer));
            TimeWeaponFiring(CurrentFireMode);
        }   
        AddAmmo(MaxAmmoCount);
        `log("Current Weapon Level:" @ currentWeaponLevel);
    }
}

defaultproperties
{
    FireRates(0)=0.1
    FireRates(1)=1.0
    FireRates(2)=0.5
    FireRates(3)=0.3
    FireRates(4)=0.1
}