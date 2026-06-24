class_name PlanarAudio extends Node2D

@export var song: Texture2D

func _ready():
	var sound_file = FileAccess.open("res://song.raw", FileAccess.WRITE)
	
	# where we're slicing
	var angle := 0.0
	var offset := Vector2.ZERO
	
	# song
	var song_image := song.get_image()
	var seconds_in_a_pixel := 0.25
	var ray_start := Vector3(offset.x, offset.y, 0.5)
	var ray_dir := Vector3(cos(angle), sin(angle), 0.0)
	var diagonal := song.get_size().length()
	var intersection = AABB(Vector3.ZERO, Vector3(song.get_width(), song.get_height(), 1.0)).intersects_ray(ray_start + (ray_dir * diagonal * 2.0), -ray_dir)
	if !intersection:
		print("what!!!")
		return
	var length := ray_start.distance_to(intersection)
	
	print(length)
	
	for i in 44100 * length * seconds_in_a_pixel:
		var time := float(i) / 44100.0
		
		var color := song_image.get_pixel(
			int(floor((time / seconds_in_a_pixel) + offset.x)) * cos(angle),
			int(floor((time / seconds_in_a_pixel) + offset.y)) * sin(angle)
		)
		
		var frequency := pow(2.0, color.h * 4.0) * 64.0
		
		sound_file.store_16(compute_tone(time, frequency, color.v))
	
	sound_file.close()

func compute_tone(time: float, frequency: float, amplitude: float) -> int:
	return sin(time * TAU * frequency) * amplitude * 4096.0
