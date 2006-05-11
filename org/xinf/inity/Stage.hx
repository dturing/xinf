package org.xinf.inity;

class Stage extends Group {
    public static var EXACT_FIT:String = "exactFit";
    public static var NO_BORDER:String = "noBorder";
    public static var NO_SCALE:String = "noScale";
    public static var SHOW_ALL:String = "showAll";
    public var scaleMode : String;
    
    private var definedWidth:Float;
    private var definedHeight:Float;
    private var width:Float;
    private var height:Float;

    public function new( w:Int, h:Int ) :Void {
        super();
        scaleMode = NO_SCALE;
        width=w; height=h;
        definedWidth=w; definedHeight=h;
    }

    public function resize( w:Int, h:Int ) :Void {
        var x:Float = 1.0;
        var y:Float = 1.0;
        
        if( scaleMode == NO_SCALE ) {
            x = y = 1.0;
            trace("Stage Scale event should trigger, FIXME");
        } else if( scaleMode == EXACT_FIT ) {
            x = (w/definedWidth);
            y = (h/definedHeight);
        } else if( scaleMode == NO_BORDER ) {
            x = y = Math.max( w/definedWidth, h/definedHeight );
        } else if( scaleMode == SHOW_ALL ) {
            x = y = Math.min( w/definedWidth, h/definedHeight );
        } else {
            trace("unknown StageScaleMode '"+scaleMode+"'");
        }
        
        transform.setIdentity();
        transform.translate( -1, 1 );
        transform.scale( (2.0/w)*x, (-2.0/h)*y );
        style.x = -1 + (.5/w);
        style.y =  1 + (-.5/h);

        width=w; height=h;
 //       trace("stage resize: "+width+","+height+" def "+definedWidth+","+definedHeight );
 //       trace(scaleMode+" - "+x+","+y );
    }
}
