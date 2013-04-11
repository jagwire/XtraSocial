class SampleSequenceAction_GetWeaponLevel extends SequenceAction;

var int weaponLevel;

event activated() {
    local PlayerController controller;
    
    controller = GetWorldInfo().getALocalPlayerController();
    
    if(controller != none && controller.pawn != none && SampleWeapon(controller.pawn.weapon) != none) {
        weaponLEvel = SampleWeapon(controller.pawn.weapon).currentWeaponLevel;   
    }
}

defaultproperties
{
    objname="Get Weapon Level"
    objcategory="Sample Game"
    variablelinks(0) = (ExpectedType=class'SeqVar_Int', LinkDesc="Weapon Level", PropertyName=WeaponLEvel, bWriteable=true)   
}