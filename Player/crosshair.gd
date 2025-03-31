@tool
extends Control

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4, Color.DIM_GRAY)
	draw_circle(Vector2.ZERO, 3, Color.WHITE)
	
	var line_start = 16
	var line_end = 24
	var white = Color.WHITE
	
	draw_line(Vector2(line_start, 0), Vector2(line_end , 0), white)
	draw_line(Vector2(-line_start, 0), Vector2(-line_end , 0), white)
	draw_line(Vector2(0, line_start), Vector2(0, line_end ), white)
	draw_line(Vector2(0, -line_start), Vector2(0, -line_end), white)
