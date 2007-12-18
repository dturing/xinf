/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import xinf.erno.Renderer;

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

typedef Line = {
    height: Float,
    text: String
}

/**
    multiline, wrapping textbox
**/

class TextBox extends Widget {
    
    public var text :String;
    private var contents :Array<FlowElement>;
    private var lines :Array<Line>;

    public function new( ?text:String ) :Void {
        super();
        setPrefSize( {x:350., y:400.} );
        updateContents( text, 350. );
    }
    
    function updateContents( text:String, width:Float ) :Void {
        var h=0.;
        var x=0.;
        var format = getStyleTextFormat();
        var ls = lines = new Array<Line>();
        var line = new StringBuf();
        var word = new StringBuf();
        var nextLine = function() {
                ls.push( { height:h, text:line.toString() } );
                line = new StringBuf();
                x=0.; h=0.;
            }
        var pushWord = function() {
                var wd = word.toString()+" ";
                var s = format.textSize(wd);
                if( s.x+x > width ) nextLine();
                x+=s.x;
                if( s.y>h ) h=s.y;
                line.add( wd );
                word = new StringBuf();
            }
        for( i in 0...text.length ) { 
            var c = text.charCodeAt(i);
            if( c==10 ) {
                pushWord();
                nextLine();
            } else if( ( c>=9 && c<=13 ) || c==32 ) {
                pushWord();
            } else {
                word.addChar(c);
            }
        }
        pushWord();
        nextLine();
        //trace("Lines: "+lines );
        scheduleRedraw();
    }

    public function drawContents( g:Renderer ) :Void {
        super.drawContents(g); 
        
        if( lines!=null ) {
            var y = 0.;
            var format = getStyleTextFormat();

            GL.pushMatrix();

            GL.translate( Math.round(
                            leftOffsetAligned(prefSize.x,style.get("hAlign",0.))), 
                            topOffsetAligned(prefSize.y,style.get("vAlign",0.)), 
                            .0 );
            GL.scale( format.size, format.size, 1.0 );
            GL.translate( .0, format.font.ascender, .0 );
            GL.color4( 0.,0.,0.,1. );
            
            GL.pushMatrix();
            for( line in lines ) {
                GL.translate( .0, y/format.size, 0. );
                var text = line.text;
                //trace("render "+text+" at "+y );
                for( i in 0...text.length ) {
                    var g = format.font.getGlyph( text.charCodeAt(i), format.size );
                    if( g!=null ) {
                        g.render( format.size );
                    }
                }
                
                y+=line.height;
                GL.popMatrix();
                GL.pushMatrix();
            }
            GL.popMatrix();
            GL.popMatrix();
        }
    }
}
#else true
#end
