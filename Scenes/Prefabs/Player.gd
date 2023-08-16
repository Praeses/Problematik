extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity = 0.001
var twist_input := 0.0
var pitch_input := 0.0
var tool_index := 0
var new_tool_index := 0
var switching_tool := false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var twist := $Twist
@onready var pitch := $Twist/Pitch
@onready var tool_bar_hud := [
	$ToolHud/Tool1,
	$ToolHud/Tool2,
	$ToolHud/Tool3,
	$ToolHud/Tool4,
	$ToolHud/Tool5
]
@onready var tool_animation_player := $Twist/Pitch/Tool/AnimationPlayer
@onready var tools := [
	$Twist/Pitch/Tool/Tool1, 
	$Twist/Pitch/Tool/Tool2, 
	$Twist/Pitch/Tool/Tool3, 
	$Twist/Pitch/Tool/Tool4,
	$Twist/Pitch/Tool/Tool5
]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	tool_bar_hud[0].modulate = Color.PURPLE

func _process(delta):
	if Input.is_action_just_pressed("swtich_tool_1") and !switching_tool:
		new_tool_index = 0
		switch_tool()

	if Input.is_action_just_pressed("swtich_tool_2") and !switching_tool:
		new_tool_index = 1
		switch_tool()
		
	if Input.is_action_just_pressed("swtich_tool_3") and !switching_tool:
		new_tool_index = 2
		switch_tool()

	if Input.is_action_just_pressed("swtich_tool_4") and !switching_tool:
		new_tool_index = 3
		switch_tool()

	if Input.is_action_just_pressed("swtich_tool_5") and !switching_tool:
		new_tool_index = 4
		switch_tool()

func switch_tool():
	tool_animation_player.play("Holster")
	switching_tool = true

func _physics_process(delta):
	#TODO: Not sure if we need this here but this frees up the mouse on an escape button press
	#	could be useful to tirgger a menu to pop up as well
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_move_left", "player_move_right", "player_move_forward", "player_move_back")
	var direction = (twist.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	twist.rotate_y(twist_input)
	pitch.rotate_x(pitch_input)
	pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Holster"):
		tools[tool_index].hide()
		tool_bar_hud[tool_index].modulate = Color.WHITE
		
		tools[new_tool_index].show()
		tool_bar_hud[new_tool_index].modulate = Color.PURPLE
		tool_index = new_tool_index
		tool_animation_player.play("Draw")
	if(anim_name == "Draw"):
		switching_tool = false
