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

package xinf.ul;

import xinf.ony.Pane;
import xinf.ony.Element;
import xinf.event.Event;
import xinf.ony.Color;
import xinf.ony.Text;
import xinf.ony.Image;

/**
    Simple Skin element.
    a "Skin" is a *single* decoration for a single type of ui element.
    It will (one day) belong to a Theme (which, in turn, contains Skins for all ui elements)
**/

class Skin extends Pane {
    var child:Element;
    
    var images:Array<Image>;
    var imagesLoaded:Int;
    var l:Float;
    var t:Float;
    var r:Float;
    var b:Float;
    
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        
        images = new Array<Image>();
        imagesLoaded = 0;
        
        var name = "button";
        var format = "png";
        for( side in [ "tl", "t", "tr", "l", "c", "r", "bl", "b", "br" ] ) {
            var i = new Image( side, this, "assets/"+name+"/"+name+"_"+side+"."+format );
            images.push( i );
            i.addEventListener( Event.LOADED, imageLoaded );
        }
        
        autoSize = true;
//        bounds.addEventListener( Event.SIZE_CHANGED, parentSizeChanged );
        
//        setBackgroundColor( new Color().fromRGBInt(0xff0000));
    }
    
    private function imageLoaded( e:Event ) {
        imagesLoaded++;
        if( imagesLoaded == 9 ) {
            trace("all images loaded");
            l = images[0].bounds.width;
            t = images[0].bounds.height;
            r = images[8].bounds.width;
            b = images[8].bounds.height;
        trace("sizes: "+l+","+t+","+r+","+b );
        
            for( i in images ) {
                i.autoSize = false;
            }
        
            updateSize();
        }
    }
    
    private function updateSize() {
    
        if( l==null || r==null ) return;
        trace("update size: "+l+","+t+","+r+","+b+", child "+child.bounds );

        var w = child.bounds.width + l + r;
        var h = child.bounds.height + l + r;

        bounds.setSize( w, h );
    
        images[0].bounds.setPosition(0,0);
        images[1].bounds.setPosition(l,0);
            images[1].bounds.setSize( child.bounds.width, t );
        images[2].bounds.setPosition(w-r,0);
        images[3].bounds.setPosition(0,t);
            images[3].bounds.setSize( l, child.bounds.height );
        images[4].bounds.setPosition(l,t);
            images[4].bounds.setSize( child.bounds.width, child.bounds.height );
        images[5].bounds.setPosition(w-r,t);
            images[5].bounds.setSize( r, child.bounds.height );
        images[6].bounds.setPosition(0,h-b);
        images[7].bounds.setPosition(l,h-b);
            images[7].bounds.setSize( child.bounds.width, b );
        images[8].bounds.setPosition(w-r,h-b);
        
        child.bounds.setPosition( l, t );
    }
    
    public function parentSizeChanged( e:Event ) {
        if( autoSize ) {
            trace("ParentSizeChanged for "+this);
            updateSize();
        }
    }

    public function childSizeChanged( e:Event ) {
        if( autoSize ) {
            trace("ChildSizeChanged for "+this);
            updateSize();
        }
    }
    
    public function setChild( e:Element ) :Void {
        // FIXME: unregister old handler
        child = e;
        child.bounds.addEventListener( Event.SIZE_CHANGED, childSizeChanged );
        updateSize();
    }
}
