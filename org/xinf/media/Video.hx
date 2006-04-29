package org.xinf.media;

import org.xinf.display.InteractiveObject;
import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import org.xinf.util.CPtr;
import gst.Pipeline;

class Video extends InteractiveObject {
    
    private static function genTextures( n:Int ) {
        var t = CPtr.uint_alloc( n );
        GL.GenTextures( n, t );
        
        var r = CPtr.uint_to_array(t,0,n);
        var a = new Array();
        untyped a.__a = r;
        untyped a.length = n;
        return a;
    }

    private var textureOffset:Int;
    private var textures:Int;
    private var twidth:Int;
    private var theight:Int;

    private var _pipeline:gst.Pipeline;
    private var _textures:Array<Int>;


    public function new() {
        super();
        _textures = genTextures(1);
        twidth=theight=0;
    }
    
    public function start() {
        _pipeline = new gst.Pipeline(
//            "   filesrc location=/beta/video/foreign/success_v2.mpg  ! decodebin 
            "   videotestsrc 
                ! video/x-raw-rgb, depth=24, bpp=32, width=160, height=120
                ! fixedalpha alpha=255
                ! identity name=handoff 
                ! fakesink
            ","handoff");
            
        if( _pipeline == null ) throw("gst.Pipeline construction failed");
    }
    
    private function _render( r:IRenderer ) : Void {
        if( _pipeline == null ) return;
        var buf:gst.Buffer = _pipeline.frame();
        var d:Dynamic = buf.analyze();
        
        if( d.width > twidth || d.height > theight ) {
            twidth = 64; while( twidth<d.width ) twidth<<=1;
            theight = 64; while( theight<d.height ) theight<<=1;
         
            trace("Generating textures: "+_textures.length );
            // FIXME: delete old textures!
            for( i in 0..._textures.length ) {
               GL.BindTexture( GL.TEXTURE_2D, _textures[i] );
               GL._CreateTexture( _textures[i], twidth, theight );
            }
        }
        
        var id:Int = _textures[0];
        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, id );
        GL._TexSubImage2D_BGRA_BYTE( id, new Point(0,0), new Point(d.width,d.height), d.data );
        
        _renderSub( r, id, new Point(twidth, theight), new Point(d.width, d.height) );
        GL.Disable( GL.TEXTURE_2D );
    }
    
    private function _renderSub( r:IRenderer, texId:Int, texDim:Point, imgDim:Point ) {
        var w:Float = 1;
        var h:Float = 1;
        var rx:Float = 0;
        var ry:Float = 0;
        var rw:Float = 1;
        var rh:Float = 1;

        var he:Float = (rx/texDim.x) * imgDim.x;
        var ve:Float = (ry/texDim.y) * imgDim.y;
        var hf:Float = ( (rw+rx) / texDim.x ) * imgDim.x;
        var vf:Float = ( (rh+ry) / texDim.y ) * imgDim.y;
        
//        trace( "video frame tex#"+_textures[0]+" "+he+","+ve+" "+hf+","+vf+" "+texDim+" "+imgDim );
        
        GL.PushMatrix();
        
        GL.Color4f(1.,1.,1.,1.);
        GL.Translatef(-.5,-.5,.0);
        
        GL.Begin( GL.QUADS );
            GL.TexCoord2f( he, vf );
            GL.Vertex2f  (  0,  0 ); 
            GL.TexCoord2f( hf, vf );
            GL.Vertex2f  (  w,  0 ); 
            GL.TexCoord2f( hf, ve );
            GL.Vertex2f  (  w,  h ); 
            GL.TexCoord2f( he, ve );
            GL.Vertex2f  (  0,  h ); 
        GL.End();
        
        GL.PopMatrix();
    }
}
