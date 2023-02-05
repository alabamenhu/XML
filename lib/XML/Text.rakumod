unit class XML::Text;
    use XML::Node;
    use XML::Entity;

    also does XML::Node;

## XML::Text - represents a text node.
## The original text is stored in the 'text' attribute, and is
## preserved in its original format, including whitespace and entities.
## The default stringification removes extra whitespace, and chomps
## the string. If this is not what you expect, call .text directly.
has $.text;

method Str (
    XML::Entity :$decode,
    Bool        :$min,
    Bool        :$strip,
    Bool        :$chomp,
    Bool        :$numeric
) {
    my $text = $!text;
    $text = $decode.decode: $text, :$numeric       if $decode;
    $text = $text.subst:    /\s+/,       ' ', :g   if $min;
    $text = $text.subst:    /\s+$|^\s+/, '',  :g   if $strip;
    $text = $text.chomp                            if $chomp;
    $text;
}

method string (XML::Entity $decode = XML::Entity.new) {
    return self.Str(:$decode, :min, :strip, :chomp, :numeric);
}