package xinfony.style;

import xinfony.Styled;

class StyleSelector {
    private var classes:Array<Array<String>>;
    
    public function new() {
        classes = new Array<Array<String>>();
    }
    
    public function fromString( str:String ) :Bool {
        var l = str.split(",");
        for( _c in l ) {
            var c = StringTools.trim(_c);
            if( c.length>0 ) {
                var a:Array<String> = new Array<String>();
                for( _d in c.split(".") ) {
                    var d = StringTools.trim(_d);
                    if( d.length > 0 ) {
                        a.push(d);
                    }
                }
                if( a.length>0 ) classes.push(a);
            }
        } 
        return true;
    }
    
    public static function newFromString( str:String ) :StyleSelector {
        var v = new StyleSelector();
        if( v.fromString(str) ) return v;
        return null;
    }

    public function matches( o:Styled ) :Bool {
        for( cls in classes ) {
            var t:Bool = true;
            var i:Iterator<String>=cls.iterator();
            while( i.hasNext() && t ) {
                if( !o.hasStyleClass( i.next() ) ) t=false;
            }
            if( t ) return true;
        }
        return( false );
    }
    
    public function toString() :String {
        var s:String = "";
        for( i in 0...classes.length ) {
            for( cl in classes[i] ) {
                s += "."+cl;
            }
            if( i < classes.length-1 ) s+=", ";
        }
        return( s );
    }
}

class StyleRule {
    private var selector:StyleSelector;
    public var style:Style;
    
    public function new() {
    }
    
    public function fromString( str:String ) :Bool {
        var split = str.indexOf("{",0);
        if( split==-1 ) return( false );
        
        var s_sel = StringTools.trim(str.substr( 0, split ));
        var s_style = StringTools.trim(str.substr( split+1, str.length-split ));
        
        selector = StyleSelector.newFromString( s_sel );
        style = Style.newFromString( s_style );
        return true;
    }
    
    public function matches( o:Styled ) :Bool {
        return( selector.matches(o) );
    }
    
    public static function newFromString( str:String ) :StyleRule {
        var v = new StyleRule();
        if( v.fromString(str) ) return v;
        return null;
    }
    
    public function toString() :String {
        return (""+selector+" { "+style+"}");
    }
}

class StyleSheet {
    private var rules:Array<StyleRule>;
    
    public function new() {
        rules = new Array<StyleRule>();
    }
    
    public function append( s:StyleSheet ) : Void {
        rules = rules.concat( s.rules );
    }
    
    public function match( o:Styled ) : List<Style> {
        var list = new List<Style>();
        for( r in rules ) {
            if( r.matches(o) ) {
//                trace("Match: "+r );
                list.push(r.style);
            }
        }
        return list;
    }
    
    public function fromString( str:String ) :Bool {
        var rs:Array<String> = str.split("}");
        for( r in rs ) {
            var rule:StyleRule = StyleRule.newFromString( r );
            if( rule != null ) {
                rules.push(rule);
            }
        }
        return( rules.length > 0 );
    }
    
    
    public static function newFromString( str:String ) :StyleSheet {
        var v = new StyleSheet();
        if( v.fromString(str) ) return v;
        return null;
    }
    
    public function toString() :String {
        return( "\n\t"+rules.join("\n\t")+"\n\t" );
    }
}
