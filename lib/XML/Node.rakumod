unit role XML::Node;

has $.parent is rw;

# This method effectively will be used as a "is this an XML::Element" check
# Previous iterations of XML required an indirect look up, which is costly.
# There may be other ways by a dummy role check (XML::Elementable) or something,
# but this feels best.
method is-element { False }

## For XML classes, the gist is the stringified form.
multi method gist (XML::Node:D:) { self.Str }

method previousSibling {
    if $!parent.is-element {
        my $pos = $.parent.index-of(* === self);
        if $pos > 0 {
            return $!parent.nodes[$pos-1];
        }
    }
    return Nil;
}

method nextSibling {
    if $!parent.is-element {
        my $pos = $!parent.index-of(* === self);
        if $pos < $!parent.nodes.end {
            return $!parent.nodes[$pos+1];
        }
    }
    return Nil;
}

method remove {
    if $!parent.is-element {
        $!parent.removeChild(self);
    }
    return self;
}

method reparent ($parent) {
    die "Cannot attach to a node of type {$parent.WHAT}" unless $parent.is-element;
    self.remove if $!parent.defined;
    $!parent = $parent;
    return self;
}

method cloneNode {
    return self.clone;
}

method ownerDocument {
    if $.parent ~~ ::(q<XML::Document>) {
        return $!parent;
    } elsif $.parent ~~ ::(q<XML::Node>) {
        return $!parent.ownerDocument;
    } else {
        return Nil;
    }
}