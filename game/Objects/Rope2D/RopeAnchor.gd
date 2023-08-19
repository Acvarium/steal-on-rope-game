extends CharacterBody2D
var rope_seg_preload = preload("res://Objects/Rope2D/rope_segment.tscn")
@export_node_path("RigidBody2D") var body_path
var body : RigidBody2D
@export_node_path("Node2D") var segment_holder
var body_joint: PinJoint2D

const SPEED = 700.0
const V_SPEED = 5.0
var rope_seg: RigidBody2D 
var rope_joint: PinJoint2D
var rope_sprite: Sprite2D


func _ready():
	body = get_node(body_path)
	body_joint = body.get_node("Joint")
	build_rope()


func change_rope_length(length_diff):
	var body_node_b = body_joint.node_b
	body_joint.node_b = ""
	var rope_dir = (body_joint.global_position - rope_joint.global_position).normalized()
	body.position += rope_dir * length_diff * V_SPEED
	var rope_node_b = rope_joint.node_b
	rope_joint.node_b = ""
	rope_seg.look_at(body_joint.global_position)
	rope_seg.global_position = global_position
	rope_joint.node_b = rope_node_b
	body_joint.node_b = body_node_b
	update_rope_sprite(rope_joint.global_position.distance_to(body_joint.global_position))


func update_rope_sprite(new_length):
	rope_sprite.scale.y = new_length / 64


func build_rope():
	body.global_position.x = global_position.x
	var rope_lenght = global_position.distance_to(body.global_position)

	rope_seg = rope_seg_preload.instantiate()
	rope_sprite = rope_seg.get_node("Sprite2D")
	update_rope_sprite(rope_lenght)
	rope_joint = rope_seg.get_node("Joint")
	get_node(segment_holder).add_child(rope_seg)
	rope_seg.position = position
	rope_seg.look_at(body_joint.global_position)
	rope_joint.node_b = self.get_path()
	body.position = rope_seg.position + Vector2(0, rope_lenght) - \
		body_joint.position
	body_joint.node_b = rope_seg.get_path()


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
