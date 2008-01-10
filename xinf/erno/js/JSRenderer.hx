/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.js;

import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.erno.ImageData;
import xinf.erno.TextFormat;

import js.Dom;
typedef Primitive = js.HtmlDom

class JSRenderer extends ObjectModelRenderer<Primitive> {
    
    override public function createPrimitive(id:Int) :Primitive {
        // create new object
        var o = js.Lib.document.createElement("div");
        o.style.position="absolute";
        untyped o.xinfId = id;
        return o;
    }
    
    override public function clearPrimitive( p:Primitive ) {
        p.innerHTML="";
    }
    
    override public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
        if( child.parentNode!=null ) {
            // FIXME: alternatively to just doing nothing, remove from old parent
            // (although- 
            // throw("Object "+child+" is already attached.");
        } else {
            parent.appendChild( child );
        }
    }
    
    override public function setPrimitiveTransform( p:Primitive, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        // FIXME (maybe): regards only translation
        p.style.left = ""+Math.round(x);
        p.style.top = ""+Math.round(y);
    }

    override public function setPrimitiveTranslation( p:Primitive, x:Float, y:Float ) :Void {
        p.style.left = ""+Math.round(x);
        p.style.top = ""+Math.round(y);
    }

    override public function clipRect( w:Float, h:Float ) {
        current.style.overflow = "hidden";
        current.style.width = ""+Math.max(0,Math.round(w));
        current.style.height = ""+Math.max(0,Math.round(h));
    }
    
    override public function rect( x:Float, y:Float, w:Float, h:Float ) {
        var r = js.Lib.document.createElement("div");
        r.style.position="absolute";
        r.style.left = ""+Math.round(x);
        r.style.top = ""+Math.round(y);
        if( pen.fill != null ) {
			switch( pen.fill ) {
				case SolidColor(red,g,b,a):
					r.style.background = colorToRGBString(red,g,b);
					untyped r.style.opacity = a;
				default:
					untyped r.style.opacity = 0;
			}
        }
        if( pen.width > 0 && pen.stroke != null ) {
			switch( pen.stroke ) {
				case SolidColor(red,g,b,a):
					// FIXME: a
					r.style.border = ""+pen.width+"px solid "+colorToRGBString(red,g,b);
					r.style.width = ""+Math.round(w+1-(pen.width*2));
					r.style.height = ""+Math.round(h+1-(pen.width*2));
				default:
					r.style.border = 0;
			}
		} else {
            r.style.width = ""+Math.round(w);
            r.style.height = ""+Math.round(h);
        }
        current.appendChild( r );
    }

    override public function roundedRect( x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float ) {
        rect( x, y, w, h );
    }
    
    override public function ellipse( x:Float, y:Float, rx:Float, ry:Float ) {
        rect( x-rx, y-ry, rx*2, ry*2 );
    }

    override public function text( x:Float, y:Float, text:String, format:TextFormat ) {
        var r = js.Lib.document.createElement("div");
        r.style.position="absolute";
        r.style.whiteSpace="nowrap";
        r.style.cursor="default";
        if( x!=null ) r.style.left = ""+Math.round(x);
        if( y!=null ) r.style.top = ""+Math.round(y);
		
        if( pen.fill != null ) {
			switch( pen.fill ) {
				case SolidColor(red,g,b,a):
					r.style.color = colorToRGBString(red,g,b);
					untyped r.style.opacity = a;
				default:
					untyped r.style.opacity = 0;
			}
        }
        /*
        if( pen.fontFace != null ) r.style.fontFamily = if( pen.fontFace=="_sans" ) "Bitstream Vera Sans, Arial, sans-serif" else pen.fontFace;pen.fontFace;
        if( pen.fontItalic ) r.style.fontStyle = "italic";
        if( pen.fontBold ) r.style.fontWeight = "bold";
        if( pen.fontSize != null ) r.style.fontSize = ""+pen.fontSize+"px";
        */
        format.apply(r);
        r.innerHTML=text.split("\n").join("<br/>");
        current.appendChild(r);
    }
    
    override public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
        var wf = outRegion.w/inRegion.w;
        var hf = outRegion.h/inRegion.h;

        var r:Image = cast(js.Lib.document.createElement("img"));
        r.src = img.url;
        r.style.position = "absolute";
        r.style.left = ""+Math.round(-inRegion.x*wf);
        r.style.top = ""+Math.round(-inRegion.y*hf);
        r.style.width = ""+Math.round( img.width * wf );
        r.style.height = ""+Math.round( img.height * hf );
        
        var wrap = js.Lib.document.createElement("div");
        wrap.style.position = "absolute";
        wrap.style.overflow = "hidden";
        wrap.style.left = ""+Math.round(outRegion.x);
        wrap.style.top = ""+Math.round(outRegion.y);
        wrap.style.width = ""+Math.round(outRegion.w);
        wrap.style.height = ""+Math.round(outRegion.h);
        
        wrap.appendChild(r);
		
		/* FIXME reenable opacity
		if( pen.fillColor!=null ) {
			untyped r.style.opacity = pen.fillColor.a;
		}
		*/
			
        current.appendChild(wrap);
    }
    
    override public function native( o:NativeObject ) {
        current.appendChild(o);
    }

	public static function colorToRGBString( r:Float, g:Float, b:Float ) :String {
		return "rgb("+Math.round(r*0xff)+","+Math.round(g*0xff)+","+Math.round(b*0xff)+")";	
	}
}
