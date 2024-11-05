extends CharacterBody2D

class_name enemyInterface


@export var drop: item
@onready var collectable = preload("res://Objects/collectable.tscn")
@onready var main = self.get_parent()


var health = 20
var speed = 20
var damage_num = 2
var dead = false
var player = null
var player_chase = null
var rng = RandomNumberGenerator.new()

var conditionList: Array = []
