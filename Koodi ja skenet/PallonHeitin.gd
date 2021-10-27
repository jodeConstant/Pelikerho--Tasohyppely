extends Node2D

# Voidaan antaa viittaus tallennettuun skeneen, josta
# sitten voidaan luoda uusia olioita / ilmentymiä
export (PackedScene) var ammus

# Uusi ammus asetetaan tämän etäisyyden verran x-akselin suuntaan
#	Jos heitintä ei ole käännetty, tämän verran oikealle
export var alku_etaisyys: float = 27

onready var _laukaus_kohta = $LaukausKohta

func _laukaus():
	if ammus:
		# Luodaan uusi olio, tässä tapauksessa ammus
		#	'as Area2D' tarkoittaa että oletetaan että 'uusi_ammus'
		#	on tyyppiä 'Area2D' tai johdettu siitä
		var uusi_ammus = ammus.instance() as Area2D
		# Käytetään 'global_position' ja 'global_rotation' ominaisuuksia
		# paikkaa ja kiertoa varten, koska ne eivät ole suhteessa muihin
		# solmuihin, joihin tämä kuuluu.
		uusi_ammus.global_position = _laukaus_kohta.global_position
		# Käännetään pallot pallonheittimen kierron mukaan: tällöin
		# ne lentävät samaan suuntaan kuin LaukausKohta osoittaa
		uusi_ammus.global_rotation = _laukaus_kohta.global_rotation
		# Lisätään luotu olio käynnissä olevaan skeneen
		#	Tämä tarkoittaa nimenomaan pääskeneä, johon muut
		#	osat näkyvät osat sisältyvät, yleensä pelitasoa.
		get_tree().current_scene.add_child(uusi_ammus)
