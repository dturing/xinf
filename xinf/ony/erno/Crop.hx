package xinf.ony.erno;

import xinf.erno.Renderer;

class Crop extends xinf.ony.base.Crop  {

    override public function drawContents( g:Renderer ) :Void {
		g.clipRect( width, height );
        super.drawContents(g);
    }
    
}
