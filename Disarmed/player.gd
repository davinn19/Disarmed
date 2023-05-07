class_name Player
extends Node2D

signal died

onready var anim : AnimationPlayer = $Anim
onready var block_sound : AudioStreamPlayer = $Block
onready var kick_hit : AudioStreamPlayer = $KickHit
onready var slash_hit : AudioStreamPlayer = $SlashHit

export var is_blocking : bool = false
var is_stunned : bool = false


func _process(delta : float) -> void:
	if !is_stunned:
		if Input.is_action_just_pressed("block"):
			anim.play("Put Up Shield")
		
		elif Input.is_action_just_released("block"):
			anim.play("Put Down Shield")
		
		
		
func get_hit(hit_type : String) -> bool:
	if hit_type == "Slash":
		if is_blocking:
			anim.play("Soak Slash")
			block_sound.play()
			return false
		else:
			slash_hit.play()
			die()
			return true
			
	elif hit_type == "Kick":
		if is_blocking:
			anim.play("Stunned")
			is_blocking = false
			is_stunned = true
			kick_hit.play()
			return true
		else:
			anim.play("Soak Kick")
			block_sound.play()
			return false
			
	else:
		print_debug("Something went wrong")
		return false
		

func die() -> void:
	anim.play("Die")
	set_process(false)
	emit_signal("died")
	pass
	
