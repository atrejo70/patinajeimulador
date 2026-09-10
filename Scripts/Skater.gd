extends RigidBody2D
class_name Skater

enum Stance { UPRIGHT, TUCK }
var current_stance: Stance = Stance.UPRIGHT

# Parámetros físicos configurables desde la UI
var mass_kg: float = 80.0
var slope_deg: float = 5.0
var wheel_size_mm: float = 80.0
var max_distance_m: float = 100.0

# Constantes del entorno
const G: float = 9.81
const AIR_DENSITY: float = 1.225

# Propiedades aerodinámicas dinámicas según postura
var drag_coeff: float:
	get:
		return 0.9 if current_stance == Stance.UPRIGHT else 0.5

var front_area: float:
	get:
		return 0.55 if current_stance == Stance.UPRIGHT else 0.30

# Variables de estado interno
var current_distance: float = 0.0
var current_acceleration: float = 0.0
var initial_pos: Vector2
var is_simulating: bool = false

func _ready() -> void:
	initial_pos = global_position
	freeze = true

func start_simulation() -> void:
	global_position = initial_pos
	linear_velocity = Vector2.ZERO
	current_distance = 0.0
	freeze = false
	is_simulating = true

func reset_simulation() -> void:
	freeze = true
	global_position = initial_pos
	linear_velocity = Vector2.ZERO
	current_distance = 0.0
	current_acceleration = 0.0
	is_simulating = false

func _physics_process(_delta: float) -> void:
	if not is_simulating:
		return

	var v: float = linear_velocity.length()
	var angle_rad: float = deg_to_rad(slope_deg)

	# 1. Componente de Gravedad en la Pendiente
	var f_gravity: float = mass_kg * G * sin(angle_rad)

	# 2. Resistencia de Rodamiento (Inversamente proporcional al tamaño de la rueda)
	var c_rr: float = (0.002 * 80.0) / wheel_size_mm
	var f_rolling: float = c_rr * mass_kg * G * cos(angle_rad)

	# 3. Resistencia del Aire (Cuadrática)
	var f_air: float = 0.5 * AIR_DENSITY * drag_coeff * front_area * (v * v)

	# Fuerza Neta
	var f_net: float = max(0.0, f_gravity - f_rolling - f_air)
	current_acceleration = f_net / mass_kg

	# Aplicar fuerza en la dirección de la pendiente
	var force_dir: Vector2 = Vector2.RIGHT.rotated(angle_rad)
	apply_central_force(force_dir * f_net)

	# Distancia recorrida (Escala: 50 píxeles = 1 metro)
	current_distance = global_position.distance_to(initial_pos) / 50.0

	if current_distance >= max_distance_m:
		freeze = true
		is_simulating = false
