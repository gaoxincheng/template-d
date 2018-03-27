module tpl.match;

import std.regex;
import std.string;
import std.traits;
import std.stdio;

import tpl.define;

class Match{
	string _pattern;
public:
	this(){}
	this(string pattern){ _pattern = pattern;}
	void set_pattern(string pat) { _pattern = pat; }
	string pattern() { return _pattern; }
}


class MatchType(T,R = string) : Match {
	T type_;
	RegexMatch!(R) _allm;
	Captures!(R)   _firstm;
	size_t offset_ = 0;
public:
	this() { super();}
	this(size_t cur,string pattern = string.init) { 
		super(pattern);
		offset_ = cur;
	}

	void setMatchResult(ref RegexMatch!(R) rm){ _allm = rm;}

	@property RegexMatch!(R) match(){ return _allm;}

	void setMatchFirst(ref Captures!(R) fm){ _firstm = fm;}

	@property Captures!(R) firstMatch(){ return _firstm;}

	void set_type(T type) { type_ = type; }

	@property T type() const { return type_; }

	@property bool empty() { return _allm.empty && _firstm.empty; }

	@property bool found() { return !empty; }

	@property size_t size() { return _allm.front.length; }

	@property string str(int i)  { 
		if(i > _allm.front.length)
			return string.init;
		return _allm.front[i]; 
	}

	@property string prefix()
	{
		return _allm.front.pre;
	}
	@property string suffix()
	{
		return _allm.front.post;
	}

	size_t position()  { return prefix.length; }
	size_t end_position()  { return position() + str(0).length; }

}


class RegexObj{

	string _pattern;

public:
	 this(string pattern) { 
        _pattern = pattern;
    }
	
	@property string pattern() { return _pattern; }


	static auto search(string input ,string pattern,size_t pos=0)
	{
		MatchType!(string) m = new MatchType!(string)(pos,pattern);
		auto  res = matchAll(input,regex(pattern));
		m.setMatchResult(res);
		return m;
	}

	static auto search_first(string input,string pattern,size_t pos=0)
	{
		MatchType!(string) m = new MatchType!(string)(pos,pattern);
		auto res = matchFirst(input,regex(pattern));
		m.setMatchFirst(res);
		return m;
	}

	
	static auto search_all(string input,size_t pos=0)
	{
		MatchType!(Delimiter) m = new MatchType!(Delimiter)(pos);
		string[] patterns;
		Delimiter[int] sort_key;
		int i = 1;
		foreach(Delimiter k,string v; regex_map_delimiters) {
			patterns ~= v;
			sort_key[i] = k;
			i++;
		}
		auto  res = matchAll(input,regex(patterns));
		m.setMatchResult(res);
		if(!res.empty)
		{
			auto idx = res.front.whichPattern;
			//writeln("--patterns :",patterns);
			writeln("--cur pattern :",idx);
			if(idx in sort_key)
				m.set_type(sort_key[idx]);
		}
		
		return m;
	}

	static auto match(T)(string input ,string[T] map,size_t pos=0)
	{
		foreach(T e,string v; map) {
			auto res = matchAll(input,regex(v));
			if(!res.empty)
			{
				MatchType!(T) mt = new MatchType!(T)(pos);
				mt.setMatchResult(res);
				mt.set_type(e);
				return mt;
			}
		}
		MatchType!(T) mt = new MatchType!(T)(pos);
		return mt;
	}
}

