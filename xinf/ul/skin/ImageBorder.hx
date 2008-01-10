/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.erno.Renderer;
import xinf.erno.ImageData;

class ImageBorder implements Fill {

    static var LT:Int = 0;
    static var T :Int = 1;
    static var RT:Int = 2;
    static var L :Int = 3;
    static var R :Int = 4;
    static var LB:Int = 5;
    static var B :Int = 6;
    static var RB:Int = 7;
    
    var images:Array<ImageData>;
    var name:String;
    
    private var l:Float;
    private var t:Float;
    private var r:Float;
    private var b:Float;

    public function new( name:String, l:Float, ?t:Float, ?r:Float, ?b:Float ) :Void {
        this.name = name;
        
        if( t==null ) t = l;
        if( r==null ) r = t;
        if( b==null ) b = r;
        this.l=l; this.t=t; this.r=r; this.b=b;
        
        try {
            images = ImageSlicer.slice( name, "png", l, t, r, b );
        } catch(e:Dynamic) {
            trace("could not load "+this+": "+e );
        }
    }
    
    public function getBorder() :{l:Float,t:Float,r:Float,b:Float} {
        return { l:l, t:t, r:r, b:b };
    }

    public function draw( g:Renderer, s:{x:Float,y:Float} ) :Void {
        if( images==null ) return;
        
        var iw=s.x-(l+r);
        var ih=s.y-(t+b);
        if(l!=0 && t!=0 ) g.image( images[LT], {x:0.,y:0.,w:images[LT].width,h:images[LT].height}, {x:0.,    y:0.,w:l,h:t} );
        if(        t!=0 ) g.image( images[ T], {x:0.,y:0.,w:images[ T].width,h:images[ T].height}, {x:l,   y:0.,w:iw, h:t} );
        if(r!=0 && t!=0 ) g.image( images[RT], {x:0.,y:0.,w:images[RT].width,h:images[RT].height}, {x:l+iw,y:0.,w:r,h:t} );

        if( l!=0 ) g.image( images[L], {x:0.,y:0.,w:images[L].width,h:images[L].height}, {x:0.,    y:t,w:l,h:ih} );
        if( r!=0 ) g.image( images[R], {x:0.,y:0.,w:images[R].width,h:images[R].height}, {x:l+iw,y:t,w:r,h:ih} );

        ih+=t;
        if( l!=0 && b!=0 ) g.image( images[LB], {x:0.,y:0.,w:images[LB].width,h:images[LB].height}, {x:0.,    y:ih,w:l,h:b} );
        if(         b!=0 ) g.image( images[ B], {x:0.,y:0.,w:images[ B].width,h:images[ B].height}, {x:l,   y:ih,w:iw, h:b} );
        if( r!=0 && b!=0 ) g.image( images[RB], {x:0.,y:0.,w:images[RB].width,h:images[RB].height}, {x:l+iw,y:ih,w:r,h:b} );
    }

    public function toString() :String {
        return("ImageBorder '"+name+"'");
    }
}
