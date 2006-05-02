package org.xinf.display;

import org.xinf.display.DisplayObjectContainer;
import org.xinf.render.IRenderer;

class Stage extends DisplayObjectContainer {
    public var renderer : IRenderer;
    
    public var scaleMode : String;
    public var width : Int;  // FIXME: ro
    public var height : Int; // FIXME: ro
    
    public function new( r:IRenderer, w:Int, h:Int ) {
        super();
        stage = this;
        root = this;
        renderer = r;
        scaleMode = StageScaleMode.NO_SCALE;
        width=w;
        height=h;
        r._objectChanged(this);
    }
        
    public function _resize( w:Int, h:Int ) {
        var x:Float = 1.0;
        var y:Float = 1.0;
        
        if( scaleMode == StageScaleMode.NO_SCALE ) {
            x = y = 1.0;
            trace("Stage Scale event should trigger, FIXME");
        } else if( scaleMode == StageScaleMode.EXACT_FIT ) {
            x = (w/width);
            y = (h/height);
        } else if( scaleMode == StageScaleMode.NO_BORDER ) {
            x = y = Math.max( w/width, h/height );
        } else if( scaleMode == StageScaleMode.SHOW_ALL ) {
            x = y = Math.min( w/width, h/height );
        } else {
            trace("unknown StageScaleMode '"+scaleMode+"'");
        }
        
        transform.matrix.setIdentity();
        transform.matrix.translate( -1, 1 );
        transform.matrix.scale( (2.0/w)*x, (-2.0/h)*y );
        changed(); // TODO: Graphics / Transform should do that?
    }
    
    public function _objectChanged( obj:DisplayObject ) :Void {
        renderer._objectChanged( obj );
    }
}
