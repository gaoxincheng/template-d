import std.stdio;
import std.regex;
import std.json;
import tpl.match;
import tpl.define;
import tpl.parser;
import tpl.renderer;
import tpl.util;

void main()
{
	
	if(0)
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
		writeln("pattern : ",matRs.pattern);
		writeln("empty : ",matRs.empty);
		writeln("size : ",matRs.size);
		writeln("position  : ",matRs.position);
		writeln("end position  : ",matRs.end_position);
		writeln("type : ",matRs.type);
		writeln("pre ",matRs.match.pre);
		writeln("post ",matRs.match.post);
		writeln("hit ",matRs.match.hit);
		writeln("whichPattern :",matRs.match.front.whichPattern);

		writeln("-------------next first----------------");
		auto  loop_match = RegexObj.search_closed(test, matRs.pattern(), regex_map_statement_openers[Statement.Loop], regex_map_statement_closers[Statement.Loop], matRs);
		writeln("inner :",loop_match.inner());
		writeln("outer :",loop_match.outer());
	}
	else
	{
		// writeln("-------------------------------TEST -----------------------");

		// foreach(k,v; regex_map_condition) {
		// 	writeln("key : ",k);
		// }

		Renderer render = new Renderer();
		Parser  parser = new Parser();

		JSONValue data;
		data["name"] = "Peter";
		data["city"] = "Brunswick";
		data["age"] = 29;
		//data["names"] = ["Jeff", "Seb"];
		//data["brother"]["name"] = "Chris";
		data["is_happy"] = false;
		data["allow"] = false;
		data["ok"] = true;
		data["gxc"] = "gao xin cheng";

		data["nums"] = ["ni"," hao"];

		// auto node = parser.parse("{# this is quto #}{% if is_happy %}
		// 								{{ name }}
		// 							{% else if ok %}
		// 								{{ gxc }}									
		// 							{% else %}
		// 								{{ city }}
		// 							{% endif %}");
		auto node = parser.parse("hello {% for num in nums %}{{num}}{% endfor %} gxc");
		Util.debug_ast(node.parsed_node);
	

		writeln("-------------------------------render result -----------------------");
		auto result = render.render(node,data);

		writeln(result);


		
	}
	
}
