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

import xinf.xml.Binding;
import xinf.xml.Instantiator;
import xinf.geom.Matrix;
import xinf.erno.Renderer;

/**
    SVG Document element.
**/

class Document extends Group {
    static var binding:Binding<Element>;
    static function __init__() :Void {
        binding = new Binding<Element>();
        
        // basic elements
        binding.add( "svg", Group );
        binding.add( "g", Group );
        binding.add( "rect", Rect );
        binding.add( "path", Path );
        binding.add( "text", Text );
        binding.add( "a", Link );
        
        // "extensions"
        addInstantiator( new HasProperty<xinf.svg.Element>("load",xinf.svg.ext.Load) );
    }
    
    public static function overrideBinding( nodeName:String, cl:Class<Element> ) :Void {
        binding.add( nodeName, cl );
    }
    
    public static function addInstantiator( i:Instantiator<Element> ) :Void {
        binding.addInstantiator( i );
    }


    public var w:Float;
    public var h:Float;
    public var elementsById:Hash<Element>;

    public function new() :Void {
        super();
        document = this;
        elementsById = new Hash<Element>();
    }

    public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        w = getFloatProperty(xml,"width");
        h = getFloatProperty(xml,"height");
        resize(w,h);
    }

    public function unmarshal( xml:Xml ) :Element {
        var r = binding.instantiate( xml );
        if( r==null ) return null;
        r.document = this;
        r.fromXml( xml );
        return r;
    }
    
    public function getElementById( id:String ) :Element {
        var r = elementsById.get(id);
        if( r==null ) throw("No such Element #"+id );
        return r;
    }
    
    
    // FIXME once transforms are elaborate

    public function getMatrix() :Matrix {
        return new xinf.geom.Matrix()
            .setIdentity()
            .setTranslation(position.x,position.y)
            .setScale(size.x/w,size.y/h);
    }
            
    override public function reTransform( g:Renderer ) :Void {
        var m = getMatrix();
        g.setTransform( _id, m.tx, m.ty, m.a, m.b, m.c, m.d );
    }

    override public function globalToLocal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.globalToLocal(q);
        q = getMatrix().applyInverse(q);
        return q;
    }
    
    override public function localToGlobal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = getMatrix().apply(p);
        if( parent!=null ) q = parent.localToGlobal(q);
        return q;
    }
}
