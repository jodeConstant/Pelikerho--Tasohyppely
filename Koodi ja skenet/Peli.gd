extends Node

# Näillä saadaan tulostettua aika nätissä muodossa
onready var _sekunnit: float = 0
onready var _minuutit: int = 0
onready var _tunnit: int = 0
var _muotoilu = "%02d:%02d:%02d"
var aika_teksti: String

onready var kolikoiden_maara: int = 0

var _seuraavan_tason_polku: String

signal taso_ohi
signal peli_ohi		#tappio

signal kolikkojen_maara_muuttui(maara)

func lisaa_kolikko():
	kolikoiden_maara += 1
	emit_signal("kolikkojen_maara_muuttui", kolikoiden_maara)

func nollaa_tiedot():
	_sekunnit = 0
	_minuutit = 0
	_tunnit = 0
	aika_teksti = "00:00:00"
	kolikoiden_maara = 0

func tappio():
	emit_signal("peli_ohi")

func aloita_taso_alusta():
	nollaa_tiedot()
	# Käynnistetään skene uudelleen
	get_tree().reload_current_scene()
	get_tree().paused = false


# Asetetaan peli tauolle, näytetään valikko ja
# asetetaan seuraavan tason polku
func taso_suoritettu(var seuraavan_polku: String):
	if seuraavan_polku:
		_seuraavan_tason_polku = seuraavan_polku
	# Näytä suoritus
	emit_signal("taso_ohi")

# Jos seurravaa tasoa ei ole jostain syystä asetettu,
# tämä funktio ei tee mitään
func jatka_seuraavalta_tasolta():
	if _seuraavan_tason_polku:
		get_tree().change_scene(_seuraavan_tason_polku)


func _process(delta):
	# 'delta' on kulunut aika sekunneissa, joten
	# lisätään se vastaavaan muuttujaan
	_sekunnit += delta
	# Jos sekunteja on kertynyt yli 60, vähennetään siitä
	# ja lisätään minuutti sen sijaan
	if _sekunnit >= 60.0:
		_sekunnit -= 60.0
		_minuutit += 1
		# Jos nyt minuutteja on yli 60, vähennetään sen
		# verran ja lisätään tunti
		if _minuutit >= 60:
			_minuutit -= 60
			_tunnit += 1
	# Lopuksi päivitetään teksti, tunnit vasemmalla jne.
	#	Tämä asettaa hakasuluissa olevat arvot _muotoilu
	#	-tesktin sopivien kohtien tilalle. Tässä ei tarvitse
	#	välittää yksityiskohdista.
	aika_teksti = _muotoilu % [_tunnit, _minuutit, _sekunnit]
