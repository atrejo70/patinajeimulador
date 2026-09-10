extends Node2D

@onready var skater: Skater = $Skater
@onready var graph: GraphView = $UI/GraphView

@onready var slider_mass: Slider = $UI/Panel/SliderMass
@onready var slider_slope: Slider = $UI/Panel/SliderSlope
@onready var slider_wheels: Slider = $UI/Panel/SliderWheels
@onready var slider_dist: Slider = $UI/Panel/SliderDistance
@onready var option_stance: OptionButton = $UI/Panel/OptionStance

@onready var lbl_speed: Label = $UI/Metrics/LblSpeed
@onready var lbl_accel: Label = $UI/Metrics/LblAccel
@onready var lbl_dist: Label = $UI/Metrics/LblDist

var elapsed_time: float = 0.0

func _ready() -> void:
	$UI/BtnStart.pressed.connect(_on_start_pressed)
	$UI/BtnReset.pressed.connect(_on_reset_pressed)
	
	# Opciones de postura
	option_stance.clear()
	option_stance.add_item("Erguido (Upright)", 0)
	option_stance.add_item("Tuck (Aerodinámico)", 1)

func _process(delta: float) -> void:
	if skater.is_simulating:
		elapsed_time += delta
		var v_mps: float = skater.linear_velocity.length()
		var a_mps2: float = skater.current_acceleration

		lbl_speed.text = "Velocidad: %.1f km/h" % (v_mps * 3.6)
		lbl_accel.text = "Aceleración: %.2f m/s²" % a_mps2
		lbl_dist.text = "Distancia: %.1f / %.0f m" % [skater.current_distance, skater.max_distance_m]

		graph.add_data_point(elapsed_time, v_mps, a_mps2)

func _on_start_pressed() -> void:
	skater.mass_kg = slider_mass.value
	skater.slope_deg = slider_slope.value
	skater.wheel_size_mm = slider_wheels.value
	skater.max_distance_m = slider_dist.value
	skater.current_stance = Skater.Stance.UPRIGHT if option_stance.selected == 0 else Skater.Stance.TUCK

	elapsed_time = 0.0
	graph.clear()
	skater.start_simulation()

func _on_reset_pressed() -> void:
	elapsed_time = 0.0
	graph.clear()
	skater.reset_simulation()
	lbl_speed.text = "Velocidad: 0.0 km/h"
	lbl_accel.text = "Aceleración: 0.0 m/s²"
	lbl_dist.text = "Distancia: 0.0 m"
