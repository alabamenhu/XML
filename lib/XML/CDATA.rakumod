## XML::CDATA - represents a CDATA section.
## Data is preserved "as is ", right from the [ to the ]]>
unit class XML::CDATA;

use       XML::Node;
also does XML::Node;

has $.data;
method Str { "<![CDATA[$!data]]>" }