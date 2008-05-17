package opengl;

/**
    Global OpenGL libGLU functions. 
    
    <nekobind 
        prefix="glu"
        module="opengl"
        global="true"
        translator="Capitalize"
        globalFinderPrefix="GLU_"
        globalFinderCCFlags="-lGL -lGLU"
        />
    <nekobind:cHeader>
    #ifdef NEKO_OSX
        #include &lt;OpenGL/gl.h&gt;
        #include &lt;OpenGL/glu.h&gt;
    #else
        #include &lt;GL/gl.h&gt;
        #include &lt;GL/glu.h&gt;
    #endif
    </nekobind:cHeader>
**/

extern class GLU {
/*
    public static var EXT_object_space_tess:Int;
    public static var EXT_nurbs_tessellator:Int;
    public static var FALSE:Int;
    public static var TRUE:Int;
    public static var VERSION_1_1:Int;
    public static var VERSION_1_2:Int;
    public static var VERSION_1_3:Int;
    public static var VERSION:Int;
    public static var EXTENSIONS:Int;
    public static var INVALID_ENUM:Int;
    public static var INVALID_VALUE:Int;
    public static var OUT_OF_MEMORY:Int;
    public static var INVALID_OPERATION:Int;
    public static var OUTLINE_POLYGON:Int;
    public static var OUTLINE_PATCH:Int;
    public static var NURBS_ERROR:Int;
    public static var ERROR:Int;
    public static var NURBS_BEGIN:Int;
    public static var NURBS_BEGIN_EXT:Int;
    public static var NURBS_VERTEX:Int;
    public static var NURBS_VERTEX_EXT:Int;
    public static var NURBS_NORMAL:Int;
    public static var NURBS_NORMAL_EXT:Int;
    public static var NURBS_COLOR:Int;
    public static var NURBS_COLOR_EXT:Int;
    public static var NURBS_TEXTURE_COORD:Int;
    public static var NURBS_TEX_COORD_EXT:Int;
    public static var NURBS_END:Int;
    public static var NURBS_END_EXT:Int;
    public static var NURBS_BEGIN_DATA:Int;
    public static var NURBS_BEGIN_DATA_EXT:Int;
    public static var NURBS_VERTEX_DATA:Int;
    public static var NURBS_VERTEX_DATA_EXT:Int;
    public static var NURBS_NORMAL_DATA:Int;
    public static var NURBS_NORMAL_DATA_EXT:Int;
    public static var NURBS_COLOR_DATA:Int;
    public static var NURBS_COLOR_DATA_EXT:Int;
    public static var NURBS_TEXTURE_COORD_DATA:Int;
    public static var NURBS_TEX_COORD_DATA_EXT:Int;
    public static var NURBS_END_DATA:Int;
    public static var NURBS_END_DATA_EXT:Int;
    public static var NURBS_ERROR1:Int;
    public static var NURBS_ERROR2:Int;
    public static var NURBS_ERROR3:Int;
    public static var NURBS_ERROR4:Int;
    public static var NURBS_ERROR5:Int;
    public static var NURBS_ERROR6:Int;
    public static var NURBS_ERROR7:Int;
    public static var NURBS_ERROR8:Int;
    public static var NURBS_ERROR9:Int;
    public static var NURBS_ERROR10:Int;
    public static var NURBS_ERROR11:Int;
    public static var NURBS_ERROR12:Int;
    public static var NURBS_ERROR13:Int;
    public static var NURBS_ERROR14:Int;
    public static var NURBS_ERROR15:Int;
    public static var NURBS_ERROR16:Int;
    public static var NURBS_ERROR17:Int;
    public static var NURBS_ERROR18:Int;
    public static var NURBS_ERROR19:Int;
    public static var NURBS_ERROR20:Int;
    public static var NURBS_ERROR21:Int;
    public static var NURBS_ERROR22:Int;
    public static var NURBS_ERROR23:Int;
    public static var NURBS_ERROR24:Int;
    public static var NURBS_ERROR25:Int;
    public static var NURBS_ERROR26:Int;
    public static var NURBS_ERROR27:Int;
    public static var NURBS_ERROR28:Int;
    public static var NURBS_ERROR29:Int;
    public static var NURBS_ERROR30:Int;
    public static var NURBS_ERROR31:Int;
    public static var NURBS_ERROR32:Int;
    public static var NURBS_ERROR33:Int;
    public static var NURBS_ERROR34:Int;
    public static var NURBS_ERROR35:Int;
    public static var NURBS_ERROR36:Int;
    public static var NURBS_ERROR37:Int;
    public static var AUTO_LOAD_MATRIX:Int;
    public static var CULLING:Int;
    public static var SAMPLING_TOLERANCE:Int;
    public static var DISPLAY_MODE:Int;
    public static var PARAMETRIC_TOLERANCE:Int;
    public static var SAMPLING_METHOD:Int;
    public static var U_STEP:Int;
    public static var V_STEP:Int;
    public static var NURBS_MODE:Int;
    public static var NURBS_MODE_EXT:Int;
    public static var NURBS_TESSELLATOR:Int;
    public static var NURBS_TESSELLATOR_EXT:Int;
    public static var NURBS_RENDERER:Int;
    public static var NURBS_RENDERER_EXT:Int;
    public static var OBJECT_PARAMETRIC_ERROR:Int;
    public static var OBJECT_PARAMETRIC_ERROR_EXT:Int;
    public static var OBJECT_PATH_LENGTH:Int;
    public static var OBJECT_PATH_LENGTH_EXT:Int;
    public static var PATH_LENGTH:Int;
    public static var PARAMETRIC_ERROR:Int;
    public static var DOMAIN_DISTANCE:Int;
    public static var MAP1_TRIM_2:Int;
    public static var MAP1_TRIM_3:Int;
    public static var POINT:Int;
    public static var LINE:Int;
    public static var FILL:Int;
    public static var SILHOUETTE:Int;
    public static var SMOOTH:Int;
    public static var FLAT:Int;
    public static var NONE:Int;
    public static var OUTSIDE:Int;
    public static var INSIDE:Int;
    public static var TESS_BEGIN:Int;
    public static var BEGIN:Int;
    public static var TESS_VERTEX:Int;
    public static var VERTEX:Int;
    public static var TESS_END:Int;
    public static var END:Int;
    public static var TESS_ERROR:Int;
    public static var TESS_EDGE_FLAG:Int;
    public static var EDGE_FLAG:Int;
    public static var TESS_COMBINE:Int;
    public static var TESS_BEGIN_DATA:Int;
    public static var TESS_VERTEX_DATA:Int;
    public static var TESS_END_DATA:Int;
    public static var TESS_ERROR_DATA:Int;
    public static var TESS_EDGE_FLAG_DATA:Int;
    public static var TESS_COMBINE_DATA:Int;
    public static var CW:Int;
    public static var CCW:Int;
    public static var INTERIOR:Int;
    public static var EXTERIOR:Int;
    public static var UNKNOWN:Int;
    public static var TESS_WINDING_RULE:Int;
    public static var TESS_BOUNDARY_ONLY:Int;
    public static var TESS_TOLERANCE:Int;
    public static var TESS_ERROR1:Int;
    public static var TESS_ERROR2:Int;
    public static var TESS_ERROR3:Int;
    public static var TESS_ERROR4:Int;
    public static var TESS_ERROR5:Int;
    public static var TESS_ERROR6:Int;
    public static var TESS_ERROR7:Int;
    public static var TESS_ERROR8:Int;
    public static var TESS_MISSING_BEGIN_POLYGON:Int;
    public static var TESS_MISSING_BEGIN_CONTOUR:Int;
    public static var TESS_MISSING_END_POLYGON:Int;
    public static var TESS_MISSING_END_CONTOUR:Int;
    public static var TESS_COORD_TOO_LARGE:Int;
    public static var TESS_NEED_COMBINE_CALLBACK:Int;
    public static var TESS_WINDING_ODD:Int;
    public static var TESS_WINDING_NONZERO:Int;
    public static var TESS_WINDING_POSITIVE:Int;
    public static var TESS_WINDING_NEGATIVE:Int;
    public static var TESS_WINDING_ABS_GEQ_TWO:Int;
    public static var TESS_MAX_COORD:Float;
    public static function BeginCurve( nurb:Dynamic ):Void;
    public static function BeginPolygon( tess:Dynamic ):Void;
    public static function BeginSurface( nurb:Dynamic ):Void;
    public static function BeginTrim( nurb:Dynamic ):Void;
    public static function Build1DMipmapLevels( target:Int, internalFormat:Int, width:Int, format:Int, type:Int, level:Int, base:Int, max:Int, data:Void ):Int;
    public static function Build1DMipmaps( target:Int, internalFormat:Int, width:Int, format:Int, type:Int, data:Void ):Int;
    public static function Build2DMipmapLevels( target:Int, internalFormat:Int, width:Int, height:Int, format:Int, type:Int, level:Int, base:Int, max:Int, data:Void ):Int;
    public static function Build2DMipmaps( target:Int, internalFormat:Int, width:Int, height:Int, format:Int, type:Int, data:Void ):Int;
    public static function Build3DMipmapLevels( target:Int, internalFormat:Int, width:Int, height:Int, depth:Int, format:Int, type:Int, level:Int, base:Int, max:Int, data:Void ):Int;
    public static function Build3DMipmaps( target:Int, internalFormat:Int, width:Int, height:Int, depth:Int, format:Int, type:Int, data:Void ):Int;
    public static function CheckExtension( extName:String, extString:String ):Int;
    public static function Cylinder( quad:Dynamic, base:Float, top:Float, height:Float, slices:Int, stacks:Int ):Void;
    public static function DeleteNurbsRenderer( nurb:Dynamic ):Void;
    public static function DeleteQuadric( quad:Dynamic ):Void;
    public static function DeleteTess( tess:Dynamic ):Void;
    public static function Disk( quad:Dynamic, inner:Float, outer:Float, slices:Int, loops:Int ):Void;
    public static function EndCurve( nurb:Dynamic ):Void;
    public static function EndPolygon( tess:Dynamic ):Void;
    public static function EndSurface( nurb:Dynamic ):Void;
    public static function EndTrim( nurb:Dynamic ):Void;
    public static function GetNurbsProperty( nurb:Dynamic, property:Int, data:Float ):Void;
    public static function GetString( name:Int ):String;
    public static function GetTessProperty( tess:Dynamic, which:Int, data:Float ):Void;
    public static function LoadSamplingMatrices( nurb:Dynamic, model:Float, perspective:Float, view:Int ):Void;
    public static function NewNurbsRenderer( ):Dynamic;
    public static function NewQuadric( ):Dynamic;
    public static function NewTess( ):Dynamic;
    public static function NextContour( tess:Dynamic, type:Int ):Void;
    public static function NurbsCallback( nurb:Dynamic, which:Int, CallBackFunc:Dynamic ):Void;
    public static function NurbsCallbackData( nurb:Dynamic, userData:Void ):Void;
    public static function NurbsCallbackDataEXT( nurb:Dynamic, userData:Void ):Void;
    public static function NurbsCurve( nurb:Dynamic, knotCount:Int, knots:Float, stride:Int, control:Float, order:Int, type:Int ):Void;
    public static function NurbsProperty( nurb:Dynamic, property:Int, value:Float ):Void;
    public static function NurbsSurface( nurb:Dynamic, sKnotCount:Int, sKnots:Float, tKnotCount:Int, tKnots:Float, sStride:Int, tStride:Int, control:Float, sOrder:Int, tOrder:Int, type:Int ):Void;
    public static function PartialDisk( quad:Dynamic, inner:Float, outer:Float, slices:Int, loops:Int, start:Float, sweep:Float ):Void;
    // Perspective
    public static function Project( objX:Float, objY:Float, objZ:Float, model:Float, proj:Float, view:Int, winX:Float, winY:Float, winZ:Float ):Int;
    public static function PwlCurve( nurb:Dynamic, count:Int, data:Float, stride:Int, type:Int ):Void;
    public static function QuadricCallback( quad:Dynamic, which:Int, CallBackFunc:Dynamic ):Void;
    public static function QuadricDrawStyle( quad:Dynamic, draw:Int ):Void;
    public static function QuadricNormals( quad:Dynamic, normal:Int ):Void;
    public static function QuadricOrientation( quad:Dynamic, orientation:Int ):Void;
    public static function QuadricTexture( quad:Dynamic, texture:Int ):Void;
    public static function ScaleImage( format:Int, wIn:Int, hIn:Int, typeIn:Int, dataIn:Void, wOut:Int, hOut:Int, typeOut:Int, dataOut:Void ):Int;
    public static function Sphere( quad:Dynamic, radius:Float, slices:Int, stacks:Int ):Void;
    public static function UnProject( winX:Float, winY:Float, winZ:Float, model:Float, proj:Float, view:Int, objX:Float, objY:Float, objZ:Float ):Int;
    public static function UnProject4( winX:Float, winY:Float, winZ:Float, clipW:Float, model:Float, proj:Float, view:Int, near:Float, far:Float, objX:Float, objY:Float, objZ:Float, objW:Float ):Int;
    
    public static function TessBeginContour( tess:Dynamic ):Void;
    public static function TessBeginPolygon( tess:Dynamic, data:Void ):Void;
    public static function TessCallback( tess:Dynamic, which:Int, CallBackFunc:Dynamic ):Void;
    public static function TessEndContour( tess:Dynamic ):Void;
    public static function TessEndPolygon( tess:Dynamic ):Void;
    public static function TessNormal( tess:Dynamic, valueX:Float, valueY:Float, valueZ:Float ):Void;
    public static function TessProperty( tess:Dynamic, which:Int, data:Float ):Void;
    public static function TessVertex( tess:Dynamic, location:Float, data:Void ):Void;
    
    public static function SimpleTesselator( ):Dynamic;
    public static function TessVertexSimple( tess:Dynamic, v:Float ):Void;
    public static function TessVertexOffset( tess:Dynamic, v:Float, offset:Int ):Void;
    public static function TessCubicCurve( tess:Dynamic, ctrl:Dynamic, v:Float, n:Int ):Void;
    public static function TessQuadraticCurve( tess:Dynamic, _ctrl:Dynamic, v:Float, _n:Int ):Void;
    public static function VerticesOffset( v:Float, offset:Int, n:Int ):Void;
    public static function TesselatePath( tess:Dynamic, _points:Dynamic ):Void;
    public static function EvaluateCubicToArray( _ctrl:Dynamic, _n:Int ):Dynamic;
    public static function EvaluateQuadraticToArray( _ctrl:Dynamic, _n:Int ):Dynamic;
    public static function EvaluateCubicBezier( _ctrl:Dynamic, _n:Int, callback:Dynamic ):Dynamic;
    public static function EvaluateQuadraticBezier( _ctrl:Dynamic, _n:Int, callback:Dynamic ):Dynamic;
*/
    public static function perspective( fovy:Float, aspect:Float, zNear:Float, zFar:Float ):Void;

    /** <nekobind><cptr name="viewport" type="GLint" min-size="2"/></nekobind> **/
    public static function pickMatrix( x:Float, y:Float, delX:Float, delY:Float, viewport:Float ):Void;
    public static function errorString( error:Int ):String;
        
    public static function lookAt( eyeX:Float, eyeY:Float, eyeZ:Float, centerX:Float, centerY:Float, centerZ:Float, upX:Float, upY:Float, upZ:Float ):Void;
	public static function ortho2D( left:Float, right:Float, bottom:Float, top:Float ):Void;
        
/* additions */
    /** <nekobind><cptr name="v" type="double" min-size="(offset+(n*3))"/></nekobind> **/
    // public static function verticesOffset( offset:Int, n:Int, v:Dynamic  ) :Void;
    
    
    public static function __init__() : Void {
        DLLLoader.addLibToPath("opengl");
        untyped {
            var loader = untyped __dollar__loader;
            GLU = loader.loadmodule("opengl".__s,loader).GLU__impl;
        }
    }
}
