# Tämä on monimutkaisempi skripti kuin
# useimmat muut tässä projektissa.
# Ei kannata aloittaa purkamaan miten se
# toimii jos ohjelmointi ei ole tuttua.
extends Path2D

export var toimii: bool = true
export var nopeus: float = 140
export var tauko: float = 1

# Jos tosi, liikkuva osa liikkuu
# takaisin alkuun päin
export var eteenpain: bool = true

# Jatkaa liikettä perille saapumisen
# jälkeen takaisin toiseen päähän
export var toistuu: bool = true

# Oletetaan että rata on suljettu kierros:
# kun saavutaan polun päähän, jatketaan
# saman tien toisesta päästä
export var ympari: bool = false

# PathFollow2D -solmu lisätään Path2D alisolmuksi.
# Sen jälkeen sitä voi liikutella Path2D sisältämää
# käyrää pitkin ja näin hakea käyrän eri kohtien
# koordinaatit.
onready var _paikantaja = $PathFollow2D
onready var _ajastin = $Timer

# Haetaan järjestyksessä viimeinen alisolmu
#	Ensimmäisen järjestysluku on 0,
#	viimeisen taas (määrä - 1)
onready var _liikkuja = get_child(get_child_count() - 1) as KinematicBody2D
# 'as KinematicBody2D' lopussa tarkoittaa että _liikkuja:n
# pitää olla tyyppiä KinematicBody2D, muuten ei aseteta viittausta

onready var _pituus = curve.get_baked_length()

# Matka käyrällä johon pyritään: joko ylläolevan
# '_pituus' arvo tai 0
var _tavoite: float

# Voidaan käynnistää tai sammuttaa tämän funktion avulla
func aseta_liike(paalle: bool):
	if paalle:
		_ajastin.paused = false
		if _ajastin.time_left <= 0:
			toimii = true
	else:
		toimii = false
		_ajastin.paused = true
	
func aseta_toistoliike(paalle: bool):
	if paalle:
		toistuu = true
		# Käynnistetään tätä kautta vain jos
		# ajastimella ei ole jäljellä odotusaikaa
		if _ajastin.time_left <= 0:
			toimii = true
		# Varmistetaan myös että ajastin ei ole "tauolla"
		_ajastin.paused = false
	else:
		toistuu = false

func liikuta_kerran(suunta_eteenpain: bool):
	# Asetetaan 'eteenpain' sen mukaan mitä 'suunta_eteenpain' on
	# 	Muuttujien 'suunta_eteenpain' ja 'eteenpain' arvojen
	# 	pitää olla samat
	# ehtolause:
	#	<vaihtoehto jos tosi> if <ehto> else <vaihtoehto jos epätosi>
	eteenpain = suunta_eteenpain
	_tavoite = _pituus if eteenpain else 0
	toimii = true

func _ready():
	_tavoite = _pituus if eteenpain else 0
	# PathFollow2D:n ominaisuus 'loop' määrää voiko
	# polkua kiertää ympäri, eli jos yritetään mennä
	# loppupäätä pidemmälle jatketaanko alkupäästä.
	#	Asetetaan se alussa skriptin oman muuttujan mukaan.
	_paikantaja.loop = ympari

# Liikutetaan PathFollow2D -solmua käyrän
# jompaankumpaan päähän, riippuen suunnasta,
# ja asetetaan se sijainti alisolmuksi lisätylle
# kappaleelle. 
#	Jos 'loop' ominaisuus on asetettu,
#	loppupäästä palataan taas alkuun.
func _physics_process(delta):
	if toimii and _liikkuja:
		if _paikantaja.loop:
			_paikantaja.offset += delta * (nopeus if eteenpain else -nopeus)
		else:
			# Jos ei olla päästy toiseen päähän, jatketaan liikettä
			if _paikantaja.offset != _tavoite:
				_paikantaja.offset = move_toward(
					_paikantaja.offset, 
					_tavoite, 
					delta * nopeus
					)
				_liikkuja.position = _paikantaja.position
			# Jos ollaan päästy haluttuun päähän, ja liikkeen pitää toistua
			#	Jos taukoaika on asetettu, tarkistetaan toistuvuus vasta 
			#	ajastimen signaalin jälkeen
			elif tauko > 0:
				_ajastin.start(tauko)
				toimii = false
				
				eteenpain = !eteenpain
				
				if _tavoite == _pituus:
					_tavoite = 0
				else:
					_tavoite = _pituus
			
			elif toistuu:
#				# Jos taukoaika on asetettu, eli suurempi kuin 0,
#				# käynnistetään ajastin
#				if tauko > 0:
#					_ajastin.start(tauko)
#					toimii = false
					
				eteenpain = !eteenpain
				
				if _tavoite == _pituus:
					_tavoite = 0
				else:
					_tavoite = _pituus
		
		
		#	Jostain syystä jos liikkuvan alustan (tai muun vastaavan)
		#	laittaa PathFollow2D:n alisolmuksi, sen reitti menee sekaisin
		#	kosketuksesta pelaajaan. Siirretään sitä sen sijaan kopioimalla
		#	koordinaatteja 
		
		# HUOMAA:
		# Jos etäisyys määränpäähän on pienempi kuin liike päivityksen aikana,
		# ajan myötä menetetään hieman matkaa, ellei tätä oteta huomioon. Jos
		# kiinnostaa, voit yrittää tehdä pienen korjauksen tätä varten.


func _on_Timer_timeout():
	if toistuu:
		toimii = true
