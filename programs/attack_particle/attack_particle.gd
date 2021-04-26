extends Sprite

export (Array, Curve) var trajectories
export (float) var time = 1.0
export (float) var min_height = 100.0
export (float) var max_height = 200.0
export (Vector2) var destination

var start: Vector2
var direction: Vector2
var tangent: Vector2
var height = min_height
var passed_time = 0.0
var trajectory: Curve

func _ready():
	randomize()

func begin(flipped=false):
	start = global_position
	direction = (destination - start).normalized()
	tangent = direction.tangent()
	if flipped:
		tangent *= -1
	height = rand_range(min_height, max_height)
	trajectory = trajectories[randi() % len(trajectories)]

func _physics_process(delta):
	passed_time += delta
	var ratio = min(passed_time, time) / time
	var offset = tangent * trajectory.interpolate(ratio) * height
	global_position = start.linear_interpolate(destination, ratio) + offset
	if ratio >= 1.0:
		queue_free()
