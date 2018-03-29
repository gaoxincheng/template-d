module tpl.ast;

import tpl.element;

class ASTNode
{
public:
    Element parsed_node;

    this(Element parsed_template)
    {
        parsed_node = parsed_template;
    }
};
