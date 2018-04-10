import std.stdio;
import std.json;

import tpl.environment;
import tpl.util;


void main()
{
	JSONValue data;
	data["name"] = "Peter";
	data["alias"] = "Peter";
	data["city"] = "Brunswick";
	data["age"] = 29;
	data["age1"] = 28;
	data["addrs"] = ["ShangHai", "BeiJing"];
	data["is_happy"] = false;
	data["allow"] = false;
	data["users"] = ["name" : "jeck", "age" : "18"];

	string input;
	writeln("------------------IF--------------------------");
	input="{% if is_happy %}happy{% else %}unhappy{% endif %}";
	writeln("result : ",Env().render(input, data));

	writeln("------------------FOR-------------------------");
	input = "{% for addr in addrs %}{{addr}} {% endfor %}";
	writeln("result : ",Env().render(input, data));

	writeln("------------------FOR2-------------------------");
	input = "<ul>{% for addr in addrs %}<li><a href=\"{{ addr }}\">{{ addr }}</a></li>{% endfor %}</ul>";
	writeln("result : ",Env().render(input, data));

	writeln("------------------MAP-------------------------");
	input = "{% for k,v in users %}{{ k }} -- {{ v }}  {% endfor %}";
	writeln("result : ",Env().render(input, data));

	writeln("------------------FUNC upper------------------");
	input = "{{ upper(city) }}";
	writeln("result : ",Env().render(input, data));

	writeln("----------------FUNC lower--------------------");
	input = "{{ lower(city) }}";
	writeln("result : ",Env().render(input, data));

	writeln("-------------FUNC compare operator------------");
	input = "{% if age >= age1 %}true{% else %}false{% endif %}";
	writeln("result : ",Env().render(input, data));

	writeln("-------------FUNC compare operator (string)------------");
	input = "{% if name != \"Peter\" %}true{% else %}false{% endif %}";
	writeln("result : ",Env().render(input, data));

	//Util.debug_ast(Env().parse(input).parsed_node);
	writeln("---------------Render file--------------------");
	writeln("result : ",Env("./test/").render_file("main.txt", data));

	writeln("---------Render file with `include`-----------");
	writeln("result : ",Env("./test/").render_file("index.txt", data));

	writeln("---------Render file with `include` & save to file-----------");
	Env("./test/").write("index.txt", data,"index.html");
}
