# Tämä skripti laajentaa KinematicBody2D -solmun toimintoja
extends KinematicBody2D
# Annetaan tässä skriptissä luodulle luokalle erikseen nimi
class_name Pelaaja

# 'export' avainsana tekee muuttujasta näkyvän
# Tarkastelu-ikkunassa/välilehdellä ja mhdollistaa
# sen muuttamisen erikseen skriptistä
export var nopeus: float = 370.0
# Kaksoispiste tarkoittaa että muuttujan tyyppiä ei voida muuttaa
# Voidaan kirjoittaa myös näin:
export var putoamiskiihtyvyys: = 980.0
export var hypyn_voimakkuus: = 550.0
# Yllä olevien muuttujien tyyppi tulee olemaan desimaaliluku
# ja sitä ei voida muuttujan luomisen jälkeen jälkeen muuttaa

# Tämä on luokan sisäinen muuttuja:
var _nopeus_vektori: Vector2 = Vector2.ZERO
# Alaviiva nimen edessä ilmaisee että
# tätä muuttujaa ei pidä muokata tämän
# skriptin ulkopuolelta
#	Vector2.ZERO on sama kuin Vector2(0,0)

# Tämä vektori asettaa pelaajan maahan tarttumisen suunnan
var _tarttumis_vektori: Vector2 = Vector2(0,32)
# Maahan tarttumista tarvitaan jos:
#	- käytetään liikkuvia osia pelitasossa ja pelissä on painovoima
#	- pelaajan pitää tarttua johonkin pintaan
# käytetään 'move_and_slide_with_snap' funktion kanssa
# osoittaa painovoiman suuntaan, pituus pelaajan koon mukaan

export var voi_liikkua: bool = true

export var suunta_oikealle: bool = true
onready var _animoitu_kuva = $AnimatedSprite


onready var _pallonheitin = $PallonHeitin
export var pallot_max: int = 10
export var pallot: int = 0

signal laukaus
signal kaytto

signal pallojen_maara_muuttui(maara)

func _ready():
	# Päivitetään heti alussa, varmuuden vuoksi
	emit_signal("pallojen_maara_muuttui")

func lisaa_palloja(var maara: int):
	# Poimitaan vain jos mahtuu
	if pallot < pallot_max:
		pallot += maara
	# Rajoitetaan jos tuloksena olisi enemmän palloja
	if pallot > pallot_max:
		pallot = pallot_max
	emit_signal("pallojen_maara_muuttui", pallot)

func _physics_process(delta):
	# asetetaan pelaajan nopeus vaakasuunnassa
	# suluissa oleva koodi voidaan jakaa useammalle riville
	_nopeus_vektori.x = (
		Input.get_action_strength("ui_right")
		 - Input.get_action_strength("ui_left")
		) * nopeus
	
	if _nopeus_vektori.x > 0:
		suunta_oikealle = true
	elif _nopeus_vektori.x < 0:
		suunta_oikealle = false
	
	# liike pystysuunnassa:
	# Jos painetaan hyppy-näppäintä JA hahmo on maassa / lattialla:
	#	1. Asetetaan _tarttumis_vektori nollaksi (x ja y nollia)
	#	2. Annetaan hahmolle nopeus ylöspäin
	if Input.is_action_just_pressed("hyppy") and is_on_floor():
		_tarttumis_vektori = Vector2.ZERO
		_nopeus_vektori.y = -hypyn_voimakkuus
		
	# Jos päästetään nopeasti irti, hyppy 'keskeytetään'
	#	varmistetaan myös että liikutaan vielä ylöspäin,
	#	muuten voitaisiin keskeyttää myös putominen
	if Input.is_action_just_released("hyppy") and _nopeus_vektori.y < 0.0:
		_nopeus_vektori.y = 0.0
	# Nämä kaksi ylläolevaa riviä voi poistaa jos ei tykkää
	# hyppyjen keskeyttämisestä tällä tavalla
	
	# lisätään nopeutta alaspäin putoamiskiihtyvyyden mukaan
	_nopeus_vektori.y += putoamiskiihtyvyys * delta
	
	# tarttuminen päälle kun pelaaja alkaa pudota
	if _nopeus_vektori.y >= 0.0:
		_tarttumis_vektori = Vector2(0,32)
	
	# Lopuksi liikutetaan pelaajahahmoa pelaajan ohjauksen
	# ja vapaan tilan mukaan. Liikuttava funktio palauttaa
	# vektorin joka kuvaa tapahtuneen liikkeen nopeutta.
	_nopeus_vektori = move_and_slide_with_snap(
		_nopeus_vektori,
		_tarttumis_vektori,
		Vector2.UP
		)
	
	# Pallot käännetään sen mukaan miten pallonheitin on käännetty
	# ja pallot liikkuvat sen mukaan miten ne on käännetty. 180
	# asteen kierto suuntaa laukauskohdan ja pallojen suunnan vasemmalle.
	if suunta_oikealle:
		_pallonheitin.rotation_degrees = 0
	else:
		_pallonheitin.rotation_degrees = 180
		
	if Input.is_action_just_pressed("ampuminen"):
		if pallot > 0:
			emit_signal("laukaus")
			pallot -= 1
			emit_signal("pallojen_maara_muuttui", pallot)
	
	if Input.is_action_just_pressed("käyttö"):
		emit_signal("kaytto")
	
	# Asetetaan animaatio tässä:
	#	Jos pelaaja on maassa:
	#		asetetaan juoksuanimaatio jos pelaaja liikkuu
	#		tai 'odotus', eli paikalla seisominen, jos ei
	if is_on_floor():
		if _nopeus_vektori.x == 0:
			_animoitu_kuva.play("odotus")
		else:
			_animoitu_kuva.play("kävely")
	# Jos hypätään:
	else:
		_animoitu_kuva.play("hyppy")
	
	_animoitu_kuva.flip_h = !suunta_oikealle
