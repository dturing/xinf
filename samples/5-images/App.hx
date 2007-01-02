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

import xinf.event.FrameEvent;
import xinf.event.GeometryEvent;
import xinf.event.ImageLoadEvent;
import xinf.erno.Renderer;
import xinf.erno.ImageData;
import xinf.ony.Application;
import xinf.ony.Object;
import xinf.ony.Image;

class ImagePart extends Object {
    
    private var img:ImageData;

    public function new( i:ImageData ) :Void {
        super();
        img = i;
        img.addEventListener( ImageLoadEvent.LOADED, dataChanged );
    }
    
    private function dataChanged( e:ImageLoadEvent ) :Void {
        scheduleRedraw();
    }
    
    public function drawContents( g:Renderer ) :Void {
        if( img==null ) return;
        g.image( img, {x:img.width/4,y:img.height/4,w:img.width/2,h:img.height/2}, 
                        {x:0,y:0,w:size.x,h:size.y} );
    }
    
}


class App extends Application {
    private static var block:Object;

    public function new() :Void {
        super();

        try {
            var i:ImageData = ImageData.load("http://y/xinf-tmp/xinf.png");
            
            block = new Image(i);
            block.moveTo( 100, 50 );
            block.resize( 100, 61 );
            root.attach( block );
            
            var part = new ImagePart(i);
            part.moveTo( 100, 150 );
            part.resize( 100, 61 );
            root.attach( part );
        } catch(e:Dynamic) {
            trace("Exception: "+e+"\n"+haxe.Stack.toString( haxe.Stack.exceptionStack() ) );
        }
    }

    public static function main() :Void {
        try {
            new App().run();
        } catch(e:Dynamic) {
            trace("Exception: "+e+": "+haxe.Stack.toString(haxe.Stack.exceptionStack()) );
        }
    }
}
