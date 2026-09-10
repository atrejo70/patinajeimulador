extends Control
class_name GraphView

var speed_history: Array[float] = []
var accel_history: Array[float] = []
var time_history: Array[float] = []

@export var max_time: float = 30.0
@export var max_speed_kmh: float = 80.0
@export var max_accel: float = 5.0

func add_data_point(time: float, speed_mps: float, accel_mps2: float) -> void:
	time_history.append(time)
	speed_history.append(speed_mps * 3.6) # m/s a km/h
	accel_history.append(accel_mps2)
	queue_redraw()

func clear() -> void:
	time_history.clear()
	speed_history.clear()
	accel_history.clear()
	queue_redraw()

func _draw() -> void:
	var rect: Rect2 = get_rect()
	var w: float = rect.size.x
	var h: float = rect.size.y

	# Fondo del gráfico
	draw_rect(Rect2(Vector2.ZERO, rect.size), Color(0.08, 0.09, 0.12, 0.92))

	# Ejes X e Y
	draw_line(Vector2(40, h - 30), Vector2(w - 10, h - 30), Color(0.6, 0.6, 0.6), 2.0)
	draw_line(Vector2(40, h - 30), Vector2(40, 10), Color(0.6, 0.6, 0.6), 2.0)

	if time_history.size() < 2:
		return

	var graph_w: float = w - 50.0
	var graph_h: float = h - 40.0

	# Renderizar curvas en overlay
	for i in range(1, time_history.size()):
		var x1: float = 40 + (time_history[i - 1] / max_time) * graph_w
		var x2: float = 40 + (time_history[i] / max_time) * graph_w

		# Velocidad (Azul)
		var y_v1: float = (h - 30) - (speed_history[i - 1] / max_speed_kmh) * graph_h
		var y_v2: float = (h - 30) - (speed_history[i] / max_speed_kmh) * graph_h
		draw_line(Vector2(x1, y_v1), Vector2(x2, y_v2), Color.DODGER_BLUE, 2.0)

		# Aceleración (Rojo)
		var y_a1: float = (h - 30) - (accel_history[i - 1] / max_accel) * graph_h
		var y_a2: float = (h - 30) - (accel_history[i] / max_accel) * graph_h
		draw_line(Vector2(x1, y_a1), Vector2(x2, y_a2), Color.CORAL, 2.0)
