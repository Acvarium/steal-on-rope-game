extends CharacterBody2D
var rope_seg_preload = preload("res://Objects/Rope2D/rope_segment.tscn")
@export_node_path("RigidBody2D") var body_path
@export_node_path("Node2D") var segment_holder

const SPEED = 300.0

func _ready():
	pass
	build_rope(1)

func build_rope(number_of_segments):
	var current_seg: RigidBody2D = null
	var next_seg_joint_pos = Vector2(0, 3400)
	for i in range(number_of_segments):
		
		var next_seg: RigidBody2D = rope_seg_preload.instantiate()
		var sprite_scale = (next_seg_joint_pos.y / 64)
		print(sprite_scale)
		next_seg.get_node("Sprite2D").scale.y = sprite_scale
		var next_joint: PinJoint2D = next_seg.get_node("Joint")
		get_node(segment_holder).add_child(next_seg)
		var next_pos = position
		if (current_seg):
			next_pos = current_seg.position + next_seg_joint_pos
		next_seg.position = next_pos
			
		next_joint.node_b = self.get_path()
		if (current_seg):
			next_joint.node_b = current_seg.get_path()
		print(next_seg)
		current_seg = next_seg
	var body_joint = get_node(body_path).get_node("Joint")
	get_node(body_path).position = current_seg.position + next_seg_joint_pos - \
		body_joint.position
	body_joint.node_b = current_seg.get_path()


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
