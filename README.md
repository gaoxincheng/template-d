
Template-d is a template engine for Dlang, loosely inspired by [jinja](http://jinja.pocoo.org) for python. It has an easy and yet powerful template syntax with all variables, loops, conditions, includes, comments  as you like. Template-d uses the JSONValue for data input and handling. Have a look what it looks like:

```D
JSONValue data;
data["name"] = "world";

Env().render("Hello {{ name }}!", data); // Returns "Hello world!"
```

## Tutorial

This tutorial will give you an idea how to use Template-d.

### Template Rendering

The basic template rendering takes a template as a `string` and a `JSONValue` object for all data. It returns the rendered template as an `string`.

```D
JSONValue data;
data["name"] = "world";

render("Hello {{ name }}!", data); // "Hello world!"

// For more advanced usage, an environment is recommended
Environment env = new Environment();

// Render a string with json data
string result = env.render("Hello {{ name }}!", data); // "Hello world!"

// Or directly read a template file
ASTNode temp = env.parse_template("./template.txt");
string result = env.render_template(temp, data); // "Hello world!"

data["name"] = "Dlang";
string result = env.render_template(temp, data); // "Hello Dlang!"

```

The environment class can be configured to your needs.
```D
// With default settings
Environment env_default = new Environment();

// With global path to template files
Environment env = new Environment("../path/templates/");

// With global path where to save rendered files
Environment env = new Environment("../path/templates/", "../path/results/");

// With other opening and closing strings (here the defaults, as regex)
env.set_expression("\\{\\{", "\\}\\}"); // Expressions {{ }}
env.set_comment("\\{#", "#\\}"); // Comments {# #}
env.set_statement("\\{\\%", "\\%\\}"); // Statements {% %} for many things, see below
env.set_line_statement("##"); // Line statements ## (just an opener)
```

### Variables

Variables are rendered within the `{{ ... }}` expressions.
```c++
JSONValue data;
data["neighbour"] = "Peter";
data["guests"] = {"Jeff", "Tom", "Patrick"};
data["time"]["start"] = 16;
data["time"]["end"] = 22;

render("{{ neighbour }}", data); // "Peter"
```

### Statements

Statements can be written either with the `{% ... %}` syntax or the `##` syntax for entire lines. The most important statements are loops, conditions and file includes. All statements can be nested.

#### Loops

```D
// Combining loops and line statements
render("(Guest List:
## for guest in guests
	{{ index }}: {{ guest }}
## endfor )", data)

/* Guest List:
	1: Jeff
	2: Tom
	3: Patrick */
```

#### Conditions

Conditions support the typical if, else if and else statements. Following conditions are for example possible:
```D
// Standard comparisons with variable
render("{% if hour >= 18 %}…{% endif %}", data); // True
```

#### Includes

This includes other template files, relative from the current file location.
```
{% include "footer.html" %}
```

### Functions

A few functions are implemented within the  template syntax. They can be called with
```D
// Upper and lower function, for string cases
render("Hello {{ upper(neighbour) }}!", data); // "Hello PETER!"
render("Hello {{ lower(neighbour) }}!", data); // "Hello peter!"
```

### Comments

Comments can be written with the `{# ... #}` syntax.
```D
render("Hello{# Todo #}!", data); // "Hello!"
```
