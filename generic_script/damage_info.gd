extends Resource
class_name DamageInfo

enum Factions {NONE,FRIEND,ENEMY}

@export var damage : int = 1
@export var faction : Factions = Factions.NONE
