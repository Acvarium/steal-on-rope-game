extends RigidBody2D
@export var is_debug = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if get_node($Joint.node_b):
		pass
	
