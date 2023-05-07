class_name Enemy
extends Node2D

onready var anim : AnimationPlayer = $Anim
onready var cooldown_timer : Timer = $Cooldown

var attack_success : bool = false

var player : Player


func _ready() -> void:
	yield(self, "ready")
	player = get_node("../Player")
	

func enable():
	cooldown_timer.connect("timeout", self, "attack")
	cooldown_timer.start(1)

	
func attack() -> void:
	print("hey")
	var attack_type : String
	
	var rand : float = randf()
	
	if player.is_stunned:
		attack_type = "Slash"
	elif rand < 0.1:
		attack_type = "Kick"
	elif player.is_blocking:
		attack_type = "Kick"
	else:
		attack_type = "Slash"
		
	anim.play(attack_type)
	yield(anim, "animation_finished")
	
	if attack_success:
		if attack_type == "Slash":
			cooldown_timer.disconnect("timeout", self, "attack")
		else:	# kick landed, finish him
			cooldown_timer.start(0.05)
	else:
		cooldown_timer.start(get_cooldown())
		

func hit_player(hit_type : String):
	attack_success = player.get_hit(hit_type)
		

func get_cooldown() -> float:
	var temp = 0.6 + rand_range(-0.15, 0.15)
	return temp
	
