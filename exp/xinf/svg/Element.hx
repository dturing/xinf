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

package xinf.svg;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.ul.Container;
import xinf.xml.Serializable;
import xinf.style.Style;
import xinf.geom.Matrix;

/**
    SVG base element.
**/

class Element extends Container, implements Serializable {
    public var document:Document;
    public var id:String;
    public var name:String;
    public var matrix:Matrix;

    public function new() :Void {
        super();
        matrix = new Matrix().setIdentity();
    }
    
    // FIXME once transforms are elaborate
    override public function reTransform( g:Renderer ) :Void {
        var m = matrix;
        g.setTransform( _id, m.tx, m.ty, m.a, m.b, m.c, m.d );
        transformChanged();
    }

    override public function globalToLocal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.globalToLocal(q);
        q = matrix.applyInverse(q);
        return q;
    }
    
    override public function localToGlobal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = matrix.apply(p);
        if( parent!=null ) q = parent.localToGlobal(q);
        return q;
    }

	public function globalBBox() :{ l:Float, t:Float, r:Float, b:Float } {
		var p1 = localToGlobal({x:position.x,       y:position.y});
		var p2 = localToGlobal({x:position.x+size.x,y:position.y});
		var p3 = localToGlobal({x:position.x,       y:position.y+size.y});
		var p4 = localToGlobal({x:position.x+size.x,y:position.y+size.y});
		return( {
			l: Math.min( p1.x, Math.min( p2.x, Math.min( p3.x, p4.x ) ) ),
			t: Math.min( p1.y, Math.min( p2.y, Math.min( p3.y, p4.y ) ) ),
			r: Math.max( p1.x, Math.max( p2.x, Math.max( p3.x, p4.x ) ) ),
			b: Math.max( p1.y, Math.max( p2.y, Math.max( p3.y, p4.y ) ) ) } );
	}

    public function fromXml( xml:Xml ) :Void {
        name = xml.get("name");

        if( xml.exists("id") && document!=null ) {
            id = xml.get("id");
            document.elementsById.set( id, this );
        }
        if( xml.exists("style") ) {
            setStyle( xinf.style.Parser.parse( new Style(), xml.get("style") ) );
        }
        if( xml.exists("transform") ) {
            matrix = Transform.parse( xml.get("transform") );
            scheduleTransform();
        }
    }

    function getFloatProperty( xml:Xml, name:String, ?def:Float ) :Float {
        if( xml.exists(name) ) return Std.parseFloat(xml.get(name));
        if( def==null ) def=0;
        return def;
    }

    function getBooleanProperty( xml:Xml, name:String, ?def:Bool ) :Bool {
        if( xml.exists(name) ) {
            var v = xml.get(name);
            if( v.toLowerCase()=="true" || v=="1" ) return true;
            return false;
        }
        if( def==null ) def=false;
        return def;
    }

    override public function drawContents( g:Renderer ) :Void {
        var c:Color = style.get("stroke");
        if( c!=null ) {
            c.a *= style.get("stroke-opacity",1.);
            var width:Float = style.get("stroke-width",0.);
            g.setStroke( c.r, c.g, c.b, c.a, width );
        }
        
        var c:Color = style.get("fill");
        if( c==null ) c=Color.rgba(.5,.5,.5,.5); // semitransparent grey for undefined
        c.a *= style.get("fill-opacity",c.a);
        g.setFill( c.r, c.g, c.b, c.a );
    }

    public function toString() :String {
        return( Type.getClassName( Type.getClass(this) )+"[#"+id+"]" );
    }

}
