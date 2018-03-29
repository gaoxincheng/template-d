module tpl.renderer;

import std.string;
import std.file;
import std.path;
import std.conv;
import std.variant;
import std.json;
import std.stdio;

import tpl.define;
import tpl.element;
import tpl.match;
import tpl.ast;


class Renderer {
public:
    this(){}
	//std::map<Parsed::CallbackSignature, std::function<json(const Parsed::Arguments&, const json&)>> map_callbacks;


	// bool eval_expression(ElementExpression element, ref JSONValue data) {
	// 	Variant var = eval_function(element, data);
	// 	if (!var.hasValue()) { return false; }
		
	// 	return true;
	// }
    bool eval(JSONValue j)
    {
        if(j.type == JSON_TYPE.OBJECT || j.type == JSON_TYPE.ARRAY)
            return true;
        else if(j.type == JSON_TYPE.STRING)
        {
            return j.str.length > 0 ? true : false;
        }
        else if(j.type == JSON_TYPE.INTEGER)
        {
            return j.integer > 0 ? true : false;
        }
        else if(j.type == JSON_TYPE.TRUE)
        {
            return true;
        }
        else if(j.type == JSON_TYPE.FALSE)
        {
            return false;
        }
        else
            return true;
    }

    T eval_expression(T = JSONValue)(ElementExpression element, ref JSONValue data) {
		auto var = eval_function!(T)(element, data);
		return var;
	}

	T eval_function(T = JSONValue)(ElementExpression element, ref JSONValue data) {
        T result;
        writeln("------ready read element.func---- ");
        writeln("------element.func---- :",element.func);
		switch (element.func) {

			// case Parsed::Function::Upper: {
			// 	std::string str = eval_expression<std::string>(element.args[0], data);
			// 	std::transform(str.begin(), str.end(), str.begin(), toupper);
			// 	return str;
			// }
			// case Parsed::Function::Lower: {
			// 	std::string str = eval_expression<std::string>(element.args[0], data);
			// 	std::transform(str.begin(), str.end(), str.begin(), tolower);
			// 	return str;
			// }
			// case Parsed::Function::Range: {
			// 	const int number = eval_expression<int>(element.args[0], data);
			// 	std::vector<int> result(number);
			// 	std::iota(std::begin(result), std::end(result), 0);
			// 	return result;
			// }
			// case Parsed::Function::Length: {
			// 	const std::vector<json> list = eval_expression<std::vector<json>>(element.args[0], data);
			// 	return list.size();
			// }
			// case Parsed::Function::Sort: {
			// 	std::vector<json> list = eval_expression<std::vector<json>>(element.args[0], data);
			// 	std::sort(list.begin(), list.end());
			// 	return list;
			// }
			// case Parsed::Function::First: {
			// 	const std::vector<json> list = eval_expression<std::vector<json>>(element.args[0], data);
			// 	return list.front();
			// }
			// case Parsed::Function::Last: {
			// 	const std::vector<json> list = eval_expression<std::vector<json>>(element.args[0], data);
			// 	return list.back();
			// }
			// case Parsed::Function::Round: {
			// 	const double number = eval_expression<double>(element.args[0], data);
			// 	const int precision = eval_expression<int>(element.args[1], data);
			// 	return std::round(number * std::pow(10.0, precision)) / std::pow(10.0, precision);
			// }
			// case Parsed::Function::DivisibleBy: {
			// 	const int number = eval_expression<int>(element.args[0], data);
			// 	const int divisor = eval_expression<int>(element.args[1], data);
			// 	return (number % divisor == 0);
			// }
			// case Parsed::Function::Odd: {
			// 	const int number = eval_expression<int>(element.args[0], data);
			// 	return (number % 2 != 0);
			// }
			// case Parsed::Function::Even: {
			// 	const int number = eval_expression<int>(element.args[0], data);
			// 	return (number % 2 == 0);
			// }
			// case Parsed::Function::Max: {
			// 	const std::vector<json> list = eval_expression<std::vector<json>>(element.args[0], data);
			// 	return *std::max_element(list.begin(), list.end());
			// }
			// case Parsed::Function::Min: {
			// 	const std::vector<json> list = eval_expression<std::vector<json>>(element.args[0], data);
			// 	return *std::min_element(list.begin(), list.end());
			// }
			// case Parsed::Function::Not: {
			// 	return not eval_expression<bool>(element.args[0], data);
			// }
			// case Parsed::Function::And: {
			// 	return (eval_expression<bool>(element.args[0], data) and eval_expression<bool>(element.args[1], data));
			// }
			// case Parsed::Function::Or: {
			// 	return (eval_expression<bool>(element.args[0], data) or eval_expression<bool>(element.args[1], data));
			// }
			// case Parsed::Function::In: {
			// 	const json value = eval_expression(element.args[0], data);
			// 	const json list = eval_expression(element.args[1], data);
			// 	return (std::find(list.begin(), list.end(), value) != list.end());
			// }
			// case Parsed::Function::Equal: {
			// 	return eval_expression(element.args[0], data) == eval_expression(element.args[1], data);
			// }
			// case Parsed::Function::Greater: {
			// 	return eval_expression(element.args[0], data) > eval_expression(element.args[1], data);
			// }
			// case Parsed::Function::Less: {
			// 	return eval_expression(element.args[0], data) < eval_expression(element.args[1], data);
			// }
			// case Parsed::Function::GreaterEqual: {
			// 	return eval_expression(element.args[0], data) >= eval_expression(element.args[1], data);
			// }
			// case Parsed::Function::LessEqual: {
			// 	return eval_expression(element.args[0], data) <= eval_expression(element.args[1], data);
			// }
			// case Parsed::Function::Different: {
			// 	return eval_expression(element.args[0], data) != eval_expression(element.args[1], data);
			// }
			// case Parsed::Function::Float: {
			// 	return std::stod(eval_expression<std::string>(element.args[0], data));
			// }
			// case Parsed::Function::Int: {
			// 	return std::stoi(eval_expression<std::string>(element.args[0], data));
			// }
			case Function.ReadJson: {
				try {
                    writeln("--read * json --:",element.command);
                    if(element.command.length > 0)
                        result = data[element.command];
                    else
                        result = element.command;
					return result;
				} catch (Exception e) {
					inja_throw("render_error", "variable '" ~ element.command ~ "' not found");
				}
                break;
			}
			case Function.Result: {
                writeln("--read result --:",element.result.toString);
                result = element.result;
				return result;
			}
			case Function.Default: {
                writeln("-----Function.Default----");
				try {
					return eval_expression!(T)(element.args[0], data);
				} catch (Exception e) {
					return eval_expression!(T)(element.args[1], data);
				}
			}
			// case Function::Callback: {
			// 	Parsed::CallbackSignature signature = std::make_pair(element.command, element.args.size());
			// 	return map_callbacks.at(signature)(element.args, data);
			// }
            default:{
                inja_throw("render_error", "function '" ~ to!string(element.func) ~ "' not found");
            }
		}

		inja_throw("render_error", "unknown function in renderer: " ~ element.command);
		return T();
	}

