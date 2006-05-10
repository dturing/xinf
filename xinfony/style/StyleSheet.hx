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
    
    public function primaryClasses() : Array<String> {
        var a = new Array<String>();
        for( b in classes ) {
            a.push(b[0]);
        }
        return a;
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

    public function selectedClasses() : Array<String> {
        return(selector.primaryClasses());
    }
}

class StyleSheet {
    private var rules:Array<StyleRule>;
    private var classIndex:Hash<Array<StyleRule>>;
    
    public function new() {
        rules = new Array<StyleRule>();
        classIndex = new Hash<Array<StyleRule>>();
    }
    
    public function match( classes:Iterator<String>, o:Styled ) : List<Style> {
        var list = new List<Style>();
        for( cl in classes ) {
            list = matchClass( cl, list, o );
        }
        return list;
    }
    
    public function matchClass( cl:String, list:List<Style>, o:Styled ) : List<Style> {
        var rules:Array<StyleRule> = classIndex.get(cl);
        if( rules != null ) {
            for( r in rules ) {
                if( r.matches(o) ) {
                    trace("Match ."+cl+": "+r );
                    list.push(r.style);
                }
            }
        }
        return list;
    }
    
    public function fromString( str:String ) :Bool {
        var rs:Array<String> = str.split("}");
        for( r in rs ) {
            var rule:StyleRule = StyleRule.newFromString( r );
            if( rule != null ) {
                for( c in rule.selectedClasses() ) {
                    var a = classIndex.get(c);
                    if( a == null ) {
                        a = new Array<StyleRule>();
                        classIndex.set(c,a);
                    }
                    a.push(rule);
                }
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
