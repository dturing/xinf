package org.xinf.media;

import org.xinf.display.InteractiveObject;
import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import GL;

class Video extends InteractiveObject {
    private static var highestTextureID:Int=0;
    private static function genTextures( n:Int ) {
        var a = new Array<Int>();
        var t0 = highestTextureID;
        highestTextureID += n;
        
        for( i in t0...highestTextureID ) {
            a.push(i);
        }
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
        _pipeline = new gst.Pipeline(
//            "   filesrc location=/beta/video/foreign/success_v2.mpg  ! decodebin 
            "   videotestsrc 
                ! video/x-raw-rgb, depth=24, bpp=32
                ! fixedalpha alpha=255
                ! identity name=handoff 
                ! fakesink
            ","handoff");
            
        if( _pipeline == null ) throw("gst.Pipeline construction failed");
        _textures = genTextures(1);
        
        twidth=theight=0;
    }

    private function _render( r:IRenderer ) : Void {
        var buf:gst.Buffer = _pipeline.frame();
        var d:Dynamic = buf.analyze();
        
        if( d.width > twidth || d.height > theight ) {
            twidth = 64; while( twidth<d.width ) twidth<<=1;
            theight = 64; while( theight<d.height ) theight<<=1;
         
            // FIXME: delete old textures
            for( i in 0..._textures.length ) {
                GL.CreateTexture( i, twidth, theight );
            }
        }
        
        var id:Int = _textures[0];
        GL.__glTexSubImage2D( id, new Point(0,0), new Point(d.width,d.height), d.data );
        
        _renderSub( r, id, new Point(twidth, theight), new Point(d.width, d.height) );
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
        
        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, _textures[0] );
//        trace( "video frame tex#"+texId+" "+he+","+ve+" "+hf+","+vf+" "+texDim+" "+imgDim );
        
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
        
        GL.Disable( GL.TEXTURE_2D );
        
        GL.PopMatrix();
    }
    
}
