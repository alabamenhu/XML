## XML::PI - represents a PI section.
## Data is preserved "as is", right from the <? to the ?>
unit class XML::PI;

use       XML::Node;
also does XML::Node;

has $.data;

method Str { "<?$!data?>" }