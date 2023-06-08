# Coordinates the generation and drawing of road segments and buildings

extends Node2D


const CityGen = preload("res://scripts/city_gen.gd")

var generated_segments: = []
var generated_buildings: = []

@onready var city_gen: CityGen = $CityGen
@onready var population_heatmap = $PopulationHeatmap


func _ready():
	run()


func _draw():
	for segment in generated_segments:
		var width: = 20 if segment.metadata.highway else 1
		draw_line(segment.start, segment.end, Color8(161, 175, 165), width)
	for building in generated_buildings:
		var corners: PackedVector2Array = building.generate_corners()
		draw_colored_polygon(corners, Color8(12, 22, 31))


func run():
	for segment in generated_segments:
		segment.free()
	for building in generated_buildings:
		building.free()

	city_gen.randomize_heatmap()
	generated_segments = city_gen.generate_segments()
	generated_buildings = city_gen.generate_buildings(generated_segments)

	# trigger redraw
	queue_redraw()


func _on_generate_button_pressed() -> void:
	run()

func _on_heatmap_checkbox_toggled(button_pressed: bool) -> void:
	population_heatmap.visible = button_pressed
