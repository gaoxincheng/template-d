module tpl.environment;

import std.string;
import std.json;
import std.file;

import tpl.match;
import tpl.define;
import tpl.parser;
import tpl.renderer;
import tpl.util;
import tpl.ast;

class Environment
{
    string input_path;
    string output_path;

    Parser parser;
    Renderer renderer;

public:
    this()
    {
        input_path = output_path = "./";
        parser = new Parser();
        renderer = new Renderer();
    }

    this(string global_path)
    {
        input_path = output_path = global_path;
        parser = new Parser();
        renderer = new Renderer();
    }

    this(string input_path, string output_path)
    {
        this.input_path = input_path;
        this.output_path = output_path;
        parser = new Parser();
        renderer = new Renderer();
    }

    void set_statement(string open, string close)
    {
        regex_map_delimiters[Delimiter.Statement] = open ~ "\\s*(.+?)\\s*" ~ close;
    }

    void set_line_statement(string open)
    {
        regex_map_delimiters[Delimiter.LineStatement] = "(?:^|\\n)" ~ open ~ " *(.+?) *(?:\\n|$)";
    }

    void set_expression(string open, string close)
    {
        regex_map_delimiters[Delimiter.Expression] = open ~ "\\s*(.+?)\\s*" ~ close;
    }

    void set_comment(string open, string close)
    {
        regex_map_delimiters[Delimiter.Comment] = open ~ "\\s*(.+?)\\s*" ~ close;
    }

    void set_element_notation(ElementNotation element_notation_)
    {
        parser.element_notation = element_notation_;
    }

    ASTNode parse(string input)
    {
        return parser.parse(input);
    }

    ASTNode parse_template(string filename)
    {
        return parser.parse_template(input_path ~ filename);
    }

    string render(string input, JSONValue data)
    {
        return renderer.render(parse(input), data);
    }

    string render_template(ASTNode temp, JSONValue data)
    {
        return renderer.render(temp, data);
    }

    string render_file(string filename, JSONValue data)
    {
        return renderer.render(parse_template(filename), data);
    }

    string render_file_with_json_file(string filename, string filename_data)
    {
        auto data = load_json(filename_data);
        return render_file(filename, data);
    }

    // void write(const std::string& filename, const json& data, const std::string& filename_out) {
    // 	std::ofstream file(output_path + filename_out);
    // 	file << render_file(filename, data);
    // 	file.close();
    // }

    // void write(const Template& temp, const json& data, const std::string& filename_out) {
    // 	std::ofstream file(output_path + filename_out);
    // 	file << render_template(temp, data);
    // 	file.close();
    // }

    // void write_with_json_file(const std::string& filename, const std::string& filename_data, const std::string& filename_out) {
    // 	json data = load_json(filename_data);
    // 	write(filename, data, filename_out);
    // }

    // void write_with_json_file(const Template& temp, const std::string& filename_data, const std::string& filename_out) {
    // 	json data = load_json(filename_data);
    // 	write(temp, data, filename_out);
    // }

    string load_global_file(string filename)
    {
        return parser.load_file(input_path ~ filename);
    }

    JSONValue load_json(string filename)
    {
        return parseJSON(cast(string) std.file.read(input_path ~ filename));
    }
};

@property Environment Env(string input = "./")
{
    return new Environment(input);
}

@property Environment Env(string input, string ouput)
{
    return new Environment(input, ouput);
}