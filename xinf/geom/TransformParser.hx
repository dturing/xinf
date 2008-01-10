/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

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
    static var matrix = ~/matrix\(([0-9eE\.\-]+)[ \t\r\n,]+([0-9eE\.\-]+)[ \t\r\n,]+([0-9eE\.\-]+)[ \t\r\n,]+([0-9eE\.\-]+)[ \t\r\n,]+([0-9eE\.\-]+)[ \t\r\n,]+([0-9eE\.\-]+)\)/;
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
						new Translate(-cx,-cy),
						new Concatenate(
							new Rotate(a*D2R),
							new Translate(cx,cy)
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
