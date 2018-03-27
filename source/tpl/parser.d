// module tpl.parser;

// import tpl.define;
// import tpl.element;
// import tpl.match;

// class Parser {
// public:
// 	ElementNotation element_notation = ElementNotation.Pointer;

// 	/*!
// 	@brief create a corresponding regex for a function name with a number of arguments seperated by ,
// 	*/
// 	static RegexObj function_regex(const string name, int number_arguments) {
// 		string pattern = name;
// 		pattern ~= "(?:\\(";
// 		for (int i = 0; i < number_arguments; i++) {
// 			if (i != 0) pattern ~= ",";
// 			pattern ~= "(.*)";
// 		}
// 		pattern ~= "\\))";
// 		if (number_arguments == 0) { // Without arguments, allow to use the callback without parenthesis
// 			pattern ~= "?";
// 		}
// 		return RegexObj("\\s*" + pattern + "\\s*");
// 	}

// 	/*!
// 	@brief dot notation to json pointer notiation
// 	*/
// 	// static std::string dot_to_json_pointer_notation(const std::string& dot) {
// 	// 	std::string result = dot;
// 	// 	while (result.find(".") != std::string::npos) {
// 	// 		result.replace(result.find("."), 1, "/");
// 	// 	}
// 	// 	result.insert(0, "/");
// 	// 	return result;
// 	// }


// 	//std::map<Parsed::CallbackSignature, Regex, std::greater<Parsed::CallbackSignature>> regex_map_callbacks;
// 	this() { }

// 	ElementExpression parse_expression(const string input) {
// 		// MatchType<Parsed::CallbackSignature> match_callback = match(input, regex_map_callbacks);
// 		// if (!match_callback.type().first.empty()) {
// 		// 	std::vector<Parsed::ElementExpression> args = {};
// 		// 	for (unsigned int i = 1; i < match_callback.size(); i++) { // str(0) is whole group
// 		// 		args.push_back( parse_expression(match_callback.str(i)) );
// 		// 	}

// 		// 	Parsed::ElementExpression result = Parsed::ElementExpression(Parsed::Function::Callback);
// 		// 	result.args = args;
// 		// 	result.command = match_callback.type().first;
// 		// 	return result;
// 		// }

// 		auto match_function = RegexObj.match!Function(input, regex_map_functions);
// 		switch ( match_function.type() ) {
// 			case Function.ReadJson: {
// 				string command = match_function.str(1);
	
// 				ElementExpression result = ElementExpression(Function.ReadJson);
// 				switch (element_notation) {
// 					case ElementNotation.Pointer: {
// 						if (command[0] != '/') { command = "/"~command; }
// 						result.command = command;
// 						break;
// 					}
// 					case ElementNotation.Dot: {
// 						result.command = command;
// 						break;
// 					}
// 				}
// 				return result;
// 			}
// 			default: {
// 				ElementExpression[] args;
// 				for ( int i = 1; i < match_function.length(); i++) { // str(0) is whole group
// 					args ~= parse_expression(match_function.str(i)) ;
// 				}
                
// 				ElementExpression result = ElementExpression(match_function.type());
// 				result.args = args;
// 				return result;
// 			}
// 		}
// 	}

// 	Element[] parse_level(const string input, const string path) {
// 		Element[] result;

// 		size_t current_position = 0;
// 		auto match_delimiter = RegexObj.search_all(input);
// 		while (match_delimiter.found()) {
// 			//current_position = match_delimiter.end_position();
// 			string string_prefix = match_delimiter.prefix();
// 			if (!string_prefix.empty()) {
// 				result ~= ElementString(string_prefix);
// 			}

// 			string delimiter_inner = match_delimiter.str(1);

// 			switch ( match_delimiter.type() ) {
// 				case Delimiter.Statement:
// 				case Delimiter.LineStatement: {

// 					auto match_statement = RegexObj.match!Statement(delimiter_inner, regex_map_statement_openers);
// 					switch ( match_statement.type() ) {
// 						case Statement.Loop: {
// 							MatchClosed loop_match = search_closed(input, match_delimiter.regex(), regex_map_statement_openers.at(Parsed::Statement::Loop), regex_map_statement_closers.at(Parsed::Statement::Loop), match_delimiter);

// 							current_position = loop_match.end_position();

// 							const std::string loop_inner = match_statement.str(0);
// 							MatchType<Parsed::Loop> match_command = match(loop_inner, regex_map_loop);
// 							if (not match_command.found()) {
// 								inja_throw("parser_error", "unknown loop statement: " + loop_inner);
// 							}
// 							switch (match_command.type()) {
// 								case Parsed::Loop::ForListIn: {
// 									const std::string value_name = match_command.str(1);
// 									const std::string list_name = match_command.str(2);

// 									result.emplace_back( std::make_shared<Parsed::ElementLoop>(match_command.type(), value_name, parse_expression(list_name), loop_match.inner()));
// 									break;
// 								}
// 								case Parsed::Loop::ForMapIn: {
// 									const std::string key_name = match_command.str(1);
// 									const std::string value_name = match_command.str(2);
// 									const std::string list_name = match_command.str(3);

// 									result.emplace_back( std::make_shared<Parsed::ElementLoop>(match_command.type(), key_name, value_name, parse_expression(list_name), loop_match.inner()));
// 									break;
// 								}
// 							}
// 							break;
// 						}
// 						case Parsed::Statement::Condition: {
// 							auto condition_container = std::make_shared<Parsed::ElementConditionContainer>();

