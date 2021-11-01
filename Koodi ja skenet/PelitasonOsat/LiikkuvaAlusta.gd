extends KinematicBody2D

export var siirto_nopeus: float = 150.0
export var aloita_heti: bool = true
var _toimii: bool = false
export var toista: bool = false
export var tauko: float = 1

# Siirrä alusta haluttuihin kohtiin editorissa ja
# kopioi koordinaatit näihin kohtiin tarkastelussa
export var alkupiste: Vector2
export var loppupiste: Vector2

# onready tarkoittaa että näiden muutujien arvot
# asetetaan vasta kun tämä skene on lisätty peliin
#	Tämä tapahtuu juuri ennen kuin suoritetaan skriptin
#	funktio _ready(), jos sellainen on tehty, mutta
#	sitä ei vaadita
onready var _ajastin = $Timer
onready var _tavoitepiste = loppupiste

# Voidaan käynnistää tai sammuttaa tämän funktion avulla
func aloita_siirto(toimii: bool):
	_toimii = toimii

func _ready():
	global_position = alkupiste
	# set_deferred("muuttujan_nimi", arvo) asettaa
	# arvon myöhemmin, seuraavalla päivityksellä
	if aloita_heti:
		set_deferred("_toimii", true)

# Ehtolauseiden yhdistelmällä voidaan
# luoda monimutkaisempia toimintoja
func _physics_process(delta):
	if _toimii:
		if global_position != _tavoitepiste:
			global_position = global_position.move_toward(
							_tavoitepiste,
							siirto_nopeus * delta
							)
		else:
			if _tavoitepiste == alkupiste:
				_tavoitepiste = loppupiste
			else:
				_tavoitepiste = alkupiste
			
			if toista:
				if tauko > 0:
					_toimii = false
					_ajastin.start(tauko)
			else:
				_toimii = false


func _on_Timer_timeout():
	_toimii = true
