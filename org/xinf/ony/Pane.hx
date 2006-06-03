package org.xinf.ony;

class Pane extends Element {

    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        
        #if js
            _p.style.background = "#0f0";
            _p.style.overflow = "visible";
        #end
    }
    
    private function createPrimitive() :Dynamic {
        #if neko
            return new org.xinf.inity.Box();
        #else js
            return js.Lib.document.createElement("div");
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            return parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
        #end
    }
    
    #if flash
        public function redraw() :Void {
            super.redraw();

            var x:Int = 0;
            var y:Int = 0;
            var w:Int = Math.round(bounds.width);
            var h:Int = Math.round(bounds.height);

            _p.clear();
            _p.beginFill( 0xff0000,  100 );

    //            _p.lineStyle( style.borderWidth, style.borderColor.toInt(), style.borderColor.a*100, true, "", "", "", 0 );

            _p.moveTo( x, y );
            _p.lineTo( w, y );
            _p.lineTo( w, h );
            _p.lineTo( x, h );
            _p.lineTo( x, y );
            _p.endFill();
        }
    #end
}