// 							Match condition_match = match_delimiter;
// 							MatchClosed else_if_match = search_closed_on_level(input, match_delimiter.regex(), regex_map_statement_openers.at(Parsed::Statement::Condition), regex_map_statement_closers.at(Parsed::Statement::Condition), regex_map_condition.at(Parsed::Condition::ElseIf), condition_match);
// 							while (else_if_match.found()) {
// 								condition_match = else_if_match.close_match;

// 								const std::string else_if_match_inner = else_if_match.open_match.str(1);
// 								MatchType<Parsed::Condition> match_command = match(else_if_match_inner, regex_map_condition);
// 								if (not match_command.found()) {
// 									inja_throw("parser_error", "unknown if statement: " + else_if_match.open_match.str());
// 								}
// 								condition_container->children.push_back( std::make_shared<Parsed::ElementConditionBranch>(else_if_match.inner(), match_command.type(), parse_expression(match_command.str(1))) );

// 								else_if_match = search_closed_on_level(input, match_delimiter.regex(), regex_map_statement_openers.at(Parsed::Statement::Condition), regex_map_statement_closers.at(Parsed::Statement::Condition), regex_map_condition.at(Parsed::Condition::ElseIf), condition_match);
// 							}

// 							MatchClosed else_match = search_closed_on_level(input, match_delimiter.regex(), regex_map_statement_openers.at(Parsed::Statement::Condition), regex_map_statement_closers.at(Parsed::Statement::Condition), regex_map_condition.at(Parsed::Condition::Else), condition_match);
// 							if (else_match.found()) {
// 								condition_match = else_match.close_match;

// 								const std::string else_match_inner = else_match.open_match.str(1);
// 								MatchType<Parsed::Condition> match_command = match(else_match_inner, regex_map_condition);
// 								if (not match_command.found()) {
// 									inja_throw("parser_error", "unknown if statement: " + else_match.open_match.str());
// 								}
// 								condition_container->children.push_back( std::make_shared<Parsed::ElementConditionBranch>(else_match.inner(), match_command.type(), parse_expression(match_command.str(1))) );
// 							}

// 							MatchClosed last_if_match = search_closed(input, match_delimiter.regex(), regex_map_statement_openers.at(Parsed::Statement::Condition), regex_map_statement_closers.at(Parsed::Statement::Condition), condition_match);
// 							if (not last_if_match.found()) {
// 								inja_throw("parser_error", "misordered if statement");
// 							}

// 							const std::string last_if_match_inner = last_if_match.open_match.str(1);
// 							MatchType<Parsed::Condition> match_command = match(last_if_match_inner, regex_map_condition);
// 							if (not match_command.found()) {
// 								inja_throw("parser_error", "unknown if statement: " + last_if_match.open_match.str());
// 							}
// 							if (match_command.type() == Parsed::Condition::Else) {
// 								condition_container->children.push_back( std::make_shared<Parsed::ElementConditionBranch>(last_if_match.inner(), match_command.type()) );
// 							} else {
// 								condition_container->children.push_back( std::make_shared<Parsed::ElementConditionBranch>(last_if_match.inner(), match_command.type(), parse_expression(match_command.str(1))) );
// 							}

// 							current_position = last_if_match.end_position();
// 							result.emplace_back(condition_container);
// 							break;
// 						}
// 						case Parsed::Statement::Include: {
// 							std::string included_filename = path + match_statement.str(1);
// 							Template included_template = parse_template(included_filename);
// 							for (auto element : included_template.parsed_template.children) {
// 								result.emplace_back(element);
// 							}
// 							break;
// 						}
// 					}
// 					break;
// 				}
// 				case Parsed::Delimiter::Expression: {
// 					result.emplace_back( std::make_shared<Parsed::ElementExpression>(parse_expression(delimiter_inner)) );
// 					break;
// 				}
// 				case Parsed::Delimiter::Comment: {
// 					result.emplace_back( std::make_shared<Parsed::ElementComment>(delimiter_inner) );
// 					break;
// 				}
// 			}

// 			match_delimiter = search(input, regex_map_delimiters, current_position);
// 		}
// 		if (current_position < input.length()) {
// 			result.emplace_back( std::make_shared<Parsed::ElementString>(input.substr(current_position)) );
// 		}

// 		return result;
// 	}

// 	std::shared_ptr<Parsed::Element> parse_tree(std::shared_ptr<Parsed::Element> current_element, const std::string& path) {
// 		if (not current_element->inner.empty()) {
// 			current_element->children = parse_level(current_element->inner, path);
// 			current_element->inner.clear();
// 		}

// 		if (not current_element->children.empty()) {
// 			for (auto& child: current_element->children) {
// 				child = parse_tree(child, path);
// 			}
// 		}
// 		return current_element;
// 	}

// 	Template parse(const std::string& input) {
// 		auto parsed = parse_tree(std::make_shared<Parsed::Element>(Parsed::Element(Parsed::Type::Main, input)), "./");
// 		return Template(*parsed);
// 	}

// 	Template parse_template(const std::string& filename) {
// 		std::string input = load_file(filename);
// 		std::string path = filename.substr(0, filename.find_last_of("/\\") + 1);
// 		auto parsed = parse_tree(std::make_shared<Parsed::Element>(Parsed::Element(Parsed::Type::Main, input)), path);
// 		return Template(*parsed);
// 	}

// 	std::string load_file(const std::string& filename) {
// 		std::ifstream file(filename);
// 		std::string text((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
// 		return text;
// 	}
// };