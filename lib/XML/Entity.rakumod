unit class XML::Entity;

## A class for working with XML entities.
has @.entity-names  is rw = ['&amp;','&lt;','&gt;','&quot;','&apos;'];
has @.entity-values is rw = ['&'    ,'<'   ,'>'   ,'"'     , ‘'’    ];

# This should unnecessary when finished
method entityNames  { @!entity-names  }
method entityValues { @!entity-values }


## A quick sub that uses only the default XML entities.
sub decode-xml-entities (Str $in, Bool :$numeric) is export {
    ::?CLASS.new.decode($in, :$numeric);
}

## A quick sub to encode default XML entities.
sub encode-xml-entities (Str $in, Bool :$hex, *@numeric) is export {
    ::?CLASS.new.encode($in, :$hex, |@numeric);
}

## Decode registered XML entitites.
method decode (Str $in, Bool :$numeric = False) {
    my $out = $in.trans(@!entity-names => @!entity-values);
    if $numeric {
        $out.=subst(/'&#'  $<dec>=[ <digit>+] ';'/,  {   $<dec>.Int.chr }, :g);
        $out.=subst(/'&#x' $<hex>=[<xdigit>+] ';'/,  { :16(~$<hex>).chr }, :g);
    }
    $out;
}

## Encode named XML entities.
## You can pass an array of numeric entities to encode.
method encode (Str $in, Bool :$hex, *@numeric) {
    my $out = $in.trans(@.entityValues => @.entityNames);
    for @numeric -> $code {
        my $char = $code.chr;
        my $replacement;
        if $hex {
            $replacement = '&#x'~$code.base(16)~';' if $hex;
        } else {
            $replacement = '&#'~$code~';';
        }
        $out.=subst($char, $replacement, :g);
    }
    $out;
}

## Add a custom entity.
multi method add (Str $name is copy, Str $value) {
    $name  = "&$name" if !$name.match(/^'&'/);
    $name  = "$name;" if !$name.match(/';'$/);
    @!entity-names.push:  $name;
    @!entity-values.push: $value;
}

multi method add (Pair $pair) {
    self.add: $pair.key, $pair.value;
}

