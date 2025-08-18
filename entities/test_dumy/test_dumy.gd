extends CharacterBody3D
class_name TestDumy

@export var damage_info : DamageInfo

func test_damage() -> void:
	CharterStats.deal_damage_to(self,damage_info)
