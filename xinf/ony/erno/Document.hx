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

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.geom.Matrix;
import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;
import xinf.xml.Binding;
import xinf.xml.Instantiator;
import xinf.ony.URL;

class Document extends Group, implements xinf.ony.Document {
   static var binding:Binding<xinf.ony.Element>;
    static function __init__() :Void {
        binding = new Binding<xinf.ony.Element>();
        
        // basic elements
        binding.add( "g", Group );
        binding.add( "rect", Rectangle );
        binding.add( "line", Line );
        binding.add( "polygon", Polygon );
        binding.add( "polyline", Polyline );
        binding.add( "ellipse", Ellipse );
        binding.add( "circle", Circle );
        binding.add( "text", Text );
        binding.add( "path", Path );
        binding.add( "image", Image );
        /*
        binding.add( "a", Link );
        */
    }
    
    public static function overrideBinding( nodeName:String, cl:Class<xinf.ony.Element> ) :Void {
        binding.add( nodeName, cl );
    }
    
    public static function addInstantiator( i:Instantiator<xinf.ony.Element> ) :Void {
        binding.addInstantiator( i );
    }


    public var width(default,set_width):Int;
    public var height(default,set_height):Int;
    private function set_width(v:Int) {
        width=v; return width;
    }
    private function set_height(v:Int) {
        height=v; return height;
    }

    public var styleSheet(default,null):xinf.style.StyleSheet;
    public var elementsById(default,null):Hash<xinf.ony.Element>;

    private var baseURL:URL;

    public function new() :Void {
        super();
        document=this;
        styleSheet=null;
        elementsById = new Hash<xinf.ony.Element>();
    }

    public function setBaseURL( url:URL ) :URL {
        baseURL = url;
        return baseURL;
    }
    public function getBaseURL() :URL {
        return baseURL;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        // for now...
        if( xml.exists("viewBox") ) {
            var vb = xml.get("viewBox").split(" ");
            if( vb.length != 4 ) {
                throw("illegal/unsupported viewBox: "+vb );
            }
            width = Std.parseInt( vb[2] );
            height = Std.parseInt( vb[3] );
        }
    }

    public function getElementById( id:String ) :xinf.ony.Element {
        var r = elementsById.get(id);
        if( r==null ) throw("No such Element #"+id );
        return r;
    }

    public function unmarshal( xml:Xml, ?parent:xinf.ony.Group ) :xinf.ony.Element {
        var r = binding.instantiate( xml );
        if( r==null ) return null;
        
        if( parent!=null ) parent.attach(r);
        untyped r.document = this; // FIXME
        
        r.fromXml( xml );
        if( r.id!=null ) {
            elementsById.set( r.id, r );
        }
        return r;
    }

    override public function attachedTo( p:xinf.ony.Group ) :Void {
        super.attachedTo(p);
        document=this;
    }
    
}
