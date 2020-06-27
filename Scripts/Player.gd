extends Area2D

# params
export var speed = 3

var tile_size = 64
var inputs ={
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}

onready var ray = $RayCast2D as RayCast2D
onready var tween = $Tween as Tween

# funcs
func is_ray_colliding(dir: Vector2):
	ray.cast_to = dir * tile_size
	ray.force_raycast_update()
	return ray.is_colliding()

func move(to: Vector2):
	# 障害物を確認
	if not is_ray_colliding(to):
		# position += inputs[dir] * tile_size
		move_tween(to)


func move_tween(to: Vector2):
	tween.interpolate_property(self, "position",
		position, position + to * tile_size,
		1.0/speed,
	Tween.TRANS_LINEAR)
	tween.start()


# virtual funcs
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

# _input: OSなどの標準入力イベント
# _input_event: GUIボタンやテキストボックスの入力イベント
# _unhandled_event: それ以外の入力
# func _unhandled_input(event: InputEvent):
#     if tween.is_active():
#         return
#     for dir in inputs.keys():
#         if event.is_action_pressed(dir):
#             var to = inputs[dir]
#             move(to)

func _process(_delta):
	if tween.is_active():
		return
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			var to = inputs[dir]
			move(to)
