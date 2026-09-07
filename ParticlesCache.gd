extends CanvasLayer

var electricParticles := preload("res://assets/Materials/electric_particles.tres")
var hueShiftShaderMat := preload("res://Minigames/CodeWrite/hue_shift_shader.tres")
#I don't think I need to cache the transition or title screen shader
# since they'llbe used right at the start anyways before the game begins

var materials = [
	electricParticles, 
	hueShiftShaderMat,
]

func _ready() -> void:
	for material in materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.process_material = particles_instance
		particles_instance.one_shot = true
		particles_instance.modulate = Color(1,1,1,0)
		particles_instance.emitting = true
		self.add_child(particles_instance)
