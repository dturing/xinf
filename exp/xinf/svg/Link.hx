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

import xinf.event.MouseEvent;

import xinf.event.Event;
import xinf.event.EventKind;

/**
    LinkEvent is posted when a svg:link element is clicked.
**/
class LinkEvent extends Event<LinkEvent> {
    
    static public var FOLLOW_LINK = new EventKind<LinkEvent>("followLink");
    
    public var url:String;
    
    public function new( _type:EventKind<LinkEvent>, _url:String ) {
        super(_type);
        url = _url;
    }

    public function toString() :String {
        return( ""+type+"("+url+")" );
    }
    
}

/**
    SVG Link ('a xlink:href') element.
**/

class Link extends Group {

    var link:String;

    public function new() :Void {
        super();
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
    }

    public function onMouseDown( e:MouseEvent ) :Void {
        postEvent( new LinkEvent( LinkEvent.FOLLOW_LINK, link ) );
    }

    public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        link = xml.get("xlink:href");
        if( link==null ) link = xml.get("href"); // FIXME once haxe knows xml namespaces.
    }    
}
