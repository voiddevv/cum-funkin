class_name Tools extends RefCounted

static func http_request(url:String):
	var err:int
	var client := HTTPClient.new()
	var url_split = url.split("/",true,1)
	assert(not url_split.is_empty(),"bad url request")
	print(url_split[0])
	err = client.connect_to_host("https://assets-global.website-files.com")
	assert(err == OK)
	await client.has_response()
	assert(url_split.size() > 0)
	while client.get_status() != 5:
		client.poll()
	print_debug(client.get_status())
	client.request(HTTPClient.METHOD_GET,"/64d9012acfc1e7e6c6522bb9/65b0583eeb4cdab3d2e5588b_Movie_SonicFranch.webp",[])
	await client.has_response()
	print(client.get_response_body_length())
