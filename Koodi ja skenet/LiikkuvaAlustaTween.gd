extends KinematicBody2D

# Siirrä alusta haluttuihin kohtiin editorissa ja
# kopioi koordinaatit näihin kohtiin tarkastelussa
export var alkupiste: Vector2
export var loppupiste: Vector2

export var nopeus: float = 100
export var aloita_heti: bool = false
export var toista: bool = false
export var tauko: float = 1													#
var eteenpain: bool = true

# 'onready' avainsana tarkoittaa että muuttujan arvo
# asetetaan vasta kun kutsutaan funktio '_ready()', katso alemapana
#	tämä tapahtuu ENNEN funktiossa olevia komentoja

# Tämä muuttuja on viittaus solmuun nimeltä 'Tween'
onready var _tween = $Tween
# Voidaan kirjoittaa myös:
# onready var _tween = get_node("Tween")

onready var _ajastin = $Timer												#
	
# Tämä funktio käynnistää tai sammuttaa liikkuvan kappaleen:
#	Jos 'paalle' on true, se käynnistetään
#	Jos 'paalle' on false, se sammutetaan
func aseta_liike(var paalle: bool):
	if paalle:
		_ajastin.paused = false
		if _ajastin.time_left <= 0:
			_tween.set_active(true)
	else:
		_tween.set_active(false)
		_ajastin.paused = true
	
func aseta_toistoliike(var paalle: bool):									#
	if paalle:																#
		toista = true														#
		_aseta_siirto(position, loppupiste if eteenpain else alkupiste)		#
		# Käynnistetään tätä kautta vain jos								#
		# ajastimella ei ole jäljellä odotusaikaa							#
		if _ajastin.time_left <= 0:											#
			_tween.set_active(true)											#
		# Varmistetaan myös että ajastin ei ole "tauolla"					#
		_ajastin.paused = false												#
	else:																	#
		toista = false														#

func liikuta_kerran(var suunta_eteenpain: bool):							#
	# Asetetaan 'eteenpain' sen mukaan mitä 'suunta_eteenpain' on			#
	# 	Muuttujien 'suunta_eteenpain' ja 'eteenpain' arvojen				#
	# 	pitää olla samat													#
	eteenpain = suunta_eteenpain											#
	_aloita_uusi_liike()													#

func _aloita_uusi_liike():													#
	_tween.stop(self)														#
	_aseta_siirto(position, loppupiste if eteenpain else alkupiste)			#
	_tween.set_active(true)													#

# Tämä funktio valmistaa seuraavan siirron, kun sille annetaan
# siirtymaän alku- ja loppupiste.
func _aseta_siirto(var alku: Vector2, var loppu: Vector2):
	# Aika saadaan jakamalla matka nopeudella
	var siirto_aika = alku.distance_to(loppu) / nopeus
	# Tällä funktiolla kerrotaan mitä ominaisuutta muutetaan ja miten.
	# Sulkeiden sisältö voidaan jakaa eri riveille:
	_tween.interpolate_property(	# Merkitykset:
		self,  					# valittu solmu
		"position",				# solmun ominaisuus nimellä
		alku,					# ominaisuuden arvo alussa
		loppu,  				# ominaisuuden arvo lopussa
		siirto_aika				# käytetty aika
		)
	
# _ready() funktio suoritetaan kun solmu / skene lisätään peliin
#	jos solmu / skene on pelissä heti alussa, suoritetaan silloin
func _ready():
	_aseta_siirto(alkupiste, loppupiste)
	
	if aloita_heti:
		_tween.set_active(true)

# Tämä suoritetaan kun edellinen liike on päättynyt
func _on_Tween_tween_completed(object, key):
	_tween.set_active(false)											#
	# Vaihdetaan arvo käänteiseksi:
	eteenpain = !eteenpain
	
	if tauko > 0:														#
		_ajastin.start(tauko)											#
	elif toista:														#
		_aloita_uusi_liike()											#

func _on_Timer_timeout():												#
	# Toisto voidaan ehkä sammuttaa ennen kuin aika kuluu loppuun		#
	if toista:															#
		_aloita_uusi_liike()											#
