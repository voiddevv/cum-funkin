## unfinished sorry
class_name SM extends Resource
var title:StringName
var subtitle:StringName
var titletranslit:StringName
var artist:StringName
var version:String
var genre:StringName
var credit:String
var music:String
var banner:String
var background:String
var cdtitle:String
var origin:String
var previewvid:String
var jacket:String
var cdimage:String
var diskimage:String
var lyricspath:String
var bgchanges:String
var fgchanges:String
var selectable:bool
var samplestart:float
var samplelength:float
static func parse(str:String):
	var sm = SM.new()
	str = str.strip_edges()
	var lines:PackedStringArray = str.split('\n')
	for line in lines:
		var line_split:PackedStringArray = line.split(":",true,1)
		if line_split.size() == 1:
			line_split.append("")
		line_split[1] = line_split[1].trim_suffix(";")
		match line_split[0]:
			"#SELECTABLE":
				sm.selectable = (line_split[1] == "YES")
			"#SAMPLESTART","#SAMPLELENGTH":
				sm.set(line_split[0].substr(1).to_lower(),float(line_split[1]))
			_:
				sm.set(line_split[0].substr(1).to_lower(),line_split[1].trim_suffix(";"))
	pass
