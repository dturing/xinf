/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

interface Transform {
    function getTranslation() :TPoint;
    function getScale() :TPoint;
    function getMatrix() :TMatrix;
    
    function apply( p:TPoint ) :TPoint;
    function applyInverse( p:TPoint ) :TPoint;
}

class Identity implements Transform {
    public function new() {
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix() {
        return { a:1., b:0., c:0., d:1., tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return p;
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return p;
    }
    
    public function toString() {
        return("identity");
    }
}




class Rotate implements Transform {
    var a:Float;
    
    public function new( a:Float ) {
        this.a = a;
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix() {
        var co = Math.cos(a);
        var si = Math.sin(a);
        return { a:co, b:si, c:-si, d:co, tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).apply(p);
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).applyInverse(p);
    }

    public function toString() {
        return("rotate("+(a*TransformParser.R2D)+")");
    }
}

class Scale implements Transform {
    var x:Float;
    var y:Float;
    
    public function new( x:Float, y:Float ) {
        this.x = x;
        this.y = y;
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:x, y:y };
    }
    public function getMatrix() {
        return { a:x, b:0., c:0., d:y, tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).apply(p);
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).applyInverse(p);
    }

    public function toString() {
        return("scale("+x+","+y+")");
    }
}


class SkewX implements Transform {
    var a:Float;
    
    public function new( a:Float ) {
        this.a = a;
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix() {
        return { a:1., b:0., c:Math.tan(a), d:1., tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).apply(p);
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).applyInverse(p);
    }

    public function toString() {
        return("skewX("+(a*TransformParser.R2D)+")");
    }
}


class SkewY implements Transform {
    var a:Float;
    
    public function new( a:Float ) {
        this.a = a;
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix() {
        return { a:1., b:Math.tan(a), c:0., d:1., tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).apply(p);
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).applyInverse(p);
    }

    public function toString() {
        return("skewY("+(a*TransformParser.R2D)+")");
    }
}


class Concatenate implements Transform {
    var a:Transform;
    var b:Transform;

    public function new( a:Transform, b:Transform ) {
        this.a = a;
        this.b = b;
    }
    
    public function getTranslation() {
        return new Matrix( getMatrix() ).getTranslation();
    }
    public function getScale() {
        return new Matrix( getMatrix() ).getScale();
    }
    public function getMatrix() {
        var m = new Matrix( a.getMatrix() ).multiply( b.getMatrix() );
        return m;
    }
    
    public function apply( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).apply(p);
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).applyInverse(p);
    }

    public function toString() {
        return("concat( "+a+", "+b+" )");
    }
}

class TransformParser {
    public static var D2R = ((2.*Math.PI)/360.);
    public static var R2D = (360./(2.*Math.PI));

    /* TODO: 
        scale(sx [sy [cx [cy]]])
        fix translate( cx [cy] )
        inherit
        fit( l t r b [ preserve-aspect-ratio [left|center|right][top|middle|bottom]] )
    */
    static var splitNumbers = ~/[,\r\n\t]/g;
    static var translate = ~/translate\([ \t\r\n]*([0-9eE\.\-]+)[ \t\r\n,]+[ \t\r\n]*([0-9eE\.\-]+)[ \t\r\n]*\)/;
    static var rotate = ~/rotate\(([0-9eE\.\-]+)([ \t\r\n,]+([0-9eE\.\-]+)[ \t\r\n,]+([0-9eE\.\-]+)[ \t\r\n]?)?\)/; 
    static var matrix = ~/matrix\(([0-9eE\.\-]+),([0-9eE\.\-]+),([0-9eE\.\-]+),([0-9eE\.\-]+),([0-9eE\.\-]+),([0-9eE\.\-]+)\)/;
    static var scale = ~/scale\(([0-9eE\.\-, ]+)\)/;
    static var skewX = ~/skewX\((\-*[0-9eE\.]+)\)/;
    static var skewY = ~/skewY\((\-*[0-9eE\.]+)\)/;
    
    static var transform = ~/([a-zA-Z]+\([0-9eE\.\-, ]+\))/;
    
    public static function parse( text:String ) :Transform {
        var r:Transform = null;
        while( transform.match(text) ) {
            //trace("parse single transform: "+transform.matched(1) );
        
            var t = parseSingle( transform.matched(1) );
            if( r!=null ) r = new Concatenate( t, r );
            else r = t;
        
            var p = transform.matchedPos();
            text = text.substr(p.pos+p.len);
        }
        if( r==null ) r=new Identity();
   //     trace("parsed transform "+text+": "+r );
        return r;
    }
    
    public static function parseSingle( text:String ) :Transform {
        var r :Transform;
        if( translate.match(text) ) {
            r = new Translate( 
                    Std.parseFloat(translate.matched(1)),
                    Std.parseFloat(translate.matched(2))
                );
        } else if( matrix.match(text) ) {
            r = new Matrix( {
                    a:Std.parseFloat(matrix.matched(1)),
                    c:Std.parseFloat(matrix.matched(3)),
                    tx:Std.parseFloat(matrix.matched(5)),
                    b:Std.parseFloat(matrix.matched(2)),
                    d:Std.parseFloat(matrix.matched(4)),
                    ty:Std.parseFloat(matrix.matched(6))
                });
        } else if( rotate.match(text) ) {
			if( rotate.matched(2)==null || rotate.matched(2).length==0 ) {
				r = new Rotate( 
						Std.parseFloat(rotate.matched(1)) * D2R
					);
			} else {
				var a = Std.parseFloat(rotate.matched(1));
				var cx = Std.parseFloat(rotate.matched(3));
				var cy = Std.parseFloat(rotate.matched(4));
				r = new Concatenate(
						new Translate(cx,cy),
						new Concatenate(
							new Rotate(a*D2R),
							new Translate(-cx,-cy)
						)
					);
			}
        } else if( scale.match(text) ) {
            var s = splitNumbers.split(scale.matched(1));
            if( s.length==1 ) {
                var scale=Std.parseFloat(s[0]);
                r = new Scale( scale, scale );
            } else if( s.length==2 ) {
                r = new Scale( Std.parseFloat(s[0]), Std.parseFloat(s[1]) );
            } else {
                throw("unimplemented transform: "+text );
            }
        } else if( skewX.match(text) ) {
            r = new SkewX( 
                    Std.parseFloat(skewX.matched(1)) * D2R
                );
        } else if( skewY.match(text) ) {
            r = new SkewY( 
                    Std.parseFloat(skewY.matched(1)) * D2R
                );
        } else if( StringTools.trim(text).length == 0 ) {
            return new Identity();
        } else {
            throw("invalid/unimplemented SVG transform '"+text+"'" );
        }
        
        return r;
    }
}
