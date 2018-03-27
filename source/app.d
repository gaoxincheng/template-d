import std.stdio;
import std.regex;
import tpl.match;
import tpl.define;

void main()
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

	auto mall = RegexObj.match!(Delimiter)("{{x}}",regex_map_delimiters);
	writeln("type : ",mall.type);
	foreach (c; mall.match)
	{
		writeln(c.hit);
		writeln(c[1]);
		writeln(c.empty);
		writeln(c.whichPattern);
	}

   writeln("-------------search first----------------");

	auto matRs = RegexObj.search_all("haha {% if({{var}}) %}");
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
	// foreach (c; matRs.match)
	// {
	// 	//writeln("type : ",matRs.type);
	// 	writeln("pre ",c.pre);
	// 	writeln("post ",c.post);
	// 	writeln("hit ",c.hit);
	// 	writeln("empty : ",c.empty);
	// 	writeln("whichPattern :",c.whichPattern);
	// }
	// for(int i=0; i< matRs.match.front.length;i++)
	// {
	// 	writeln("---sub :",matRs.match.front[i]);
	// }
	// auto c = match.search_first(input,regex_map_delimiters[Delimiter.Statement],0);

	// foreach (v; c)
    //          writeln(v);
	// writeln("pre: ",c.pre); // Part of input preceding match
    // writeln("post: ",c.post); // Immediately after match
    // writeln("hit: ",c.hit); // The whole match
    // writeln("front: ",c.front);
	// writeln("back: ",c.back);
    // c.popFront();
    // writeln("pop front: ",c.front);
	
	// c.popBack();
	// writeln(" is empty: ",c.empty);
    // writeln("pop back: ",c.back);


	// auto tmp = matchFirst("@abc#", regex(`(\w)(\w)(\w)`));
	// //foreach(v;tmp)
	// tmp.popBack;
	// 	writeln("--- : ",tmp.back);
}
