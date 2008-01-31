/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.TextFormat;

#if neko
import opengl.GL;
import xinf.geom.Types;
import xinf.erno.TextFormat;
import xinf.erno.Renderer;
import xinf.inity.font.Font;
import xinf.inity.GLRenderer;

enum FlowElement {
    Word( t:String );
    Whitespace( t:String );
    Return;
    FormatChange( f:TextFormat );
}

typedef TextLine = {
	offset: Int,
    text: String
}

class TextArea extends xinf.ony.TextArea {

    var contents :Array<FlowElement>;
    var lines :Array<TextLine>;
	var dirty :Bool;

	// TODO: updateContents when setting width?
    override function set_text( v:String ) :String { 
		dirty=true;
		redraw();
		return setTrait("text",v); 
	}

    var format:TextFormat;
	
	public function new( ?traits:Dynamic ) {
		super(traits);
		dirty=true;
	}

	override public function styleChanged( ?attribute:String ) :Void {
        super.styleChanged( attribute );
		format=null;
		assureFormat();
		updateContents( text );
    }

	function assureFormat() {
		if( format==null ) {
			var family = fontFamily;
			var size = fontSize;
        // TODO: weight
			format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
			format.assureLoaded();
		}
	}
	
    function updateContents( text:String ) :Void {
		if( text==null ) return;
		dirty=false;
		assureFormat();
		
		var ls = lines = new Array<TextLine>();

		var font = format.font;
		var lineHeight = lineIncrement;
		var w=width;
		var h=Math.floor(height/lineIncrement);

		var start=0;
		var lastOffset=0;
		var lastSpace=0;
		var lastSpaceX=0.;
		var x=0.;
		var spaceAdvance = font.getGlyph(32,format.size).advance;

		var push = function( to:Int ) {
			var t = text.substr(lastOffset,to-lastOffset);
			if( t.length==0 ) return;
			ls.push({ offset: lastOffset,
						 text: t });
			//trace("push '"+t+"'" );
			lastOffset=to;
		}
		
		for( i in 0...text.length ) {
			var c = text.charCodeAt(i);
			var g = font.getGlyph(c,format.size);
		//	trace("char "+(String.fromCharCode(c))+", x "+x+"+"+g.advance );
			if( x+g.advance > w && c!=32 ) {
				if( lastSpace==0 ) { // split at character boundary
				//	trace("char split");
					push( i );
					x=0;
				} else { // split at word boundary
				//	trace("word split at "+i+", lastSpace "+lastSpace);
					push( lastSpace );
					x-=lastSpaceX+spaceAdvance;
					lastOffset++;
					lastSpace=0;
				}
			}
			
			if( c==10 ) {
				push(i); lastOffset++;
            } else if( ( c>=9 && c<=13 ) || c==32 ) {
				//trace("space at "+i+", last "+lastOffset );
				lastSpaceX=x;
				x+=g.advance;
				lastSpace=i;
			} else {
				x+=g.advance;
			}
			if( ls.length>=h ) return;
		}
		push( text.length );

		redraw();
    }

    override public function drawContents( g:Renderer ) :Void {
		if( dirty ) {
			updateContents( text );	
		}
	
		assureFormat();
        super.drawContents(g);
		
        if( lines!=null ) {
            var y = (this.y/format.size) + (format.font.descender/2);
			var lineHeight = lineIncrement/format.size;

            GL.pushMatrix();

			GL.enable(GL.BLEND);
            GL.translate( x, y, 0. );
            GL.scale( format.size, format.size, 1.0 );
            GL.translate( .0, format.font.ascender, .0 );
            untyped g.applyFillGL();
            
            GL.pushMatrix();
            for( line in lines ) {
				GL.translate( .0, y, 0. );
				var text = line.text;
				for( i in 0...text.length ) {
					var g = format.font.getGlyph( text.charCodeAt(i), format.size );
					if( g!=null ) {
						GL.translate( g.render()/format.size, 0, 0 );
					}
				}
				
				y+=lineHeight;
				GL.popMatrix();
				GL.pushMatrix();
            }
            GL.popMatrix();
            GL.popMatrix();
			GL.disable(GL.BLEND);
        }
    }
    
}

#else flash9

import xinf.ony.type.Editability;
import xinf.ony.type.Paint;

class TextArea extends xinf.ony.TextArea {

    var format:TextFormat;
	var tf:flash.text.TextField;
	
	public function new( ?traits:Dynamic ) {
		super(traits);
		tf = new flash.text.TextField();
		tf.wordWrap = true;
		tf.autoSize = flash.text.TextFieldAutoSize.NONE;
	}

	override public function focus( ?focus:Bool ) :Void {
	//	throw("focus flash textfield");
		flash.Lib.current.stage.focus = tf;
	}

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);

		if( format==null ) {
			var family = fontFamily;
			var size = fontSize;
        // TODO: weight
			format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
			format.assureLoaded();
		}
		
		switch( fill ) {
			case RGBColor(r,g,b):
				format.format.color = xinf.erno.flash9.Flash9Renderer.colorToRGBInt(r,g,b);
				tf.alpha = 1;
			default:
				throw("Fill "+fill+" not supported for text");
		}
		
		//tf.embedFonts = true;  FIXME handle this somehow good..
		if( editable != None ) {
			tf.selectable = true;
			tf.type = "input";
			tf.condenseWhite = false;
		} else {
			tf.selectable = false;
		}

		tf.defaultTextFormat = format.format;
		
		tf.y=y-1;
		tf.x=x;
		tf.width=width;
		tf.height=height;
		
		//tf.border=true; FIXME exact placement (stupid flash padding)
		
		tf.text = text;

		g.native( tf );
    }
	
}

#else js

import xinf.ony.type.Editability;
import xinf.ony.type.Paint;

class TextArea extends xinf.ony.TextArea {

    var format:TextFormat;

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
		
		if( fill == Paint.None ) return;

		if( format==null ) {
			var family = fontFamily;
			var size = fontSize;
        // TODO: weight
			format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
			format.assureLoaded();
		}

        var r = js.Lib.document.createElement("div");
        r.style.position="absolute";
//        r.style.whiteSpace="nowrap";
		r.style.overflow = "hidden";
        
		if( editable != None ) {
		} else {
			r.style.cursor="default";
		}
		
        r.style.left = ""+Math.round(x);
        r.style.top = ""+Math.round(y);
        r.style.width = ""+Math.round(x);
        r.style.height = ""+Math.round(y);
		
		switch( fill ) {
			case RGBColor(red,g,b):
				r.style.color = xinf.erno.js.JSRenderer.colorToRGBString(red,g,b);
			default:
				throw("Fill "+fill+" not supported for text");
		}
        format.apply(r);
		
        r.innerHTML=text.split("\n").join("<br/>");

		g.native( r );
    }
	
}

#else err
 "platform not supported"
#end