	string render(ASTNode temp, ref JSONValue data) {
		string result = "";
        //writeln("------temp.parsed_node.children-----: ",temp.parsed_node.children.length);
		foreach(element;  temp.parsed_node.children) {
            //writeln("------element.type-----: ",element.type);
			switch (element.type) {
				case Type.String: {
					auto element_string = cast(ElementString)(element);
					result ~= element_string.text;
					break;
				}
				case Type.Expression: {
					auto element_expression = cast(ElementExpression)(element);
					auto variable = eval_expression(element_expression, data);
                    
                   // writeln("-----variable.type-------: ",variable.type);
					if (variable.type == JSON_TYPE.STRING) {
						result ~= variable.str;
					} else {
					
						result ~= variable.toString;
					}
					break;
				}
				case Type.Loop: {
					auto element_loop = cast(ElementLoop)(element);
					switch (element_loop.loop) {
						case Loop.ForListIn: {
							auto list = eval_expression(element_loop.list, data);
                            writeln("----list ----: ",list);
                            foreach(size_t k,v;list)
                            {
                                JSONValue data_loop = data;
                                data_loop[element_loop.value] = v;
                                result ~=  render(new ASTNode(element_loop), data_loop);
                            }
							// for ( int i = 0; i < list.length; i++) {
							// 	JSONValue data_loop = data;
							// 	/* For nested loops, use parent/index */
							// 	// if (data_loop.count("index") == 1 && data_loop.count("index1") == 1) {
							// 	// 	data_loop["parent"]["index"] = data_loop["index"];
							// 	// 	data_loop["parent"]["index1"] = data_loop["index1"];
							// 	// 	data_loop["parent"]["is_first"] = data_loop["is_first"];
							// 	// 	data_loop["parent"]["is_last"] = data_loop["is_last"];
							// 	// }
							// 	data_loop[element_loop.value] = list[i];
							// 	data_loop["index"] = i;
							// 	data_loop["index1"] = i + 1;
							// 	data_loop["is_first"] = (i == 0);
							// 	data_loop["is_last"] = (i == list.size() - 1);
							// 	result ~=  render(new ASTNode(element_loop), data_loop);
							// }
							break;
						}
						case Loop.ForMapIn: {
							// auto  map = eval_expression(element_loop.list, data);
							// foreach (k,v ; map) {
							// 	JSONValue data_loop = data;
							// 	data_loop[element_loop.key] = k;
							// 	data_loop[element_loop.value] = v;
							// 	result ~=  render(new ASTNode(element_loop), data_loop);
							// }
							break;
						}
                        default : {
                            break;
                        }
					}

					break;
				}
				case Type.Condition: {
					auto element_condition = cast(ElementConditionContainer)(element);
					foreach ( branch; element_condition.children) {
						auto element_branch = cast(ElementConditionBranch)(branch);
                        //writeln("-----element_branch.type-------: ",element_branch.condition_type);
                        auto flg = eval_expression(element_branch.condition, data);
                        //writeln("-----flg.type-------: ",flg.type);
						if (element_branch.condition_type == Condition.Else || eval(flg)) {
                            //writeln("dddddd");
							result ~= render(new ASTNode(element_branch), data);
							break;
						}
					}
					break;
				}
				default: {
					break;
				}
			}
		}
		return result;
	}
}