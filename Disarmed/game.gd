extends Node2D

signal blocked

onready var enemy : Enemy = $Enemy
onready var player : Player = $Player
onready var anim : AnimationPlayer = $Anim
onready var start : Control = $CanvasLayer/Start
onready var game_over : Control = $CanvasLayer/GameOver


func _ready() -> void:
	player.connect("died", self, "end_game")
	connect("blocked", self, "start_game")
	
	
func _process(delta : float) -> void:
	if Input.is_action_just_pressed("block"):
		emit_signal("blocked")
	
	
func start_game() -> void:
	start.visible = false
	game_over.visible = false
	$CanvasLayer/Blood.color = Color.transparent
	
	enemy.enable()
	
	player.position = Vector2.ZERO
	player.set_process(true)
	player.anim.play("Put Down Shield")
	player.is_stunned = false
	
	disconnect("blocked", self, "start_game")


func end_game() -> void:
	anim.play("End Game")
	yield(anim, "animation_finished")
	yield(get_tree().create_timer(1), "timeout")

	game_over.visible = true
	connect("blocked", self, "start_game")
	pass
