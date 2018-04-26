import std.stdio;
import std.json;

import tpl.environment;
import tpl.util;

void main()
{
	JSONValue data;
	data["name"] = "Cree";
	data["alias"] = "Cree";
	data["city"] = "Christchurch";
	data["age"] = 29;
	data["age1"] = 28;
	data["addrs"] = ["ShangHai", "BeiJing"];
	data["is_happy"] = false;
	data["allow"] = false;
	data["users"] = ["name" : "jeck", "age" : "18"];
	JSONValue user1;
	user1["name"] = "cree";
	user1["age"] = 18;
	JSONValue user2;
	user2["name"] = "jeck";
	user2["age"] = 28;
	JSONValue[] userinfo;
	userinfo ~= user1;
	userinfo ~= user2;
	data["userinfo"] = userinfo;

	string input;
	// writeln("------------------IF--------------------------");
	// input="{% if is_happy %}happy{% else %}unhappy{% endif %}";
	// writeln("result : ",Env().render(input, data));

	// writeln("------------------FOR-------------------------");
	// input = "{% for addr in addrs %}{{addr}} {% endfor %}";
	// writeln("result : ",Env().render(input, data));

	// writeln("------------------FOR2-------------------------");
	// input = "<ul>{% for addr in addrs %}<li><a href=\"{{ addr }}\">{{ addr }}</a></li>{% endfor %}</ul>";
	// writeln("result : ",Env().render(input, data));

	// writeln("------------------MAP-------------------------");
	// input = "{% for k,v in users %}{{ k }} -- {{ v }}  {% endfor %}";
	// writeln("result : ",Env().render(input, data));

	// writeln("------------------FUNC upper------------------");
	// input = "{{ upper(city) }}";
	// writeln("result : ",Env().render(input, data));

	// writeln("----------------FUNC lower--------------------");
	// input = "{{ lower(city) }}";
	// writeln("result : ",Env().render(input, data));

	// writeln("-------------FUNC compare operator------------");
	// input = "{% if age >= age1 %}true{% else %}false{% endif %}";
	// writeln("result : ",Env().render(input, data));

	// writeln("-------------FUNC compare operator (string)------------");
	// input = "{% if name != \"Peter\" %}true{% else %}false{% endif %}";
	// writeln("result : ",Env().render(input, data));

	// //Util.debug_ast(Env().parse(input).parsed_node);

	// writeln("---------Render file with `include`-----------");
	// writeln("result : ", Env("./test/").render_file("index.txt", data));

	// writeln("---------------Render file--------------------");
	// writeln("result : ", Env("./test/").render_file("main.txt", data));

	// writeln("---------Render file with `include` & save to file-----------");
	// Env("./test/").write("index.txt", data,"index.html");


	// writeln("------------------deep for-------------------------");
	// input = "{% for user in userinfo %}{{ user.name }} : {{user.age}}  {% endfor %}";
	// writeln("result : ",Env().render(input, data));

	writeln("-------------FUNC  operator------------");
	input = "{{ 'a' <= '1' }}";
	writeln("result : ",Env().render(input, data));

	Util.debug_ast(Env().parse(input).parsed_node);

	// JSONValue d;
	// d["appname"] = "Vitis";
	// d["title"] = "this is test .";
	// d["content"] = "Vitis is IM .";
	// d["platform"] = "Android";
	// d["pushscope"] = "IOS";
	// d["type"] = "online";
	// d["count"] = 100;
	// d["time"] = "Fri Apr 13 17:36:13 CST 2018";
	// d["savetotime"] = "Fri Apr 13 17:36:13 CST 2018";
	// d["msgid"] = 1000;
	// d["userinfo"] = userinfo;

	// writeln("---------Render file  & save to file-----------");
	// Env("./test/").write("detail.txt", d,"detail.html");
}
