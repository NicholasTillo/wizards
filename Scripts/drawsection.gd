extends ColorRect



var flag:bool = false 
var total: float = 0.05

var curLine = null
var prev_point:Vector2

var line_array:Array = []

var current_stroke:Array = []
var stroke_array: Array = []

var current_stroke_number:int = 0

#$Q Algorithm Stuff, 

var n = 32
var LUT_SIZE = 64
var save_path = "res://gesture_templates/"



@onready var line = preload("res://Objects/Line.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flag:
		total -= delta
		if Input.is_action_pressed("left_click") and total < 0:
			#print(prev_point)
			if(prev_point == Vector2(0,0)):
				var mouse_point = get_local_mouse_position()
				curLine.add_point(mouse_point)
				current_stroke.append(Vector3(mouse_point.x,mouse_point.y,current_stroke_number))
				prev_point = mouse_point
				total = 0.05
				return
			else:
				#print(curLine.points)
				var mouse_point = get_local_mouse_position()
				var distance:float = prev_point.distance_to(mouse_point)

				while(distance > 5):
					var child_point = prev_point + (((mouse_point - prev_point).normalized()) * 5)
					curLine.add_point(child_point)
					current_stroke.append(Vector3(child_point.x,child_point.y,current_stroke_number))
					
					prev_point = child_point
					distance = child_point.distance_to(mouse_point)
					total = 0.1
			

func mark_end_stroke():
	#print("Storke")
	stroke_array.append_array(current_stroke)
	current_stroke_number += 1
	line_array.append(curLine)
	prev_point = Vector2(0,0)
	
	
func start_drawing():
	flag = true 
	curLine = line.instantiate()
	add_child.call_deferred(curLine)



func finish_drawing():
	#print(stroke_array)
	if(stroke_array.size() > 0):
		pointlist_to_gesture(stroke_array)
	for line in line_array:
		line.queue_free()
	line_array = [] 
	stroke_array.clear()
	flag = false 
	prev_point = Vector2(0,0)
	




#Q Recgonizer Helpers


signal classfied_gesutre(gesture_name : StringName)

#Q Recgonizer,  https://depts.washington.edu/acelab/proj/dollar/qdollar.pdf 




#Points must be of a gesture class 
func q_recognizer_main_function(points : Gesture, list_of_all_templates : Array):
	#init number of verticies, 

	var score : float = 100000000 
	var result = null
	for template in list_of_all_templates:
		var d = cloud_match(points, template, n, score)
		if d < score:
			score = d
			result = template
			
	print(result.gesture_name)
	print(score)
	return [result,score]
	
	
func cloud_match(points : Gesture, template : Gesture, n, min) -> float:
	var step:int = floor(pow(n,0.5))
	var lowerBound1 : Array[float] = computer_lower_bound(points, template, step, template.LUT, n)
	var lowerBound2 : Array[float] = computer_lower_bound(template, points, step, points.LUT, n)
	for i in range(0 , n, step):
		if lowerBound1[floor(i/step)] < min:
			min = min(min,cloud_distance(points, template, n, i, min))
		if lowerBound2[floor(i/step)] < min:
			min = min(min,cloud_distance(template, points, n, i, min))	
		
	return min
	
func computer_lower_bound(points : Gesture, template : Gesture, step, LUT, n):
	var lowerBound : Array[float] = []
	lowerBound.resize(n)
	var sumAreaTable : Array[float] = []
	sumAreaTable.resize(n)
	
	#Compute LB for starting point index 0,
	
	lowerBound[0] = 0
	var index = 0
	for i in range(0,n):
		index = LUT[points.points[i].x][points.points[i].y]
		var distance = square_euclidean_distance(points.points[i], template.points[index])
		if(i == 0):
			sumAreaTable[i] = distance 
		else:
			sumAreaTable[i] = sumAreaTable[i-1] + distance
			
		lowerBound[0] = lowerBound[0] + ((n-i) * distance)
	
	for i in range(step, n, step):
		lowerBound[floor(i/step)] = lowerBound[0] + i * sumAreaTable[n-1] - n * sumAreaTable[i-1]
	return lowerBound
	
	
func cloud_distance(points : Gesture, template : Gesture, n : int, start, minSoFar):
	var unmatched = range(0,n) # indicies of unmatches points
	var i = start #Start matching from this index
	var weight = n
	var sum = 0 #Computes cloud distance between points and template, 
	
	var minDistnace = 100000000000
	var index = 0;
	while true:
		for  j in unmatched:
			var d = square_euclidean_distance(points.points[i], template.points[j])
			if d < minDistnace:
				minDistnace = d
				index = j
		unmatched.remove_at(index)
		sum += weight*minDistnace
		if sum >= minSoFar:
			return sum
		weight = weight - 1
		i = (i+1) % n 
		
		# If condition satisfied, break 
		if i == start:
			break
	return sum
	
	
	

	
	
#Preprocessing Functions

func pointlist_to_gesture(points):
	var gesture_name = ""
	
	#This flag is for when making new gestures
	#Turn it to true, 
	#When its set to false, it will evaluate and print the score and closest template.. 
	var flag = false
	
	
	var results = normalize(points)
	var points_normalized = results[0]
	var LUT = results[1]
	
	
	if flag:
		gesture_name = "Square3"
		save_gesture_to_resource(points_normalized, LUT, gesture_name)
		
	else:
		
		var gesture = Gesture.new()
		gesture.points = points_normalized
		gesture.LUT = LUT
		gesture.gesture_name = "player_input"
		var gestureList = load_gesture_list()
		q_recognizer_main_function(gesture,gestureList)
		

func load_gesture_list():
	var templateList = []
	for file_name in DirAccess.get_files_at(save_path):
		templateList.append(ResourceLoader.load(save_path + file_name))
		
	return templateList

func normalize(points):
	#resample, scale, translate, 
	#transform coords into int, 
	points = reduce_to_cloud_size(points)
	points = resample(points)
	points = scale(points)
	points = translate(points, centroid(points))
	var LUT = compute_look_up_table(points, n, LUT_SIZE)
	return [points, LUT]




func reduce_to_cloud_size(points):
	var numToSubtract = points.size() % n
	var step_size = points.size() / n
	var newPoints : Array[Vector3] = []
	for i in range(0,points.size() - numToSubtract ,step_size):
		newPoints.append(points[i])
	return newPoints
	
func resample(p_points):
	var new_points : Array[Vector3]
	new_points.resize(n)
	new_points[0] = p_points[0]
	var num_points : int = 1
	
	var interval_length : float = path_length(p_points) / (n-1)
	var d : float = 0
	for i in range(1, p_points.size()):
		if p_points[i].z == p_points[i-1].z:
			var small_d : float = euclidean_distance(p_points[i-1], p_points[i])
			if (d + small_d >= interval_length):
				var first_point : Vector3 = p_points[i-1]
				while (d + small_d >= interval_length):
					var t : float = min(max((interval_length - d) / small_d, 0.0), 1.0)
					if is_nan(t):
						t = 0.5
					var new_vec3 = Vector3((1.0 - t) * first_point.x + t * p_points[i].x, (1.0 - t) * first_point.y + t * p_points[i].y, p_points[i].z)
					new_points[num_points] = new_vec3
					num_points += 1
					
					small_d = d + small_d - interval_length
					d = 0
					first_point = new_points[num_points - 1]
				d = small_d
			else:
				d += small_d
	if num_points == n - 1:
		new_points[num_points] = Vector3(p_points.back().x, p_points.back().y, p_points.back().z)
	return new_points


func scale(p_points):
	var minx : float = INF
	var miny : float = INF
	var maxy : float = -INF
	var maxx : float = -INF
	for point : Vector3 in p_points:
		if minx > point.x:
			minx = point.x
		if miny > point.y:
			miny = point.y
		if maxx < point.x:
			maxx = point.x
		if maxy < point.y:
			maxy = point.y
	
	var new_points : Array[Vector3]
	new_points.resize(p_points.size())
	var new_scale : float = max(maxx - minx, maxy - miny)
	#prints("new scale", new_scale)
	for i in range (p_points.size()):
		var new_vec3 : Vector3 = Vector3((p_points[i].x - minx) / new_scale, (p_points[i].y - miny) / new_scale, p_points[i].z)
		new_points[i] = new_vec3
	return new_points

func translate(p_points, p_centroid):
	var new_points : Array[Vector3]
	new_points.resize(p_points.size())
	for i in range(p_points.size()):
		var new_vec3 = Vector3(p_points[i].x - p_centroid.x, p_points[i].y - p_centroid.y, p_points[i].z)
		new_points[i] = new_vec3
	return new_points
	
	
	
	
	
func euclidean_distance(p1, p2):
	return sqrt(square_euclidean_distance(p1,p2))
	
func square_euclidean_distance(p1, p2):
	return (p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2
	
func path_length(p_points):
	var distance = 0
	for i in range(1,n):
		if p_points[i][2] == p_points[i-1][2]:
			distance = distance + euclidean_distance(p_points[i-1],p_points[i])
	return distance
	

func compute_look_up_table(points, n, m):
	#Initialize Table with 0s 
	var lookUpTable : Array = Array()
	lookUpTable.resize(m)
	for i in range(m):
		lookUpTable[i] = Array()
		lookUpTable[i].resize(m)
		for j in range(m):
			lookUpTable[i][j] = 0
	
			
	#
	for x in range(m):
		for y in range(m):
			var min = 100000000000000
			var index = 0
			for i in range(n):
				var distance = square_euclidean_distance(points[i], Vector2(x,y))
				if distance < min:
					min = distance
					index = i
			lookUpTable[x][y] = index
	return lookUpTable
	

	
func centroid(p_points):
	var cx : float = 0
	var cy : float = 0
	for point : Vector3 in p_points:
		cx += point.x
		cy += point.y
	return Vector3(cx / p_points.size(), cy / p_points.size(), 0)
	
	
	
	
	
#Code For Making Gestures As Resources

func save_gesture_to_resource(points, LUT, gesture_name):
	var gesture_resource = Gesture.new()
	gesture_resource.points = points
	gesture_resource.LUT = LUT
	if gesture_name != "":
		gesture_resource.gesture_name = gesture_name
		save_gesture_to_disk(gesture_resource)
	

func save_gesture_to_disk(gesture_resource):
	ResourceSaver.save(gesture_resource, save_path + gesture_resource.gesture_name + ".tres")
	#var dir = DirAccess.open("res://gesture_templates")
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#var new_file_name = save_path + gesture_name + ".res"
			#var counter = 1
			#var b : bool = true
			#while b:
				#if new_file_name == file_name and file_name != "":
					#new_file_name = save_path + gesture_name + "_" + str(counter) + ".res"
					#file_name = dir.get_next()
				#else:
					#ResourceSaver.save(gesture_resource, new_file_name)
					#b = false
	ResourceLoader.load(save_path + gesture_resource.gesture_name + ".tres")
	
