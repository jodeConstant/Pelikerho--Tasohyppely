extends Area2D

onready var _kuva = $Sprite

# tila on:
#	false jos kytkin on pois päältä
#	true jos kytkin on päällä
export var tila: bool = false

# Tämä signaali lähetetään kun kytkintä käytetään
signal tila_muuttunut(kytkimen_tila)

# Tämä funktio kutsutaan kun kytkintä käytetään
#	Se lähettää myös sen signaalin, joka pitää
#	olla yhdistetty johonkin
func kayta_kytkinta():
	tila = !tila
	if tila:
		_kuva.frame = 1
	else:
		_kuva.frame = 0
	emit_signal("tila_muuttunut", tila)
	

# Jos 2 kytkintä vaikuttavat samaan kohteeseen,
# voidaan kytkeä 'tila_muuttunut' signaali tähän.
# Tämä muuttaa kytkimen tilaa, mutta ei lähetä
# omaa signaalia
func _aseta_tila(t: bool):
	tila = t
	if tila:
		_kuva.frame = 1
	else:
		_kuva.frame = 0
	

# Asetetaan kuva alussa tilan mukaan
func _ready():
	if tila:
		_kuva.frame = 1
	else:
		_kuva.frame = 0

# Yhdistetään Pelaajan signaali tähän
# kun se tulee kosketuksiin...
func _on_Kytkin_body_entered(body):
	if body is Pelaaja:
		body.connect("kaytto", self, "kayta_kytkinta")

# ...ja katkaistaan kun se poistuu
func _on_Kytkin_body_exited(body):
	if body is Pelaaja:
		body.disconnect("kaytto", self, "kayta_kytkinta")
