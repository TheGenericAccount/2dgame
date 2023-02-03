extends KinematicBody2D
enum Direction{
	left=-1, right=1
}

enum State{
	moving, attacking
}

export (Direction) var move_dir=Direction.right
export (float) var speed=150
export (float) var damage=10

var curr_state=State.moving
var target=null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var velocity=Vector2.ZERO

func updateState():
	match curr_state:
		State.moving:
			velocity.x=speed*move_dir
		State.attacking:
			velocity.x=0

func _ready():
	updateState()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_collide(velocity*delta)


func _on_DetectionRight_area_entered(area):
	curr_state=State.attacking
	move_dir=Direction.right
	target=area.get_parent()
	$AttackTimer.start()
	updateState()


func _on_DetectionLeft_area_entered(area):
	curr_state=State.attacking
	move_dir=Direction.left
	target=area.get_parent()
	$AttackTimer.start()
	updateState()

func stopAttack():
	$AttackTimer.stop()
	curr_state=State.moving
	updateState()

func _on_DetectionRight_area_exited(area):
	stopAttack()


func _on_DetectionLeft_area_exited(area):
	stopAttack()
	
func _on_AttackTimer_timeout():
	#TODO animate
	if !is_instance_valid(target) or !target.has_method("damage"):
		stopAttack()
		return
	target.damage(damage)
	


