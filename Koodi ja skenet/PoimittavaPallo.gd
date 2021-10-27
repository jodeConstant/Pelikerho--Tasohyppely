extends Area2D

export var maara: int = 1

# Tämä yhdistää automaattisesti Area2D:stä löytyvän signaalin tässä
# skriptissä olevaan funktioon _on_PoimittavaEsine_body_entered(body)
#	Huomaa että
#		- funktioon ja signaaliin viitataan nimillä tekstin muodossa
#		- sulkeita sekä niiden sisältöä ei mainita
func _ready():
	connect("body_entered", self, "_on_Ammus_body_entered")


func _on_Ammus_body_entered(body):
	if body is Pelaaja:
		#if body.has_method("lisaa_palloja"):
		body.lisaa_palloja(maara)
		# Muista yhdistää Pelaaja:n signaali
		# Käyttöliittymään käsin skenessä
		print_debug(str(maara) + " palloa poimittu!")
		queue_free()
