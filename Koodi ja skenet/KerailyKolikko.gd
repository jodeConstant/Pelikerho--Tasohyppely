extends Area2D

# Tämä yhdistää automaattisesti Area2D:stä löytyvän signaalin tässä
# skriptissä olevaan funktioon _on_PoimittavaEsine_body_entered(body)
#	Huomaa että
#		- funktioon ja signaaliin viitataan nimillä tekstin muodossa
#		- sulkeita sekä niiden sisältöä ei mainita
func _ready():
	connect("body_entered", self, "_on_KerailyKolikko_body_entered")


func _on_KerailyKolikko_body_entered(body):
	if body is KinematicBody2D:
		print_debug("Kolikko poimittu!")
		Peli.lisaa_kolikko()
		queue_free()
