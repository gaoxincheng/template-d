import std.stdio;
import std.regex;
import std.json;
import tpl.match;
import tpl.rule;
import tpl.parser;
import tpl.renderer;
import tpl.util;
import tpl.environment;

void main()
{

	if (0)
	{
		writeln("-----begin----------");
		string input = "
				<div>ha</div>
				{# this is Comment#}
				you 
				<div>
				{% if a in [a,b] %}
					hello
				{% endif %}
				</div>
				{% for x in xarray %}
				{{x}}
				{% endfor %}";

		writeln("-------------search first----------------");

		string test = "gxc {% for x in xarray %} make {{x}} flag {% endfor %} hello";
		auto matRs = RegexObj.search_all(test);
		writeln("pattern : ", matRs.pattern);
		writeln("empty : ", matRs.empty);
		writeln("size : ", matRs.size);
		writeln("position  : ", matRs.position);
		writeln("end position  : ", matRs.end_position);
		writeln("type : ", matRs.type);
		writeln("pre ", matRs.match.pre);
		writeln("post ", matRs.match.post);
		writeln("hit ", matRs.match.hit);
		writeln("whichPattern :", matRs.match.front.whichPattern);

		writeln("-------------next first----------------");
		auto loop_match = RegexObj.search_closed(test, matRs.pattern(),
				regex_map_statement_openers[Statement.Loop],
				regex_map_statement_closers[Statement.Loop], matRs);
		writeln("inner :", loop_match.inner());
		writeln("outer :", loop_match.outer());
	}
	else
	{

		JSONValue data;
		data["name"] = "Peter";
		data["alias"] = "Peter";
		data["city"] = "Brunswick";
		data["age"] = 29;
		data["age1"] = 28;
		data["names"] = ["Jeff", "Seb"];
		data["is_happy"] = false;
		data["allow"] = false;
		data["ok"] = false;
		data["gxc"] = "gao xin cheng";

		data["nums"] = ["ni", " hao"];
		data["users"] = ["name" : "jeck", "age" : "18"];

		//string input = "hello {% for num in nums %}{{ index }} -- {{ num }} {% endfor %} gxc"; //test for in array
		//string input = "hello {% for k,  v in users %} {% if ok %}{{ k }} -- {{ v }} {% else %} {{ v }} -- {{ k }} {% endif %} {% endfor %} gxc";  //test for k,v in map
		//string input = "hi {{ upper(age) }}";
		//string input = "{% if is_happy == ok %}true{% else %}false{% endif %}";
		string input = "{% if is_happy %}
							{{ name }}
						{% else if ok %}
							{{ gxc }}									
						{% else %}
							{% if allow %}
								{{ city }}
							{% else age %}
								done
							{% endif %}
						{% endif %}";

		//Util.debug_ast(node.parsed_node);
		writeln("-------------------------------TEST ----------------------------");
		writeln("input : ", input);
		writeln("---------------------------Render result -----------------------");
		auto ast = Env().parse(input);
		//Util.debug_ast(ast.parsed_node);
		auto result = Env("./test/").render_file("index.txt", data);

		writeln(result);
	}

}

// if
unittest
{
	JSONValue data;
	data["name"] = "Peter";
	data["alias"] = "Peter";
	data["city"] = "Brunswick";
	data["age"] = 29;
	data["age1"] = 28;
	data["names"] = ["Jeff", "Seb"];
	data["is_happy"] = false;
	data["allow"] = false;
	data["ok"] = false;
	data["gxc"] = "gao xin cheng";

	data["nums"] = ["ni", " hao"];
	data["users"] = ["name" : "jeck", "age" : "18"];
	string input = "{% if is_happy %}
						{{ name }}
					{% else if ok %}
						{{ gxc }}									
					{% else %}
						{% if allow %}
							{{ city }}
						{% else age %}
							done
						{% endif %}
					{% endif %}";
	auto result = Env("").render(input, data);
	writeln(result);
}
