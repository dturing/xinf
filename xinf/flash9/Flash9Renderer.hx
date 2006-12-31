/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.flash9;

import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.erno.Color;
import xinf.erno.ImageData;
import xinf.erno.FontStyle;

import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

typedef Primitive = XinfSprite

class Flash9Renderer extends ObjectModelRenderer<Primitive> {
    
    override public function createPrimitive(id:Int) :Primitive {
        // create new object
        var o = new Primitive();
        o.xinfId = id;
        return o;
    }
    
    override public function clearPrimitive( p:Primitive ) {
        p.graphics.clear();
        for( i in 0...p.numChildren ) {
            p.removeChildAt(0);
        }
    }
    
    override public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
        parent.addChild( child );
    }

    /* our part of the drawing protocol */
    public function setPrimitiveTransform( p:Primitive, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        // FIXME: this is only translation
        p.x = x;
        p.y = y;
    }

    public function setPrimitiveTranslation( p:Primitive, x:Float, y:Float ) :Void {
        p.x = x;
        p.y = y;
    }

    public function clipRect( w:Float, h:Float ) {
        var crop = new Sprite();
        var g = crop.graphics;
        g.beginFill( 0xff0000, 1 );
        g.drawRect(1,1,w,h);
        g.endFill();
        current.addChild(crop);
        current.mask = crop;
    }

    public function startShape() {
        if( pen.fillColor != null ) {
            current.graphics.beginFill( pen.fillColor.toRGBInt() );
        }
        if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
            current.graphics.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a );
        }
    }
    
    public function endShape() {
        if( pen.fillColor != null ) {
            current.graphics.endFill();
        }
    }
    
    public function startPath( x:Float, y:Float) {
        current.graphics.moveTo(x,y);
    }
    
    public function endPath() {
        current.graphics.moveTo(0,0);
    }
    
    public function close() {
        // FIXME
    }
    
    public function lineTo( x:Float, y:Float ) {
        current.graphics.lineTo(x,y);
    }
    
    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
        current.graphics.curveTo( x1,y1,x,y );
    }
    
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
        throw("unimplemented");
    }
        
    public function rect( x:Float, y:Float, w:Float, h:Float ) {
        var g = current.graphics;
        if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
            g.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a,
                false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER );
        } else {
            g.lineStyle( 0, 0, 0 );
        }
        if( pen.fillColor != null ) {
            g.beginFill( pen.fillColor.toRGBInt(), pen.fillColor.a );
        } else {
            g.beginFill( 0, 0 );
        }
        g.drawRect( x,y,w,h );
        g.endFill();
    }
    
    public function circle( x:Float, y:Float, r:Float ) {
        throw("unimplemented");
    }
    
    public function text( x:Float, y:Float, text:String ) {
        // FIXME: textStyles
        if( pen.fillColor != null ) {
            var tf = new flash.text.TextField();
            tf.text = text;
            tf.selectable = false;
            tf.y=-1;
            tf.x=-1;
            
            // TODO: bold/italic
            var format:flash.text.TextFormat = tf.getTextFormat();
            format.font = pen.fontFace;
            format.size = pen.fontSize;
            format.color = pen.fillColor.toRGBInt();
            format.leftMargin = 0;
            tf.setTextFormat(format);
            
            current.addChild(tf);
        }
    }
    
    public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
        /* this works, but i feel it's not the most efficient way.
            if you can think of a better one, please submit a patch.
            else, we should at least make an exception for the default case ("natural" image size)*/
    
        var wf = outRegion.w/inRegion.w;
        var hf = outRegion.h/inRegion.h;

        var r:flash.display.Bitmap = img.bitmap;
        r.x = (-inRegion.x*wf)+outRegion.x;
        r.y = (-inRegion.y*hf)+outRegion.y;
        r.width = img.width * wf;
        r.height = img.height * hf;

        var wrap = new Sprite();
        var crop = new Sprite();
        var g = crop.graphics;
        g.beginFill( 0xff0000, 1 );
        g.drawRect(0,0,outRegion.w,outRegion.h);
        g.endFill();
        wrap.addChild(crop);
        wrap.mask = crop;
        
        wrap.addChild( r );

        current.addChild( wrap );
    }

    public function native( o:NativeObject ) {
        current.addChild(o);
    }
    
}
