class_name Chart extends Resource
enum ChartFormat{
	PSYCH = 0,
	BASE = 1,
	RESOURCE = 2,
}
var song_name:StringName = "none"
var notes:Array[NoteData] = []
var events:Array[Event] = []
var bpms:Array[BpmChangeEvent] = []
var scroll_speed:float = 1.0

var bf:StringName = "bf"
var cpu:StringName = "dad"
var speaker:StringName = "gf"
static func load_chart(name:String,diff:String,format:ChartFormat = ChartFormat.PSYCH):
	
	var _chart:Chart = Chart.new()
	match format:
		ChartFormat.PSYCH,_:
			
			_chart.song_name = name
			var chart_path:String = "res://assets/songs/%s/chart/%s.json"%[_chart.song_name,diff]
			var exists:bool = ResourceLoader.exists(chart_path)
			assert(exists,"CHART DOES NOT EXIST IN ASSETS")
			var raw:Dictionary = load(chart_path).data.song
			_chart.cpu = raw.get("player2","dad")
			_chart.bf = raw.get("player1","bf")
			_chart.speaker = raw.get("gfVersion","gf")
			if raw.has("player3") and raw.get("player3") != null:
				_chart.speaker = raw.get("player3","gf")
			
			_chart.bpms.append(BpmChangeEvent.new(0.0,float(raw.get("bpm",100.0))))
			_chart.scroll_speed = raw.get("speed",1.0)
			
			if raw.has('events'):
				for event in raw.get('events', []):
					for raw_event in event[1]:
						# if event name is blank then
						# make shit differently
						var mod := int(raw_event[0].is_empty())
						var e_name: String = raw_event[0 + mod]
						
						var e: Event = null
						var path := 'res://game/events/%s.gd' % e_name
						if ResourceLoader.exists(path):
							e = load(path).instantiate(event[0] / 1000.0, raw_event[1 + mod], raw_event[2])
						else:
							e = PsychEvent.new(event[0] / 1000.0, raw_event[1 + mod], raw_event[2])
							e.name = e_name
						_chart.events.push_back(e)
			
			var sexi:int = 0
			## bpm change shit
			
			var _time:float = 0
			
			for sex in raw.notes:
				var cam_event:CameraFocusEvent = null
				var _bpm:float = _chart.bpms.back().bpm
				if sexi > 0:
					_time += (60.0/_bpm) * 4.0
				if sex.get("changeBPM",false):
					_chart.bpms.append(BpmChangeEvent.new(_time,sex.get("bpm",100.0),16.0*sexi))
				sexi += 1
				cam_event = CameraFocusEvent.new(_time,sex.mustHitSection)
				_chart.events.append(cam_event)
				
				for cum in sex.sectionNotes:
					var player_id:int = int(cum[1])/4
					if sex.mustHitSection:
						player_id += 1
					var note_data:NoteData = NoteData.new(cum[0]*0.001,int(cum[1])%4,(cum[2])*0.001,"normal",player_id)
					_chart.notes.append(note_data)
	return _chart

func _to_string():
	return "song:%s\nnotes: %s\nbpms:%s"%[song_name.to_lower(),notes.size(),bpms]
