unit grammar XML::Grammar;

rule TOP {
    ^
    <xmldecl>?      [ <comment> | <pi> ]*
    <doctypedecl>?  [ <comment> | <pi> ]*
    <root=element>  [ <comment> | <pi> ]*
    $
}

regex comment { '<!--' <( .*? )> '-->' }
regex pi      { '<?'   <( .*? )>  '?>' }

rule xmldecl {
   '<?xml'
    <version>
    <encoding>?
   '?>'
}

token version  { 'version='  <( <value> )> }
token encoding { 'encoding=' <( <value> )> }

proto
token value        {          *          }
token value:double { \" <( <-["]>* )> \" }
token value:single { \' <( <-[']>* )> \' }

token doctypedecl {
    '<!DOCTYPE' \s+ <name> $<content>=[<-[>]>*] '>'
}

token element {
    '<' \s* <name> \s* <attribute>*
    [
    | '/>'
    | '>' <child>* '</' $<name> '>'
    ]
}

rule attribute {
    <name> '=' <value>
}

token child {
    | <element>
    | <cdata>
    | <text=textnode>
    | <comment>
    | <pi>
}

regex cdata    { '<![CDATA[' <( .*? )> ']]>' }
token textnode { <-[<]>+ }
token name {
    # Name can begin with any of these:
    <[a..z  A..Z  : _  \xC0..\xD6  \xD8..\xF6  \xF8..\x2FF  \x370..\x37D
      \x37F..\x1FFF  \x200C..\x200D  \x2070..\x218F  \x2C00..\x2FEF
      \x3001..\xD7FF  \xF900..\xFDCF  \xFDF0..\xFFFD  \x10000..\xEFFFF]>

    # Subsequent characters can also include
    # (basically, hyphen, period, numbers, and a few others)
    <[a..z  A..Z  0..9  : _ . \xB7 \xC0..\xD6  \xD8..\xF6  \xF8..\x37D
    \x37F..\x1FFF  \x200C..\x200D  \x203F..\x2040 \x2070..\x218F  \x2C00..\x2FEF
    \x3001..\xD7FF  \xF900..\xFDCF  \xFDF0..\xFFFD  \x10000..\xEFFFF -]>*
}
