extends Control

onready var _tauko = $Tauko
onready var _tappio = $Tappio
onready var _seuraava = $Seuraava

onready var _aika = $Aika
onready var _kolikot = $"KolikoidenMäärä"
onready var _pallot = $"PallojenMäärä"

func _ready():
	# pause_mode asetetaan niin että valikko
	# toimii myös tauon aikana
	pause_mode = PAUSE_MODE_PROCESS
	Peli.connect("taso_ohi", self, "_nayta_tasonvaihto")
	Peli.connect("peli_ohi", self, "_nayta_tappio")
	
	Peli.connect("kolikkojen_maara_muuttui", self, "_kolikon_paivitys")

func _process(delta):
	_aika.text = Peli.aika_teksti
	if Input.is_action_just_pressed("valikko"):
		get_tree().paused = true
		_tauko.show()

# Kolikoiden ja pallojen määrän näyttämistä varten:

func _kolikon_paivitys(kolikot):
	_kolikot.text = str(kolikot)

func _pallojen_paivitys(pallot):
	_pallot.text = str(pallot)

# Ilmoitusten näytämistä varten:

func _nayta_tasonvaihto():
	_seuraava.show()
	get_tree().paused = true

func _nayta_tappio():
	_tappio.show()
	get_tree().paused = true

################################

# Nappeja varten

func _on_JatkaPelia_pressed():
	_tauko.hide()
	get_tree().paused = false

func _on_SeuraavaTaso_pressed():
	_seuraava.hide()
	Peli.jatka_seuraavalta_tasolta()
	get_tree().paused = false

func _on_Uudestaan_pressed():
	Peli.aloita_taso_alusta()
	get_tree().paused = false
