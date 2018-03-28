module tpl.ast;

import tpl.element;

class ASTNode {
public:
	Element parsed_node;

	this(ref Element parsed_template)  { 
        parsed_node = parsed_template; 
    }
};