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

package xinf.inity;

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
    private var x:Float;
    private var y:Float;

    public function new( w:Int, h:Int ) :Void {
        super();
        scaleMode = NO_SCALE;
        width=w; height=h;
        x=y=0;
        definedWidth=w; definedHeight=h;
    }

    public function resize( w:Int, h:Int ) :Void {
        var x:Float = 1.0;
        var y:Float = 1.0;

        if( scaleMode == NO_SCALE ) {
            x = y = 1.0;
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
        this.x = -1 + (.5/w);
        this.y = 1 + (-.5/h);

        width=w; height=h;
        
        xinf.event.Global.postEvent( 
			new xinf.ony.GeometryEvent( xinf.ony.GeometryEvent.STAGE_SCALED, 
				owner, width, height ) );
 //       trace("stage resize: "+width+","+height+" def "+definedWidth+","+definedHeight );
 //       trace(scaleMode+" - "+x+","+y );
    }

    override public function _cache() :Void {
        /*
            FIXME_ this is ugly, combi of Group::_cache and Object::_cache,
            for the sole purpose of using x/y instead of bounds.x/y
        */
    
        for( child in children ) {
            child._cache();
        }
        if( _changed ) {
            if( bounds.x != null && bounds.y != null ) { // FIXME. maybe do this somewhere else?
                transform.tx = x;
                transform.ty = y;
            }
        
            if( _displayList == null ) {
                _displayList = GL.GenLists(1);
            }
            GL.NewList( _displayList, GL.COMPILE );
            GL.PushMatrix();
                GL.MultMatrixf( transform._v );
                _render();
            GL.PopMatrix();
            GL.EndList();
            
            // cache simplified (maybe not do this if they are the same? FIXME)
            if( _displayListSimple == null ) {
                _displayListSimple = GL.GenLists(1);
            }
            GL.NewList( _displayListSimple, GL.COMPILE );
            GL.PushMatrix();
                GL.MultMatrixf( transform._v );
                _renderSimple();
            GL.PopMatrix();
            GL.EndList();
            
            _changed = false;
        }
    }
}
