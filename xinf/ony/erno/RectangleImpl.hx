package xinf.ony.erno;

import xinf.erno.Renderer;

class RectangleImpl extends xinf.ony.Rectangle  {

    override private function set_x(v:Float) {
        x=v; scheduleRedraw(); return x;
    }
    override private function set_y(v:Float) {
        y=v; scheduleRedraw(); return y;
    }
    override private function set_width(v:Float) {
        width=v; scheduleRedraw(); return width;
    }
    override private function set_height(v:Float) {
        height=v; scheduleRedraw(); return height;
    }
    override private function set_rx(v:Float) {
        rx=v; scheduleRedraw(); return rx;
    }
    override private function set_ry(v:Float) {
        ry=v; scheduleRedraw(); return ry;
    }
    
    override public function drawContents( g:Renderer ) :Void {
        if( width<=0 || height<=0 ) return;
        super.drawContents(g);
        
        if( rx==0 && ry==0 ) {
            g.rect( x, y, width, height );
        } else {
            var ry2=ry;
            if( ry2==0. ) ry2=rx;
            var rx2=rx;
            if( rx2==0. ) rx2=ry2;
            if( rx2 > (width/2) ) rx2 = width/2;
            if( ry2 > (height/2) ) ry2 = height/2;
            
            g.roundedRect( x, y, width, height, rx2, ry2 );
        }
    }
    
	public function new() {
		trace("RectImpl");
		super();
	}
}
