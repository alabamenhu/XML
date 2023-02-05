## XML::Comment - represents a comment.
## Data is preserved "as is", right from the <!-- to the -->
unit class XML::Comment;

use       XML::Node;
also does XML::Node;

has $.data;

method Str { "<!--$!data-->" }