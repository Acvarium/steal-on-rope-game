extends CharacterBody2D
var rope_seg_preload = preload("res://Objects/Rope2D/rope_segment.tscn")
@export_node_path("RigidBody2D") var body_path
var body : RigidBody2D
@export_node_path("Node2D") var segment_holder
var body_joint: PinJoint2D
var rope_sprite : Sprite2D
const SPEED = 400.0
const V_SPEED = 2.0

func _ready():
	body = get_node(body_path)
	body_joint = body.get_node("Joint")
	build_rope(1)


func change_rope_length(length_diff):
	var node_b = body_joint.node_b
	body_joint.node_b = ""
	var rope_dir = (body_joint.global_position - global_position).normalized()
	body.position += rope_dir * length_diff * V_SPEED
	body_joint.node_b = node_b
	update_rope_sprite(global_position.distance_to(body_joint.global_position))

func update_rope_sprite(new_length):
	rope_sprite.scale.y = new_length / 64

func build_rope(number_of_segments):
	var current_seg: RigidBody2D = null
	var next_seg_joint_pos = Vector2(0, 3400)
	for i in range(number_of_segments):
		
		var next_seg: RigidBody2D = rope_seg_preload.instantiate()
		rope_sprite = next_seg.get_node("Sprite2D")
		update_rope_sprite(3400)
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
	var body_joint = body.get_node("Joint")
	body.position = current_seg.position + next_seg_joint_pos - \
		body_joint.position
	body_joint.node_b = current_seg.get_path()


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	var v_direction = Input.get_axis("ui_up", "ui_down")
	if v_direction:
		change_rope_length(v_direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
