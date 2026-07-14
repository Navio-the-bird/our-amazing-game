extends CharacterBody3D
class_name Entity

const DEFAULT_SPEED: float = 5.0
#const DEFAULT_JUMP_VELOCITY = 4.5

const DEFAULT_MAX_HEALTH: int = 100


var current_speed: float
var current_max_health: int
var current_health: int


@export var effects: Array[Effect]:
	set(value):
		if effects != value:
			effects = value
			_caculate_current_stats()

func _caculate_current_stats():
	for effect in effects:
		if effect.name_of_the_thing_to_change in self:
			var current_value = self.get(effect.name_of_the_thing_to_change)
			if current_value is int or current_value is float:
				var new_value = current_value + effect.modification
				self.set(effect.name_of_the_thing_to_change, new_value)
			else:
				self.set(effect.name_of_the_thing_to_change, effect.modification)


func _physics_process(delta: float) -> void:
	movement(delta)
	update_effect(delta)

func update_effect(delta: float) -> void:
	for effect in effects:
		effect.remaining_duration -= delta

func movement(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * DEFAULT_SPEED
		velocity.z = direction.z * DEFAULT_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, DEFAULT_SPEED)
		velocity.z = move_toward(velocity.z, 0, DEFAULT_SPEED)

	move_and_slide()
