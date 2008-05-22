/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package openvg;

/**
	Global OpenVG functions. 
	Make sure you create (and makeCurrent) a Display before using any of these.
	
	<nekobind 
		prefix="vg"
		module="openvg"
		global="true"
		translator="Capitalize"
		globalFinderPrefix="VG_"
		globalFinderCCFlags="-lOpenVG -lGL -lGLU"
		
		friends="openvg.Handle:VGHandle>__h,
				openvg.Path:VGPath>__h,
				openvg.Paint:VGPaint>__h"
		/>
	<nekobind:cHeader>
		#include &lt;vg/openvg.h&gt;
	</nekobind:cHeader>
**/

extern class VG {

	public static var NO_ERROR:Int;
	public static var BAD_HANDLE_ERROR:Int;
	public static var ILLEGAL_ARGUMENT_ERROR:Int;
	public static var OUT_OF_MEMORY_ERROR:Int;
	public static var PATH_CAPABILITY_ERROR:Int;
	public static var UNSUPPORTED_IMAGE_FORMAT_ERROR:Int;
	public static var UNSUPPORTED_PATH_FORMAT_ERROR:Int;
	public static var IMAGE_IN_USE_ERROR:Int;
	public static var NO_CONTEXT_ERROR:Int;
	public static var MATRIX_MODE:Int;
	public static var FILL_RULE:Int;
	public static var IMAGE_QUALITY:Int;
	public static var RENDERING_QUALITY:Int;
	public static var BLEND_MODE:Int;
	public static var IMAGE_MODE:Int;
	public static var SCISSOR_RECTS:Int;
	public static var STROKE_LINE_WIDTH:Int;
	public static var STROKE_CAP_STYLE:Int;
	public static var STROKE_JOIN_STYLE:Int;
	public static var STROKE_MITER_LIMIT:Int;
	public static var STROKE_DASH_PATTERN:Int;
	public static var STROKE_DASH_PHASE:Int;
	public static var STROKE_DASH_PHASE_RESET:Int;
	public static var TILE_FILL_COLOR:Int;
	public static var CLEAR_COLOR:Int;
	public static var MASKING:Int;
	public static var SCISSORING:Int;
	public static var PIXEL_LAYOUT:Int;
	public static var SCREEN_LAYOUT:Int;
	public static var FILTER_FORMAT_LINEAR:Int;
	public static var FILTER_FORMAT_PREMULTIPLIED:Int;
	public static var FILTER_CHANNEL_MASK:Int;
	public static var MAX_SCISSOR_RECTS:Int;
	public static var MAX_DASH_COUNT:Int;
	public static var MAX_KERNEL_SIZE:Int;
	public static var MAX_SEPARABLE_KERNEL_SIZE:Int;
	public static var MAX_COLOR_RAMP_STOPS:Int;
	public static var MAX_IMAGE_WIDTH:Int;
	public static var MAX_IMAGE_HEIGHT:Int;
	public static var MAX_IMAGE_PIXELS:Int;
	public static var MAX_IMAGE_BYTES:Int;
	public static var MAX_FLOAT:Int;
	public static var MAX_GAUSSIAN_STD_DEVIATION:Int;
	public static var RENDERING_QUALITY_NONANTIALIASED:Int;
	public static var RENDERING_QUALITY_FASTER:Int;
	public static var RENDERING_QUALITY_BETTER:Int;
	public static var PIXEL_LAYOUT_UNKNOWN:Int;
	public static var PIXEL_LAYOUT_RGB_VERTICAL:Int;
	public static var PIXEL_LAYOUT_BGR_VERTICAL:Int;
	public static var PIXEL_LAYOUT_RGB_HORIZONTAL:Int;
	public static var PIXEL_LAYOUT_BGR_HORIZONTAL:Int;
	public static var MATRIX_PATH_USER_TO_SURFACE:Int;
	public static var MATRIX_IMAGE_USER_TO_SURFACE:Int;
	public static var MATRIX_STROKE_PAINT_TO_USER:Int;
	public static var MATRIX_FILL_PAINT_TO_USER:Int;
	public static var CLEAR_MASK:Int;
	public static var FILL_MASK:Int;
	public static var SET_MASK:Int;
	public static var UNION_MASK:Int;
	public static var INTERSECT_MASK:Int;
	public static var SUBTRACT_MASK:Int;
	public static var PATH_DATATYPE_S_8:Int;
	public static var PATH_DATATYPE_S_16:Int;
	public static var PATH_DATATYPE_S_32:Int;
	public static var PATH_DATATYPE_F:Int;
	public static var ABSOLUTE:Int;
	public static var RELATIVE:Int;
	public static var CLOSE_PATH:Int;
	public static var MOVE_TO:Int;
	public static var LINE_TO:Int;
	public static var HLINE_TO:Int;
	public static var VLINE_TO:Int;
	public static var QUAD_TO:Int;
	public static var CUBIC_TO:Int;
	public static var SQUAD_TO:Int;
	public static var SCUBIC_TO:Int;
	public static var SCCWARC_TO:Int;
	public static var SCWARC_TO:Int;
	public static var LCCWARC_TO:Int;
	public static var LCWARC_TO:Int;
	public static var MOVE_TO_ABS:Int;
	public static var MOVE_TO_REL:Int;
	public static var LINE_TO_ABS:Int;
	public static var LINE_TO_REL:Int;
	public static var HLINE_TO_ABS:Int;
	public static var HLINE_TO_REL:Int;
	public static var VLINE_TO_ABS:Int;
	public static var VLINE_TO_REL:Int;
	public static var QUAD_TO_ABS:Int;
	public static var QUAD_TO_REL:Int;
	public static var CUBIC_TO_ABS:Int;
	public static var CUBIC_TO_REL:Int;
	public static var SQUAD_TO_ABS:Int;
	public static var SQUAD_TO_REL:Int;
	public static var SCUBIC_TO_ABS:Int;
	public static var SCUBIC_TO_REL:Int;
	public static var SCCWARC_TO_ABS:Int;
	public static var SCCWARC_TO_REL:Int;
	public static var SCWARC_TO_ABS:Int;
	public static var SCWARC_TO_REL:Int;
	public static var LCCWARC_TO_ABS:Int;
	public static var LCCWARC_TO_REL:Int;
	public static var LCWARC_TO_ABS:Int;
	public static var LCWARC_TO_REL:Int;
	public static var PATH_CAPABILITY_APPEND_FROM:Int;
	public static var PATH_CAPABILITY_APPEND_TO:Int;
	public static var PATH_CAPABILITY_MODIFY:Int;
	public static var PATH_CAPABILITY_TRANSFORM_FROM:Int;
	public static var PATH_CAPABILITY_TRANSFORM_TO:Int;
	public static var PATH_CAPABILITY_INTERPOLATE_FROM:Int;
	public static var PATH_CAPABILITY_INTERPOLATE_TO:Int;
	public static var PATH_CAPABILITY_PATH_LENGTH:Int;
	public static var PATH_CAPABILITY_POINT_ALONG_PATH:Int;
	public static var PATH_CAPABILITY_TANGENT_ALONG_PATH:Int;
	public static var PATH_CAPABILITY_PATH_BOUNDS:Int;
	public static var PATH_CAPABILITY_PATH_TRANSFORMED_BOUNDS:Int;
	public static var PATH_CAPABILITY_ALL:Int;
	public static var PATH_FORMAT:Int;
	public static var PATH_DATATYPE:Int;
	public static var PATH_SCALE:Int;
	public static var PATH_BIAS:Int;
	public static var PATH_NUM_SEGMENTS:Int;
	public static var PATH_NUM_COORDS:Int;
	public static var CAP_BUTT:Int;
	public static var CAP_ROUND:Int;
	public static var CAP_SQUARE:Int;
	public static var JOIN_MITER:Int;
	public static var JOIN_ROUND:Int;
	public static var JOIN_BEVEL:Int;
	public static var EVEN_ODD:Int;
	public static var NON_ZERO:Int;
	public static var STROKE_PATH:Int;
	public static var FILL_PATH:Int;
	public static var PAINT_TYPE:Int;
	public static var PAINT_COLOR:Int;
	public static var PAINT_COLOR_RAMP_SPREAD_MODE:Int;
	public static var PAINT_COLOR_RAMP_PREMULTIPLIED:Int;
	public static var PAINT_COLOR_RAMP_STOPS:Int;
	public static var PAINT_LINEAR_GRADIENT:Int;
	public static var PAINT_RADIAL_GRADIENT:Int;
	public static var PAINT_PATTERN_TILING_MODE:Int;
	public static var PAINT_TYPE_COLOR:Int;
	public static var PAINT_TYPE_LINEAR_GRADIENT:Int;
	public static var PAINT_TYPE_RADIAL_GRADIENT:Int;
	public static var PAINT_TYPE_PATTERN:Int;
	public static var COLOR_RAMP_SPREAD_PAD:Int;
	public static var COLOR_RAMP_SPREAD_REPEAT:Int;
	public static var COLOR_RAMP_SPREAD_REFLECT:Int;
	public static var TILE_FILL:Int;
	public static var TILE_PAD:Int;
	public static var TILE_REPEAT:Int;
	public static var TILE_REFLECT:Int;
	public static var sRGBX_8888:Int;
	public static var sRGBA_8888:Int;
	public static var sRGBA_8888_PRE:Int;
	public static var sRGB_565:Int;
	public static var sRGBA_5551:Int;
	public static var sRGBA_4444:Int;
	public static var sL_8:Int;
	public static var lRGBX_8888:Int;
	public static var lRGBA_8888:Int;
	public static var lRGBA_8888_PRE:Int;
	public static var lL_8:Int;
	public static var A_8:Int;
	public static var BW_1:Int;
	public static var sXRGB_8888:Int;
	public static var sARGB_8888:Int;
	public static var sARGB_8888_PRE:Int;
	public static var sARGB_1555:Int;
	public static var sARGB_4444:Int;
	public static var lXRGB_8888:Int;
	public static var lARGB_8888:Int;
	public static var lARGB_8888_PRE:Int;
	public static var sBGRX_8888:Int;
	public static var sBGRA_8888:Int;
	public static var sBGRA_8888_PRE:Int;
	public static var sBGR_565:Int;
	public static var sBGRA_5551:Int;
	public static var sBGRA_4444:Int;
	public static var lBGRX_8888:Int;
	public static var lBGRA_8888:Int;
	public static var lBGRA_8888_PRE:Int;
	public static var sXBGR_8888:Int;
	public static var sABGR_8888:Int;
	public static var sABGR_8888_PRE:Int;
	public static var sABGR_1555:Int;
	public static var sABGR_4444:Int;
	public static var lXBGR_8888:Int;
	public static var lABGR_8888:Int;
	public static var lABGR_8888_PRE:Int;
	public static var IMAGE_QUALITY_NONANTIALIASED:Int;
	public static var IMAGE_QUALITY_FASTER:Int;
	public static var IMAGE_QUALITY_BETTER:Int;
	public static var IMAGE_FORMAT:Int;
	public static var IMAGE_WIDTH:Int;
	public static var IMAGE_HEIGHT:Int;
	public static var DRAW_IMAGE_NORMAL:Int;
	public static var DRAW_IMAGE_MULTIPLY:Int;
	public static var DRAW_IMAGE_STENCIL:Int;
	public static var RED:Int;
	public static var GREEN:Int;
	public static var BLUE:Int;
	public static var ALPHA:Int;
	public static var BLEND_SRC:Int;
	public static var BLEND_SRC_OVER:Int;
	public static var BLEND_DST_OVER:Int;
	public static var BLEND_SRC_IN:Int;
	public static var BLEND_DST_IN:Int;
	public static var BLEND_MULTIPLY:Int;
	public static var BLEND_SCREEN:Int;
	public static var BLEND_DARKEN:Int;
	public static var BLEND_LIGHTEN:Int;
	public static var BLEND_ADDITIVE:Int;
	public static var BLEND_SRC_OUT_SH:Int;
	public static var BLEND_DST_OUT_SH:Int;
	public static var BLEND_SRC_ATOP_SH:Int;
	public static var BLEND_DST_ATOP_SH:Int;
	public static var IMAGE_FORMAT_QUERY:Int;
	public static var PATH_DATATYPE_QUERY:Int;
	public static var HARDWARE_ACCELERATED:Int;
	public static var HARDWARE_UNACCELERATED:Int;
	public static var VENDOR:Int;
	public static var RENDERER:Int;
	public static var VERSION:Int;
	public static var EXTENSIONS:Int;

	public static var PATH_FORMAT_STANDARD:Int;

	public static function getError() :Int;
	public static function flush() :Void;
	public static function finish() :Void;
	

/* Getters and Setters */

	public static function setf( type:Int, value:Float ) :Void;
	public static function seti( type:Int, value:Int ) :Void;
	/** <nekobind><cptr name="values" type="float" min-size="count"/></nekobind> **/
	public static function setfv( type:Int, count:Int, values:String ) :Void;
	/** <nekobind><cptr name="values" type="int" min-size="count"/></nekobind> **/
	public static function setiv( type:Int, count:Int, values:String ) :Void;
	public static function getf( type:Int ) :Float;
	public static function geti( type:Int ) :Int;
	public static function getVectorSize( type:Int ) :Int;
	/** <nekobind><cptr name="values" type="float" min-size="count"/></nekobind> **/
	public static function getfv( type:Int, count:Int, values:String ) :Void;
	/** <nekobind><cptr name="values" type="int" min-size="count"/></nekobind> **/
	public static function getiv( type:Int, count:Int, values:String ) :Void;
	
	public static function getParameterf( object:Handle, type:Int ) :Float;
	public static function getParameteri( object:Handle, type:Int ) :Int;
	public static function getParameterVectorSize( object:Handle, type:Int ) :Int;
	/** <nekobind><cptr name="values" type="float" min-size="count"/></nekobind> **/
	public static function getParameterfv( object:Handle, type:Int, count:Int, values:String ) :Void;
	/** <nekobind><cptr name="values" type="int" min-size="count"/></nekobind> **/
	public static function getParameteriv( object:Handle, type:Int, count:Int, values:String ) :Void;

/* Matrix Manipulation */
	public static function loadIdentity() :Void;
	/** <nekobind><cptr name="m" type="float" min-size="9"/></nekobind> **/
	public static function loadMatrix( m:String ) :Void;
	/** <nekobind><cptr name="m" type="float" min-size="9"/></nekobind> **/
	public static function getMatrix( m:String ) :Void;
	/** <nekobind><cptr name="m" type="float" min-size="9"/></nekobind> **/
	public static function multMatrix( m:String ) :Void;
	public static function translate( tx:Float, ty:Float ) :Void;
	public static function scale( sx:Float, sy:Float ) :Void;
	public static function shear( shx:Float, shy:Float ) :Void;
	public static function rotate( angle:Float ) :Void;
	
/* Masking and Clearing */
	// NYI public static function mask( mask:Int, operation:Int, x:Int, y:Int, width:Int, height:Int ) :Void;
	public static function clear( x:Int, y:Int, width:Int, height:Int ) :Void;

/* Images */
	public static function createImage( format:Int, width:Int, height:Int, quality:Int ) :Int;
	public static function destroyImage( image:Int ) :Void;
	public static function clearImage( image:Int, x:Int, y:Int, width:Int, height:Int ) :Void;
	/** <nekobind><cptr name="data" type="int" min-size="0"/></nekobind> **/
	public static function imageSubData( image:Int, data:String, stride:Int, format:Int, x:Int, y:Int, width:Int, height:Int ) :Void;
	/** <nekobind><cptr name="data" type="int" min-size="0"/></nekobind> **/
	public static function getImageSubData( image:Int, data:String, stride:Int, format:Int, x:Int, y:Int, width:Int, height:Int ) :Void;
	// NYI public static function childImage( image:Int, x:Int, y:Int, width:Int, height:Int ) :Int;
	// NYI public static function getParent( image:Int ) :Int;
	public static function copyImage( dst:Int, dx:Int, dy:Int, src:Int, sx:Int, sy:Int, width:Int, height:Int, dither:Bool ) :Void;
	public static function drawImage( image:Int ) :Void;
	public static function setPixels( dx:Int, dy:Int, src:Int, sx:Int, sy:Int, width:Int, height:Int ) :Void;
	/** <nekobind><cptr name="data" type="int" min-size="0"/></nekobind> **/
	public static function writePixels( data:String, stride:Int, format:Int, dx:Int, dy:Int, width:Int, height:Int ) :Void;
	public static function getPixels( dst:Int, dx:Int, dy:Int, sx:Int, sy:Int, width:Int, height:Int ) :Void;
	/** <nekobind><cptr name="data" type="int" min-size="0"/></nekobind> **/
	public static function readPixels( data:String, stride:Int, format:Int, sx:Int, sy:Int, width:Int, height:Int ) :Void;
	public static function copyPixels( dx:Int, dy:Int, sx:Int, sy:Int, width:Int, height:Int ) :Void;

/* Image Filters 
	public static function colorMatrix(VGImage :Void;
	public static function convolve(VGImage :Void;
	public static function separableConvolve(VGImage :Void;
	public static function gaussianBlur(VGImage :Void;
	public static function lookup(VGImage :Void;
	public static function lookupSingle(VGImage :Void;
*/

/* Hardware Queries */
	// NYI public static function hardwareQuery( type:Int, setting:Int ) :Int;
	
/* Renderer and Extension Information */
/*VG_API_CALL const VGubyte * vgGetString(VGStringID name);*/

/* Extensions */
	public static function createContextSH( width:Int, height:Int ) :Bool;
	public static function resizeSurfaceSH( width:Int, height:Int ) :Void;
	public static function destroyContextSH() :Void;


	public static function __init__() : Void {
		DLLLoader.addLibToPath("openvg");
		untyped {
			var loader = untyped __dollar__loader;
			VG = loader.loadmodule("openvg".__s,loader).VG__impl;
		}
	}
}
