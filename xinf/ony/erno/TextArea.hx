package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;

#if neko
import opengl.GL;
import xinf.geom.Types;
import xinf.erno.Color;
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

class TextArea extends xinf.ony.base.TextArea {

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

	override public function styleChanged() :Void {
        super.styleChanged();
		format=null;
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
	
    function updateContents( text:String, width:Float ) :Void {
		if( text==null ) return;
		dirty=false;
		
        var x=0.;
        assureFormat();
		var _format = format;
        var ls = lines = new Array<TextLine>();
        var line = new StringBuf();
        var word = new StringBuf();
		var offset:Int = 0;
		var lastOffset:Int = 0;
        var nextLine = function() {
				var t = line.toString();
				if( t.length>0 ) {
					offset = lastOffset+t.length;
					ls.push( { offset:lastOffset, text:t } );
					lastOffset = offset;
					line = new StringBuf();
					x=0.;
				}
            }
        var pushWord = function() {
                var wd = word.toString()+" ";
                var s = _format.textSize(wd);
                if( s.x+x > width ) nextLine();
                x+=s.x;
                line.add( wd );
                word = new StringBuf();
            }
        for( i in 0...text.length ) { 
		//	offset=i;
            var c = text.charCodeAt(i);
            if( c==10 ) {
                pushWord();
                nextLine();
            } else if( ( c>=9 && c<=13 ) || c==32 ) {
                pushWord();
            } else {
				offset=i;
                word.addChar(c);
            }
        }
        pushWord();
        nextLine();
		
		redraw();
    }

    override public function drawContents( g:Renderer ) :Void {
		if( dirty ) {
			updateContents( text, width );		
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
				if( y < (this.y-format.size)+height ) {
					GL.translate( .0, y, 0. );
					var text = line.text;
					for( i in 0...text.length ) {
						var g = format.font.getGlyph( text.charCodeAt(i), format.size );
						if( g!=null ) {
							g.render( format.size );
						}
					}
					
					y+=lineHeight;
					GL.popMatrix();
					GL.pushMatrix();
				}
            }
            GL.popMatrix();
            GL.popMatrix();
			GL.disable(GL.BLEND);
        }
    }
    
}

#else flash9

import xinf.ony.Editable;

class TextArea extends xinf.ony.base.TextArea {

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
			case SolidColor(r,g,b,a):
				format.format.color = Color.rgb(r,g,b).toRGBInt();
				tf.alpha = a;
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

import xinf.ony.Editable;

class TextArea extends xinf.ony.base.TextArea {

    var format:TextFormat;

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);

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
			case SolidColor(red,g,b,a):
				r.style.color = Color.rgb(red,g,b).toRGBString();
			//	untyped r.opacity = a;
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
