class_name SfxManager extends AudioStreamPlayer2D

enum SFXBanks{
    BANK_0,
    BANK_1,
    BANK_2,
    BANK_3,
    BANK_4,
    BANK_5,
    BANK_6,
    BANK_7,
}
@export_category("SFX Banks")
@export var bank_names: Array[StringName] = [
    "empty",
    "empty",
    "empty",
    "empty",
    "empty",
    "empty",
    "empty",
    "empty"]

@export var bank_0: Array[AudioStream]
@export var bank_1: Array[AudioStream]
@export var bank_2: Array[AudioStream]
@export var bank_3: Array[AudioStream]
@export var bank_4: Array[AudioStream]
@export var bank_5: Array[AudioStream]
@export var bank_6: Array[AudioStream]
@export var bank_7: Array[AudioStream]

var sfx_banks: Dictionary = {
    bank_names[0]: bank_0,
    bank_names[1]: bank_1,
    bank_names[2]: bank_2,
    bank_names[3]: bank_3,
    bank_names[4]: bank_4,
    bank_names[5]: bank_5,
    bank_names[6]: bank_6,
    bank_names[7]: bank_7,
}


func is_bank_empty(bank_name: StringName) -> bool:
    var bank = sfx_banks.get(bank_name)
    if bank:
        return bank.is_empty()
    else:
        push_warning("bank [" + str(bank_name) + "] does not exist.")
        return false

func add_stream(bank_name: StringName, audio_stream: AudioStream):
    sfx_banks.get(bank_name).append(audio_stream)

func remove_stream(bank_name: StringName, audio_stream: AudioStream):
    sfx_banks.get(bank_name).erase(audio_stream)

func get_rand_sound(bank_name:StringName) -> AudioStream:
    var bank = sfx_banks.get(bank_name)
    var bank_last_idx = len(bank)
    var rng = RandomNumberGenerator.new()
    var rn = rng.randf_range(0, bank_last_idx)
    return bank[rn]

func play_rand(bank_name: StringName):
    print("playing rand sfx")
    if !is_bank_empty(bank_name):
        var rand_stream = get_rand_sound(bank_name)
        stream = rand_stream
        play()

func _ready():
    sfx_banks = {
        bank_names[0]: bank_0,
        bank_names[1]: bank_1,
        bank_names[2]: bank_2,
        bank_names[3]: bank_3,
        bank_names[4]: bank_4,
        bank_names[5]: bank_5,
        bank_names[6]: bank_6,
        bank_names[7]: bank_7,
    }