/* 
   xinf is not flash.
   Copyr (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.style;

import xinf.erno.Renderer;
import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;

class ImageSkin extends Skin {

    static var partNames:Array<String> = ["lt","t","rt","lc","c","rc","lb","b","rb"];
    static var LT:Int = 0;
    static var T :Int = 1;
    static var RT:Int = 2;
    static var L :Int = 3;
    static var C :Int = 4;
    static var R :Int = 5;
    static var LB:Int = 6;
    static var B :Int = 7;
    static var RB:Int = 8;
    
    var images:Array<ImageData>;
    var name:String;
    public static var loading:Int = -1;

    public function new( name:String, ?ext:String ) :Void {
        if( ext==null ) ext = ".png";
        images = new Array<ImageData>();
        loading=0;
        for( part in partNames ) {
            loading++;
            var i = ImageData.load( name+part+ext );
            i.addEventListener( ImageLoadEvent.LOADED, imgLoaded );
            images.push( i );
        }
        this.name = name;
    }
    
    static function imgLoaded( e ) {
        loading--;
    }

    public function drawBorder( g:Renderer, s:{x:Float,y:Float}, b:{l:Float,t:Float,r:Float,b:Float} ) :Void {
        var iw=s.x-(b.l+b.r);
        var ih=s.y-(b.t+b.b);
        if(b.l!=0 && b.t!=0 ) g.image( images[LT], {x:0.,y:0.,w:images[LT].width,h:images[LT].height}, {x:0.,    y:0.,w:b.l,h:b.t} );
        if(          b.t!=0 ) g.image( images[ T], {x:0.,y:0.,w:images[ T].width,h:images[ T].height}, {x:b.l,   y:0.,w:iw, h:b.t} );
        if(b.r!=0 && b.t!=0 ) g.image( images[RT], {x:0.,y:0.,w:images[RT].width,h:images[RT].height}, {x:b.l+iw,y:0.,w:b.r,h:b.t} );

        if( b.l!=0 ) g.image( images[L], {x:0.,y:0.,w:images[L].width,h:images[L].height}, {x:0.,    y:b.t,w:b.l,h:ih} );
        if( b.r!=0 ) g.image( images[R], {x:0.,y:0.,w:images[R].width,h:images[R].height}, {x:b.l+iw,y:b.t,w:b.r,h:ih} );

        ih+=b.t;
        if( b.l!=0 && b.b!=0 ) g.image( images[LB], {x:0.,y:0.,w:images[LB].width,h:images[LB].height}, {x:0.,    y:ih,w:b.l,h:b.b} );
        if(           b.b!=0 ) g.image( images[ B], {x:0.,y:0.,w:images[ B].width,h:images[ B].height}, {x:b.l,   y:ih,w:iw, h:b.b} );
        if( b.r!=0 && b.b!=0 ) g.image( images[RB], {x:0.,y:0.,w:images[RB].width,h:images[RB].height}, {x:b.l+iw,y:ih,w:b.r,h:b.b} );
    }

    public function drawBackground( g:Renderer, s:{x:Float,y:Float}, b:{l:Float,t:Float,r:Float,b:Float} ) :Void {
        try {
            var l=3.; var t=3.;
            var w=s.x-(2*l); var h=s.y-(2*l);
            g.image( images[C], {x:0.,y:0.,w:images[C].width,h:images[C].height}, {x:l,y:t,w:w, h:h} );
        } catch(e:Dynamic) {
            trace(e+" in skin "+name+", img "+images[C]);
        }
    }

    public function toString() :String {
        return("ImageSkin '"+name+"'");
    }
}
