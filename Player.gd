extends KinematicBody2D

const move_speed = 500
const jump_force = 1000
const gravity = 50
const max_fall_speed = 1000

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_velocity = 0
var facing_right = false

func _physics_process(delta):
	var move_direction = 0
	if Input.is_action_pressed("move_right"):
		move_direction += 1
	if Input.is_action_pressed("move_left"):
		move_direction -= 1
	move_and_slide(Vector2(move_direction * move_speed, y_velocity), Vector2(0, -1))
	
	var grounded = is_on_floor()
	y_velocity += gravity
	if grounded and Input.is_action_pressed("jump"):
		y_velocity = -jump_force
	if grounded and y_velocity >= 5:
		y_velocity = 5
	if y_velocity > max_fall_speed:
		y_velocity = max_fall_speed
	
	if facing_right and move_direction < 0:
		flip()
	if !facing_right and move_direction > 0:
		flip()
	
	if grounded:
		if move_direction == 0:
			play_anim("idle")
		else:
			play_anim("walk")
	else: 
		play_anim("jump")
	
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
			
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)

