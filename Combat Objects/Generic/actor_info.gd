extends Resource
class_name ActorInfo


@export_category("Attributes")
@export var base_might : int ##Effects damage with weapon attacks
@export var base_potency : int ##Makes spells more powerful
@export var base_constitution : int ##Increases max healt, max ap, and makes it harder to be moved against your will
@export var base_resilience : int ##Weakens or prevents negetive status effects, increases healing after battle
@export var base_intelligence : int ##increases inititive and xp gain
@export var base_speed : int ##odd levels increase mp, even  levels increase inititive
@export var base_luck : int ##increases hit chance and dogdge chance with weapon attacks, effects chance based skills

@export_category("visuals")
@export var portrait : Texture2D = preload("uid://dju3f0mhksng4")
@export var icon : Texture2D
@export var character_name : String = ""
@export var combat_class : String = ""
