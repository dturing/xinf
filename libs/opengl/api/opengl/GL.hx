/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package opengl;

/**
	Global OpenGL functions. 
	Make sure you create (and makeCurrent) a Display before using any of these.
	
	<nekobind 
		prefix="gl"
		module="opengl"
		global="true"
		translator="Capitalize"
		globalFinderPrefix="GL_"
		globalFinderCCFlags="-lGL"
		/>
	<nekobind:cHeader>
	#ifdef NEKO_OSX
		#include &lt;OpenGL/gl.h&gt;
	#else
		#include &lt;GL/gl.h&gt;
	#endif
	</nekobind:cHeader>
**/

extern class GL {
	/* basic values */
	public static var VERSION_1_1:Int;
	public static var VERSION_1_2:Int;
	public static var VERSION_1_3:Int;
//  public static var ARB_imaging:Int;
	public static var FALSE:Int;
	public static var TRUE:Int;
	public static var BYTE:Int;
	public static var UNSIGNED_BYTE:Int;
	public static var SHORT:Int;
	public static var UNSIGNED_SHORT:Int;
	public static var INT:Int;
	public static var UNSIGNED_INT:Int;
	public static var FLOAT:Int;
	public static var DOUBLE:Int;
	public static var POINTS:Int;
	public static var LINES:Int;
	public static var LINE_LOOP:Int;
	public static var LINE_STRIP:Int;
	public static var TRIANGLES:Int;
	public static var TRIANGLE_STRIP:Int;
	public static var TRIANGLE_FAN:Int;
	public static var QUADS:Int;
	public static var QUAD_STRIP:Int;
	public static var POLYGON:Int;
	public static var VERTEX_ARRAY:Int;
	public static var NORMAL_ARRAY:Int;
	public static var COLOR_ARRAY:Int;
	public static var INDEX_ARRAY:Int;
	public static var TEXTURE_COORD_ARRAY:Int;
	public static var EDGE_FLAG_ARRAY:Int;
	public static var VERTEX_ARRAY_SIZE:Int;
	public static var VERTEX_ARRAY_TYPE:Int;
	public static var VERTEX_ARRAY_STRIDE:Int;
	public static var NORMAL_ARRAY_TYPE:Int;
	public static var NORMAL_ARRAY_STRIDE:Int;
	public static var COLOR_ARRAY_SIZE:Int;
	public static var COLOR_ARRAY_TYPE:Int;
	public static var COLOR_ARRAY_STRIDE:Int;
	public static var INDEX_ARRAY_TYPE:Int;
	public static var INDEX_ARRAY_STRIDE:Int;
	public static var TEXTURE_COORD_ARRAY_SIZE:Int;
	public static var TEXTURE_COORD_ARRAY_TYPE:Int;
	public static var TEXTURE_COORD_ARRAY_STRIDE:Int;
	public static var EDGE_FLAG_ARRAY_STRIDE:Int;
	public static var VERTEX_ARRAY_POINTER:Int;
	public static var NORMAL_ARRAY_POINTER:Int;
	public static var COLOR_ARRAY_POINTER:Int;
	public static var INDEX_ARRAY_POINTER:Int;
	public static var TEXTURE_COORD_ARRAY_POINTER:Int;
	public static var EDGE_FLAG_ARRAY_POINTER:Int;
	public static var V2F:Int;
	public static var V3F:Int;
	public static var C4UB_V2F:Int;
	public static var C4UB_V3F:Int;
	public static var C3F_V3F:Int;
	public static var N3F_V3F:Int;
	public static var C4F_N3F_V3F:Int;
	public static var T2F_V3F:Int;
	public static var T4F_V4F:Int;
	public static var T2F_C4UB_V3F:Int;
	public static var T2F_C3F_V3F:Int;
	public static var T2F_N3F_V3F:Int;
	public static var T2F_C4F_N3F_V3F:Int;
	public static var T4F_C4F_N3F_V4F:Int;
	public static var MATRIX_MODE:Int;
	public static var MODELVIEW:Int;
	public static var PROJECTION:Int;
	public static var TEXTURE:Int;
	public static var POINT_SMOOTH:Int;
	public static var POINT_SIZE:Int;
	public static var POINT_SIZE_GRANULARITY:Int;
	public static var POINT_SIZE_RANGE:Int;
	public static var LINE_SMOOTH:Int;
	public static var LINE_STIPPLE:Int;
	public static var LINE_STIPPLE_PATTERN:Int;
	public static var LINE_STIPPLE_REPEAT:Int;
	public static var LINE_WIDTH:Int;
	public static var LINE_WIDTH_GRANULARITY:Int;
	public static var LINE_WIDTH_RANGE:Int;
	public static var POINT:Int;
	public static var LINE:Int;
	public static var FILL:Int;
	public static var CW:Int;
	public static var CCW:Int;
	public static var FRONT:Int;
	public static var BACK:Int;
	public static var POLYGON_MODE:Int;
	public static var POLYGON_SMOOTH:Int;
	public static var POLYGON_STIPPLE:Int;
	public static var EDGE_FLAG:Int;
	public static var CULL_FACE:Int;
	public static var CULL_FACE_MODE:Int;
	public static var FRONT_FACE:Int;
	public static var POLYGON_OFFSET_FACTOR:Int;
	public static var POLYGON_OFFSET_UNITS:Int;
	public static var POLYGON_OFFSET_POINT:Int;
	public static var POLYGON_OFFSET_LINE:Int;
	public static var POLYGON_OFFSET_FILL:Int;
	public static var COMPILE:Int;
	public static var COMPILE_AND_EXECUTE:Int;
	public static var LIST_BASE:Int;
	public static var LIST_INDEX:Int;
	public static var LIST_MODE:Int;
	public static var NEVER:Int;
	public static var LESS:Int;
	public static var EQUAL:Int;
	public static var LEQUAL:Int;
	public static var GREATER:Int;
	public static var NOTEQUAL:Int;
	public static var GEQUAL:Int;
	public static var ALWAYS:Int;
	public static var DEPTH_TEST:Int;
	public static var DEPTH_BITS:Int;
	public static var DEPTH_CLEAR_VALUE:Int;
	public static var DEPTH_FUNC:Int;
	public static var DEPTH_RANGE:Int;
	public static var DEPTH_WRITEMASK:Int;
	public static var DEPTH_COMPONENT:Int;
	public static var LIGHTING:Int;
	public static var LIGHT0:Int;
	public static var LIGHT1:Int;
	public static var LIGHT2:Int;
	public static var LIGHT3:Int;
	public static var LIGHT4:Int;
	public static var LIGHT5:Int;
	public static var LIGHT6:Int;
	public static var LIGHT7:Int;
	public static var SPOT_EXPONENT:Int;
	public static var SPOT_CUTOFF:Int;
	public static var CONSTANT_ATTENUATION:Int;
	public static var LINEAR_ATTENUATION:Int;
	public static var QUADRATIC_ATTENUATION:Int;
	public static var AMBIENT:Int;
	public static var DIFFUSE:Int;
	public static var SPECULAR:Int;
	public static var SHININESS:Int;
	public static var EMISSION:Int;
	public static var POSITION:Int;
	public static var SPOT_DIRECTION:Int;
	public static var AMBIENT_AND_DIFFUSE:Int;
	public static var COLOR_INDEXES:Int;
	public static var LIGHT_MODEL_TWO_SIDE:Int;
	public static var LIGHT_MODEL_LOCAL_VIEWER:Int;
	public static var LIGHT_MODEL_AMBIENT:Int;
	public static var FRONT_AND_BACK:Int;
	public static var SHADE_MODEL:Int;
	public static var FLAT:Int;
	public static var SMOOTH:Int;
	public static var COLOR_MATERIAL:Int;
	public static var COLOR_MATERIAL_FACE:Int;
	public static var COLOR_MATERIAL_PARAMETER:Int;
	public static var NORMALIZE:Int;
	public static var CLIP_PLANE0:Int;
	public static var CLIP_PLANE1:Int;
	public static var CLIP_PLANE2:Int;
	public static var CLIP_PLANE3:Int;
	public static var CLIP_PLANE4:Int;
	public static var CLIP_PLANE5:Int;
	public static var ACCUM_RED_BITS:Int;
	public static var ACCUM_GREEN_BITS:Int;
	public static var ACCUM_BLUE_BITS:Int;
	public static var ACCUM_ALPHA_BITS:Int;
	public static var ACCUM_CLEAR_VALUE:Int;
	public static var ACCUM:Int;
	public static var ADD:Int;
	public static var LOAD:Int;
	public static var MULT:Int;
	public static var RETURN:Int;
	public static var ALPHA_TEST:Int;
	public static var ALPHA_TEST_REF:Int;
	public static var ALPHA_TEST_FUNC:Int;
	public static var BLEND:Int;
	public static var BLEND_SRC:Int;
	public static var BLEND_DST:Int;
	public static var ZERO:Int;
	public static var ONE:Int;
	public static var SRC_COLOR:Int;
	public static var ONE_MINUS_SRC_COLOR:Int;
	public static var SRC_ALPHA:Int;
	public static var ONE_MINUS_SRC_ALPHA:Int;
	public static var DST_ALPHA:Int;
	public static var ONE_MINUS_DST_ALPHA:Int;
	public static var DST_COLOR:Int;
	public static var ONE_MINUS_DST_COLOR:Int;
	public static var SRC_ALPHA_SATURATE:Int;
	public static var FEEDBACK:Int;
	public static var RENDER:Int;
	public static var SELECT:Int;
	/* need special handling, vars cannot start with a numeral
	public static var 2_BYTES:Int;
	public static var 3_BYTES:Int;
	public static var 4_BYTES:Int;
	public static var 2D:Int;
	public static var 3D:Int;
	public static var 3D_COLOR:Int;
	public static var 3D_COLOR_TEXTURE:Int;
	public static var 4D_COLOR_TEXTURE:Int;
	*/
	public static var POINT_TOKEN:Int;
	public static var LINE_TOKEN:Int;
	public static var LINE_RESET_TOKEN:Int;
	public static var POLYGON_TOKEN:Int;
	public static var BITMAP_TOKEN:Int;
	public static var DRAW_PIXEL_TOKEN:Int;
	public static var COPY_PIXEL_TOKEN:Int;
	public static var PASS_THROUGH_TOKEN:Int;
	public static var FEEDBACK_BUFFER_POINTER:Int;
	public static var FEEDBACK_BUFFER_SIZE:Int;
	public static var FEEDBACK_BUFFER_TYPE:Int;
	public static var SELECTION_BUFFER_POINTER:Int;
	public static var SELECTION_BUFFER_SIZE:Int;
	public static var FOG:Int;
	public static var FOG_MODE:Int;
	public static var FOG_DENSITY:Int;
	public static var FOG_COLOR:Int;
	public static var FOG_INDEX:Int;
	public static var FOG_START:Int;
	public static var FOG_END:Int;
	public static var LINEAR:Int;
	public static var EXP:Int;
	public static var EXP2:Int;
	public static var LOGIC_OP:Int;
	public static var INDEX_LOGIC_OP:Int;
	public static var COLOR_LOGIC_OP:Int;
	public static var LOGIC_OP_MODE:Int;
	public static var CLEAR:Int;
	public static var SET:Int;
	public static var COPY:Int;
	public static var COPY_INVERTED:Int;
	public static var NOOP:Int;
	public static var INVERT:Int;
	public static var AND:Int;
	public static var NAND:Int;
	public static var OR:Int;
	public static var NOR:Int;
	public static var XOR:Int;
	public static var EQUIV:Int;
	public static var AND_REVERSE:Int;
	public static var AND_INVERTED:Int;
	public static var OR_REVERSE:Int;
	public static var OR_INVERTED:Int;
	public static var STENCIL_TEST:Int;
	public static var STENCIL_WRITEMASK:Int;
	public static var STENCIL_BITS:Int;
	public static var STENCIL_FUNC:Int;
	public static var STENCIL_VALUE_MASK:Int;
	public static var STENCIL_REF:Int;
	public static var STENCIL_FAIL:Int;
	public static var STENCIL_PASS_DEPTH_PASS:Int;
	public static var STENCIL_PASS_DEPTH_FAIL:Int;
	public static var STENCIL_CLEAR_VALUE:Int;
	public static var STENCIL_INDEX:Int;
	public static var KEEP:Int;
	public static var REPLACE:Int;
	public static var INCR:Int;
	public static var DECR:Int;
	public static var NONE:Int;
	public static var LEFT:Int;
	public static var RIGHT:Int;
	public static var FRONT_LEFT:Int;
	public static var FRONT_RIGHT:Int;
	public static var BACK_LEFT:Int;
	public static var BACK_RIGHT:Int;
	public static var AUX0:Int;
	public static var AUX1:Int;
	public static var AUX2:Int;
	public static var AUX3:Int;
	public static var COLOR_INDEX:Int;
	public static var RED:Int;
	public static var GREEN:Int;
	public static var BLUE:Int;
	public static var ALPHA:Int;
	public static var LUMINANCE:Int;
	public static var LUMINANCE_ALPHA:Int;
	public static var ALPHA_BITS:Int;
	public static var RED_BITS:Int;
	public static var GREEN_BITS:Int;
	public static var BLUE_BITS:Int;
	public static var INDEX_BITS:Int;
	public static var SUBPIXEL_BITS:Int;
	public static var AUX_BUFFERS:Int;
	public static var READ_BUFFER:Int;
	public static var DRAW_BUFFER:Int;
	public static var DOUBLEBUFFER:Int;
	public static var STEREO:Int;
	public static var BITMAP:Int;
	public static var COLOR:Int;
	public static var DEPTH:Int;
	public static var STENCIL:Int;
	public static var DITHER:Int;
	public static var RGB:Int;
	public static var RGBA:Int;
	public static var MAX_LIST_NESTING:Int;
	public static var MAX_ATTRIB_STACK_DEPTH:Int;
	public static var MAX_MODELVIEW_STACK_DEPTH:Int;
	public static var MAX_NAME_STACK_DEPTH:Int;
	public static var MAX_PROJECTION_STACK_DEPTH:Int;
	public static var MAX_TEXTURE_STACK_DEPTH:Int;
	public static var MAX_EVAL_ORDER:Int;
	public static var MAX_LIGHTS:Int;
	public static var MAX_CLIP_PLANES:Int;
	public static var MAX_TEXTURE_SIZE:Int;
	public static var MAX_PIXEL_MAP_TABLE:Int;
	public static var MAX_VIEWPORT_DIMS:Int;
	public static var MAX_CLIENT_ATTRIB_STACK_DEPTH:Int;
	public static var ATTRIB_STACK_DEPTH:Int;
	public static var CLIENT_ATTRIB_STACK_DEPTH:Int;
	public static var COLOR_CLEAR_VALUE:Int;
	public static var COLOR_WRITEMASK:Int;
	public static var CURRENT_INDEX:Int;
	public static var CURRENT_COLOR:Int;
	public static var CURRENT_NORMAL:Int;
	public static var CURRENT_RASTER_COLOR:Int;
	public static var CURRENT_RASTER_DISTANCE:Int;
	public static var CURRENT_RASTER_INDEX:Int;
	public static var CURRENT_RASTER_POSITION:Int;
	public static var CURRENT_RASTER_TEXTURE_COORDS:Int;
	public static var CURRENT_RASTER_POSITION_VALID:Int;
	public static var CURRENT_TEXTURE_COORDS:Int;
	public static var INDEX_CLEAR_VALUE:Int;
	public static var INDEX_MODE:Int;
	public static var INDEX_WRITEMASK:Int;
	public static var MODELVIEW_MATRIX:Int;
	public static var MODELVIEW_STACK_DEPTH:Int;
	public static var NAME_STACK_DEPTH:Int;
	public static var PROJECTION_MATRIX:Int;
	public static var PROJECTION_STACK_DEPTH:Int;
	public static var RENDER_MODE:Int;
	public static var RGBA_MODE:Int;
	public static var TEXTURE_MATRIX:Int;
	public static var TEXTURE_STACK_DEPTH:Int;
	public static var VIEWPORT:Int;
	public static var AUTO_NORMAL:Int;
	public static var MAP1_COLOR_4:Int;
	public static var MAP1_INDEX:Int;
	public static var MAP1_NORMAL:Int;
	public static var MAP1_TEXTURE_COORD_1:Int;
	public static var MAP1_TEXTURE_COORD_2:Int;
	public static var MAP1_TEXTURE_COORD_3:Int;
	public static var MAP1_TEXTURE_COORD_4:Int;
	public static var MAP1_VERTEX_3:Int;
	public static var MAP1_VERTEX_4:Int;
	public static var MAP2_COLOR_4:Int;
	public static var MAP2_INDEX:Int;
	public static var MAP2_NORMAL:Int;
	public static var MAP2_TEXTURE_COORD_1:Int;
	public static var MAP2_TEXTURE_COORD_2:Int;
	public static var MAP2_TEXTURE_COORD_3:Int;
	public static var MAP2_TEXTURE_COORD_4:Int;
	public static var MAP2_VERTEX_3:Int;
	public static var MAP2_VERTEX_4:Int;
	public static var MAP1_GRID_DOMAIN:Int;
	public static var MAP1_GRID_SEGMENTS:Int;
	public static var MAP2_GRID_DOMAIN:Int;
	public static var MAP2_GRID_SEGMENTS:Int;
	public static var COEFF:Int;
	public static var DOMAIN:Int;
	public static var ORDER:Int;
	public static var FOG_HINT:Int;
	public static var LINE_SMOOTH_HINT:Int;
	public static var PERSPECTIVE_CORRECTION_HINT:Int;
	public static var POINT_SMOOTH_HINT:Int;
	public static var POLYGON_SMOOTH_HINT:Int;
	public static var DONT_CARE:Int;
	public static var FASTEST:Int;
	public static var NICEST:Int;
	public static var SCISSOR_TEST:Int;
	public static var SCISSOR_BOX:Int;
	public static var MAP_COLOR:Int;
	public static var MAP_STENCIL:Int;
	public static var INDEX_SHIFT:Int;
	public static var INDEX_OFFSET:Int;
	public static var RED_SCALE:Int;
	public static var RED_BIAS:Int;
	public static var GREEN_SCALE:Int;
	public static var GREEN_BIAS:Int;
	public static var BLUE_SCALE:Int;
	public static var BLUE_BIAS:Int;
	public static var ALPHA_SCALE:Int;
	public static var ALPHA_BIAS:Int;
	public static var DEPTH_SCALE:Int;
	public static var DEPTH_BIAS:Int;
	public static var PIXEL_MAP_S_TO_S_SIZE:Int;
	public static var PIXEL_MAP_I_TO_I_SIZE:Int;
	public static var PIXEL_MAP_I_TO_R_SIZE:Int;
	public static var PIXEL_MAP_I_TO_G_SIZE:Int;
	public static var PIXEL_MAP_I_TO_B_SIZE:Int;
	public static var PIXEL_MAP_I_TO_A_SIZE:Int;
	public static var PIXEL_MAP_R_TO_R_SIZE:Int;
	public static var PIXEL_MAP_G_TO_G_SIZE:Int;
	public static var PIXEL_MAP_B_TO_B_SIZE:Int;
	public static var PIXEL_MAP_A_TO_A_SIZE:Int;
	public static var PIXEL_MAP_S_TO_S:Int;
	public static var PIXEL_MAP_I_TO_I:Int;
	public static var PIXEL_MAP_I_TO_R:Int;
	public static var PIXEL_MAP_I_TO_G:Int;
	public static var PIXEL_MAP_I_TO_B:Int;
	public static var PIXEL_MAP_I_TO_A:Int;
	public static var PIXEL_MAP_R_TO_R:Int;
	public static var PIXEL_MAP_G_TO_G:Int;
	public static var PIXEL_MAP_B_TO_B:Int;
	public static var PIXEL_MAP_A_TO_A:Int;
	public static var PACK_ALIGNMENT:Int;
	public static var PACK_LSB_FIRST:Int;
	public static var PACK_ROW_LENGTH:Int;
	public static var PACK_SKIP_PIXELS:Int;
	public static var PACK_SKIP_ROWS:Int;
	public static var PACK_SWAP_BYTES:Int;
	public static var UNPACK_ALIGNMENT:Int;
	public static var UNPACK_LSB_FIRST:Int;
	public static var UNPACK_ROW_LENGTH:Int;
	public static var UNPACK_SKIP_PIXELS:Int;
	public static var UNPACK_SKIP_ROWS:Int;
	public static var UNPACK_SWAP_BYTES:Int;
	public static var ZOOM_X:Int;
	public static var ZOOM_Y:Int;
	public static var TEXTURE_ENV:Int;
	public static var TEXTURE_ENV_MODE:Int;
	public static var TEXTURE_1D:Int;
	public static var TEXTURE_2D:Int;
	public static var TEXTURE_WRAP_S:Int;
	public static var TEXTURE_WRAP_T:Int;
	public static var TEXTURE_MAG_FILTER:Int;
	public static var TEXTURE_MIN_FILTER:Int;
	public static var TEXTURE_ENV_COLOR:Int;
	public static var TEXTURE_GEN_S:Int;
	public static var TEXTURE_GEN_T:Int;
	public static var TEXTURE_GEN_MODE:Int;
	public static var TEXTURE_BORDER_COLOR:Int;
	public static var TEXTURE_WIDTH:Int;
	public static var TEXTURE_HEIGHT:Int;
	public static var TEXTURE_BORDER:Int;
	public static var TEXTURE_COMPONENTS:Int;
	public static var TEXTURE_RED_SIZE:Int;
	public static var TEXTURE_GREEN_SIZE:Int;
	public static var TEXTURE_BLUE_SIZE:Int;
	public static var TEXTURE_ALPHA_SIZE:Int;
	public static var TEXTURE_LUMINANCE_SIZE:Int;
	public static var TEXTURE_INTENSITY_SIZE:Int;
	public static var NEAREST_MIPMAP_NEAREST:Int;
	public static var NEAREST_MIPMAP_LINEAR:Int;
	public static var LINEAR_MIPMAP_NEAREST:Int;
	public static var LINEAR_MIPMAP_LINEAR:Int;
	public static var OBJECT_LINEAR:Int;
	public static var OBJECT_PLANE:Int;
	public static var EYE_LINEAR:Int;
	public static var EYE_PLANE:Int;
	public static var SPHERE_MAP:Int;
	public static var DECAL:Int;
	public static var MODULATE:Int;
	public static var NEAREST:Int;
	public static var REPEAT:Int;
	public static var CLAMP:Int;
	public static var S:Int;
	public static var T:Int;
	public static var R:Int;
	public static var Q:Int;
	public static var TEXTURE_GEN_R:Int;
	public static var TEXTURE_GEN_Q:Int;
	public static var VENDOR:Int;
	public static var RENDERER:Int;
	public static var VERSION:Int;
	public static var EXTENSIONS:Int;
	public static var NO_ERROR:Int;
	public static var INVALID_VALUE:Int;
	public static var INVALID_ENUM:Int;
	public static var INVALID_OPERATION:Int;
	public static var STACK_OVERFLOW:Int;
	public static var STACK_UNDERFLOW:Int;
	public static var OUT_OF_MEMORY:Int;
	public static var CURRENT_BIT:Int;
	public static var POINT_BIT:Int;
	public static var LINE_BIT:Int;
	public static var POLYGON_BIT:Int;
	public static var POLYGON_STIPPLE_BIT:Int;
	public static var PIXEL_MODE_BIT:Int;
	public static var LIGHTING_BIT:Int;
	public static var FOG_BIT:Int;
	public static var DEPTH_BUFFER_BIT:Int;
	public static var ACCUM_BUFFER_BIT:Int;
	public static var STENCIL_BUFFER_BIT:Int;
	public static var VIEWPORT_BIT:Int;
	public static var TRANSFORM_BIT:Int;
	public static var ENABLE_BIT:Int;
	public static var COLOR_BUFFER_BIT:Int;
	public static var HINT_BIT:Int;
	public static var EVAL_BIT:Int;
	public static var LIST_BIT:Int;
	public static var TEXTURE_BIT:Int;
	public static var SCISSOR_BIT:Int;
	public static var ALL_ATTRIB_BITS:Int;
	public static var PROXY_TEXTURE_1D:Int;
	public static var PROXY_TEXTURE_2D:Int;
	public static var TEXTURE_PRIORITY:Int;
	public static var TEXTURE_RESIDENT:Int;
	public static var TEXTURE_BINDING_1D:Int;
	public static var TEXTURE_BINDING_2D:Int;
	public static var TEXTURE_INTERNAL_FORMAT:Int;
	public static var ALPHA4:Int;
	public static var ALPHA8:Int;
	public static var ALPHA12:Int;
	public static var ALPHA16:Int;
	public static var LUMINANCE4:Int;
	public static var LUMINANCE8:Int;
	public static var LUMINANCE12:Int;
	public static var LUMINANCE16:Int;
	public static var LUMINANCE4_ALPHA4:Int;
	public static var LUMINANCE6_ALPHA2:Int;
	public static var LUMINANCE8_ALPHA8:Int;
	public static var LUMINANCE12_ALPHA4:Int;
	public static var LUMINANCE12_ALPHA12:Int;
	public static var LUMINANCE16_ALPHA16:Int;
	public static var INTENSITY:Int;
	public static var INTENSITY4:Int;
	public static var INTENSITY8:Int;
	public static var INTENSITY12:Int;
	public static var INTENSITY16:Int;
	public static var R3_G3_B2:Int;
	public static var RGB4:Int;
	public static var RGB5:Int;
	public static var RGB8:Int;
	public static var RGB10:Int;
	public static var RGB12:Int;
	public static var RGB16:Int;
	public static var RGBA2:Int;
	public static var RGBA4:Int;
	public static var RGB5_A1:Int;
	public static var RGBA8:Int;
	public static var RGB10_A2:Int;
	public static var RGBA12:Int;
	public static var RGBA16:Int;
	public static var CLIENT_PIXEL_STORE_BIT:Int;
	public static var CLIENT_VERTEX_ARRAY_BIT:Int;
	
/* fail on nvidia-linux?
	public static var ALL_CLIENT_ATTRIB_BITS:Int;
	public static var CLIENT_ALL_ATTRIB_BITS:Int;
*/
	
	public static function clearIndex( c:Float ):Void;
	public static function clearColor( red:Float, green:Float, blue:Float, alpha:Float ):Void;
	public static function clear( mask:Int ):Void;
	public static function indexMask( mask:Int ):Void;
	public static function colorMask( red:Int, green:Int, blue:Int, alpha:Int ):Void;
	public static function alphaFunc( func:Int, ref:Float ):Void;
	public static function blendFunc( sfactor:Int, dfactor:Int ):Void;
	public static function logicOp( opcode:Int ):Void;
	public static function cullFace( mode:Int ):Void;
	public static function frontFace( mode:Int ):Void;
	public static function pointSize( size:Float ):Void;
	public static function lineWidth( width:Float ):Void;
	public static function lineStipple( factor:Int, pattern:Int ):Void;
	public static function polygonMode( face:Int, mode:Int ):Void;
	public static function polygonOffset( factor:Float, units:Float ):Void;
	/** <nekobind><cptr name="mask" type="unsigned char" min-size="(32*32)"/></nekobind> **/
	public static function polygonStipple( mask:String ):Void;
	/** <nekobind><cptr name="mask" type="unsigned char" min-size="(32*32)"/></nekobind> **/
	public static function getPolygonStipple( mask:String ):Void;
	public static function edgeFlag( flag:Int ):Void;
	//public static function edgeFlagv( flag:Dynamic ):Void;
	public static function scissor( x:Int, y:Int, width:Int, height:Int ):Void;

	/** <nekobind><cptr name="equation" type="double" min-size="4"/></nekobind> **/
	public static function clipPlane( plane:Int, equation:Dynamic ):Void;
	/** <nekobind><cptr name="equation" type="double" min-size="4"/></nekobind> **/
	public static function getClipPlane( plane:Int, equation:Dynamic ):Void;

	public static function drawBuffer( mode:Int ):Void;
	public static function readBuffer( mode:Int ):Void;
	public static function enable( cap:Int ):Void;
	public static function disable( cap:Int ):Void;
	public static function isEnabled( cap:Int ):Int;
	public static function enableClientState( cap:Int ):Void;
	public static function disableClientState( cap:Int ):Void;
	
	public static function pushAttrib( mask:Int ):Void;
	public static function popAttrib( ):Void;
	public static function pushClientAttrib( mask:Int ):Void;
	public static function popClientAttrib( ):Void;
	public static function renderMode( mode:Int ):Int;
	public static function getError( ):Int;
	public static function getString( name:Int ):String;
	public static function finish( ):Void;
	public static function flush( ):Void;
	public static function hint( target:Int, mode:Int ):Void;
	public static function clearDepth( depth:Float ):Void;
	public static function depthFunc( func:Int ):Void;
	public static function depthMask( flag:Int ):Void;
	public static function depthRange( near_val:Float, far_val:Float ):Void;
	public static function clearAccum( red:Float, green:Float, blue:Float, alpha:Float ):Void;
	public static function accum( op:Int, value:Float ):Void;
	public static function matrixMode( mode:Int ):Void;
	public static function ortho( left:Float, right:Float, bottom:Float, top:Float, near_val:Float, far_val:Float ):Void;
	public static function frustum( left:Float, right:Float, bottom:Float, top:Float, near_val:Float, far_val:Float ):Void;
	public static function viewport( x:Int, y:Int, width:Int, height:Int ):Void;
	public static function pushMatrix( ):Void;
	public static function popMatrix( ):Void;
	public static function loadIdentity( ):Void;
	
	/** <nekobind suffix="d"/> **/
	public static function rotate( angle:Float, x:Float, y:Float, z:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function scale( x:Float, y:Float, z:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function translate( x:Float, y:Float, z:Float ):Void;
	
	public static function isList( list:Int ):Int;
	public static function deleteLists( list:Int, range:Int ):Void;
	public static function genLists( range:Int ):Int;
	public static function newList( list:Int, mode:Int ):Void;
	public static function endList( ):Void;
	public static function callList( list:Int ):Void;
	public static function listBase( base:Int ):Void;
	public static function begin( mode:Int ):Void;
	public static function end( ):Void;
	
	/* functions with different argument type: only the d variants*/
	/** <nekobind suffix="d"/> **/
	public static function vertex2( x:Float, y:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function vertex3( x:Float, y:Float, z:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function vertex4( x:Float, y:Float, z:Float, w:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function normal3( nx:Float, ny:Float, nz:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function index( c:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function color3( red:Float, green:Float, blue:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function color4( red:Float, green:Float, blue:Float, alpha:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function texCoord1( s:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function texCoord2( s:Float, t:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function texCoord3( s:Float, t:Float, r:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function texCoord4( s:Float, t:Float, r:Float, q:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function rasterPos2( x:Float, y:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function rasterPos3( x:Float, y:Float, z:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function rasterPos4( x:Float, y:Float, z:Float, w:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function rect( x1:Float, y1:Float, x2:Float, y2:Float ):Void;

	/** <nekobind><cptr name="v" type="float" min-size="16"/></nekobind> **/
	public static function loadMatrixf( v:Dynamic ):Void;
	/** <nekobind><cptr name="v" type="double" min-size="16"/></nekobind> **/
	public static function loadMatrixd( v:Dynamic ):Void;
	
	/** <nekobind><cptr name="v" type="float" min-size="16"/></nekobind> **/
	public static function multMatrixf( v:Dynamic ):Void;
	/** <nekobind><cptr name="v" type="double" min-size="16"/></nekobind> **/
	public static function multMatrixd( v:Dynamic ):Void;

	// functions using. these are all available in f, d, s and i variants
		// FLOAT
		/** <nekobind><cptr name="v" type="float" min-size="2"/></nekobind> **/
		public static function vertex2fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="3"/></nekobind> **/
		public static function vertex3fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="4"/></nekobind> **/
		public static function vertex4fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="3"/></nekobind> **/
		public static function normal3fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="1"/></nekobind> **/
		public static function indexfv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="3"/></nekobind> **/
		public static function color3fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="4"/></nekobind> **/
		public static function color4fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="1"/></nekobind> **/
		public static function texCoord1fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="2"/></nekobind> **/
		public static function texCoord2fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="3"/></nekobind> **/
		public static function texCoord3fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="4"/></nekobind> **/
		public static function texCoord4fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="2"/></nekobind> **/
		public static function rasterPos2fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="3"/></nekobind> **/
		public static function rasterPos3fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="float" min-size="4"/></nekobind> **/
		public static function rasterPos4fv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v1" type="float" min-size="2"/>
			<cptr name="v2" type="float" min-size="2"/></nekobind> **/
		public static function rectfv( v1:Dynamic, v2:Dynamic ):Void;
		
		// DOUBLE
		/** <nekobind><cptr name="v" type="double" min-size="2"/></nekobind> **/
		public static function vertex2dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="3"/></nekobind> **/
		public static function vertex3dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="4"/></nekobind> **/
		public static function vertex4dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="3"/></nekobind> **/
		public static function normal3dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="1"/></nekobind> **/
		public static function indexdv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="3"/></nekobind> **/
		public static function color3dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="4"/></nekobind> **/
		public static function color4dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="1"/></nekobind> **/
		public static function texCoord1dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="2"/></nekobind> **/
		public static function texCoord2dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="3"/></nekobind> **/
		public static function texCoord3dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="4"/></nekobind> **/
		public static function texCoord4dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="2"/></nekobind> **/
		public static function rasterPos2dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="3"/></nekobind> **/
		public static function rasterPos3dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="double" min-size="4"/></nekobind> **/
		public static function rasterPos4dv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v1" type="double" min-size="2"/>
			<cptr name="v2" type="double" min-size="2"/></nekobind> **/
		public static function rectdv( v1:Dynamic, v2:Dynamic ):Void;

		// SHORT
		/** <nekobind><cptr name="v" type="short" min-size="2"/></nekobind> **/
		public static function vertex2sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="3"/></nekobind> **/
		public static function vertex3sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="4"/></nekobind> **/
		public static function vertex4sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="3"/></nekobind> **/
		public static function normal3sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="1"/></nekobind> **/
		public static function indexsv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="3"/></nekobind> **/
		public static function color3sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="4"/></nekobind> **/
		public static function color4sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="1"/></nekobind> **/
		public static function texCoord1sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="2"/></nekobind> **/
		public static function texCoord2sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="3"/></nekobind> **/
		public static function texCoord3sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="4"/></nekobind> **/
		public static function texCoord4sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="2"/></nekobind> **/
		public static function rasterPos2sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="3"/></nekobind> **/
		public static function rasterPos3sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="short" min-size="4"/></nekobind> **/
		public static function rasterPos4sv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v1" type="short" min-size="2"/>
			<cptr name="v2" type="short" min-size="2"/></nekobind> **/
		public static function rectsv( v1:Dynamic, v2:Dynamic ):Void;

		// INT
		/** <nekobind><cptr name="v" type="GLint" min-size="2"/></nekobind> **/
		public static function vertex2iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="3"/></nekobind> **/
		public static function vertex3iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="4"/></nekobind> **/
		public static function vertex4iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="3"/></nekobind> **/
		public static function normal3iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="1"/></nekobind> **/
		public static function indexiv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="3"/></nekobind> **/
		public static function color3iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="4"/></nekobind> **/
		public static function color4iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="1"/></nekobind> **/
		public static function texCoord1iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="2"/></nekobind> **/
		public static function texCoord2iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="3"/></nekobind> **/
		public static function texCoord3iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="4"/></nekobind> **/
		public static function texCoord4iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="2"/></nekobind> **/
		public static function rasterPos2iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="3"/></nekobind> **/
		public static function rasterPos3iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v" type="GLint" min-size="4"/></nekobind> **/
		public static function rasterPos4iv( v:Dynamic ):Void;
		/** <nekobind><cptr name="v1" type="GLint" min-size="2"/>
			<cptr name="v2" type="GLint" min-size="2"/></nekobind> **/
		public static function rectiv( v1:Dynamic, v2:Dynamic ):Void;

	
	/* somewhat more complex size checking required */
	
	/** <nekobind><cptr name="ptr" type="GLfloat" min-size="(stride*type)"/></nekobind> **/
	public static function vertexPointer( size:Int, type:Int, stride:Int, ptr:Dynamic ):Void;
	
	public static function drawElements( mode:Int, count:Int, type:Int, indices:Dynamic ):Void;
	/* somewhat more complex size checking required
	
	public static function callLists( n:Int, type:Int, lists:Dynamic ):Void;

	public static function normalPointer( type:Int, stride:Int, ptr:Void ):Void;
	public static function colorPointer( size:Int, type:Int, stride:Int, ptr:Void ):Void;
	public static function indexPointer( type:Int, stride:Int, ptr:Void ):Void;
	public static function texCoordPointer( size:Int, type:Int, stride:Int, ptr:Void ):Void;
	public static function edgeFlagPointer( stride:Int, ptr:Void ):Void;
	
	public static function interleavedArrays( format:Int, stride:Int, pointer:Void ):Void;
	*/
	
	public static function arrayElement( i:Int ):Void;
	public static function drawArrays( mode:Int, first:Int, count:Int ):Void;
	public static function shadeModel( mode:Int ):Void;
	/** <nekobind suffix="f"/> **/
	public static function light( light:Int, pname:Int, param:Float ):Void;
	/** <nekobind suffix="f"/> **/
	public static function lightModel( pname:Int, param:Float ):Void;
	/** <nekobind suffix="f"/> **/
	public static function material( face:Int, pname:Int, param:Float ):Void;
	public static function colorMaterial( face:Int, mode:Int ):Void;
	public static function pixelZoom( xfactor:Float, yfactor:Float ):Void;
	/** <nekobind suffix="f"/> **/
	public static function pixelStore( pname:Int, param:Float ):Void;
	/** <nekobind suffix="f"/> **/
	public static function pixelTransfer( pname:Int, param:Float ):Void;
/*
	public static function lightfv( light:Int, pname:Int, params:Float ):Void;
	public static function getLightfv( light:Int, pname:Int, params:Float ):Void;
	public static function lightModelfv( pname:Int, params:Float ):Void;
	public static function materialfv( face:Int, pname:Int, params:Float ):Void;
	public static function getMaterialfv( face:Int, pname:Int, params:Float ):Void;
	public static function pixelMapfv( map:Int, mapsize:Int, values:Float ):Void;
	public static function getPixelMapfv( map:Int, values:Float ):Void;
	
	public static function bitmap( width:Int, height:Int, xorig:Float, yorig:Float, xmove:Float, ymove:Float, bitmap:String ):Void;
	public static function readPixels( x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:Void ):Void;
	public static function drawPixels( width:Int, height:Int, format:Int, type:Int, pixels:Void ):Void;
	public static function copyPixels( x:Int, y:Int, width:Int, height:Int, type:Int ):Void;
*/	

	public static function stencilFunc( func:Int, ref:Int, mask:Int ):Void;
	public static function stencilMask( mask:Int ):Void;
	public static function stencilOp( fail:Int, zfail:Int, zpass:Int ):Void;
	public static function clearStencil( s:Int ):Void;
	
	/** <nekobind suffix="f"/> **/
	public static function texGen( coord:Int, pname:Int, param:Float ):Void;
	/** <nekobind suffix="f"/> **/
	public static function texEnv( target:Int, pname:Int, param:Float ):Void;
	/** <nekobind suffix="f"/> **/
	public static function texParameter( target:Int, pname:Int, param:Float ):Void;
/*
	public static function texGendv( coord:Int, pname:Int, params:Float ):Void;
	public static function getTexGendv( coord:Int, pname:Int, params:Float ):Void;
	public static function texEnvfv( target:Int, pname:Int, params:Float ):Void;
	public static function getTexEnvfv( target:Int, pname:Int, params:Float ):Void;
	public static function texParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function getTexParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function getTexLevelParameterfv( target:Int, level:Int, pname:Int, params:Float ):Void;

	public static function texImage1D( target:Int, level:Int, internalFormat:Int, width:Int, border:Int, format:Int, type:Int, pixels:Void ):Void;
	public static function getTexImage( target:Int, level:Int, format:Int, type:Int, pixels:Void ):Void;
*/

	/** <nekobind><cptr name="pixels" type="GLvoid" null-allowed="true"/></nekobind> **/
	public static function texImage2D( target:Int, level:Int, internalFormat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, pixels:Dynamic ):Void;

	/** <nekobind><cptr name="textures" type="GLuint" min-size="n"/></nekobind> **/
	public static function genTextures( n:Int, textures:Dynamic ):Void;
	
	public static function bindTexture( target:Int, texture:Int ):Void;
	public static function isTexture( texture:Int ):Int;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*4)"/></nekobind> **/
	public static function texSubImageRGBA( target:Int, x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*4)"/></nekobind> **/
	public static function texSubImageBGRA( target:Int, x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*3)"/></nekobind> **/
	public static function texSubImageRGB( target:Int, x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*3)"/></nekobind> **/
	public static function texSubImageBGR( target:Int, x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height)"/></nekobind> **/
	public static function texSubImageGRAY( target:Int, x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height)"/></nekobind> **/
	public static function texImageClearFT( target:Int, width:Int, height:Int ) :Void;
	
	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height)"/></nekobind> **/
	public static function texSubImageFT( target:Int, x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

/*	
	public static function deleteTextures( n:Int, textures:Int ):Void;
	public static function prioritizeTextures( n:Int, textures:Int, priorities:Float ):Void;
	public static function areTexturesResident( n:Int, textures:Int, residences:String ):Int;
	
	public static function texSubImage2D( target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, pixels:Void ):Void;
	public static function texSubImage1D( target:Int, level:Int, xoffset:Int, width:Int, format:Int, type:Int, pixels:Void ):Void;
	public static function copyTexImage1D( target:Int, level:Int, internalformat:Int, x:Int, y:Int, width:Int, border:Int ):Void;
	public static function copyTexImage2D( target:Int, level:Int, internalformat:Int, x:Int, y:Int, width:Int, height:Int, border:Int ):Void;
	public static function copyTexSubImage1D( target:Int, level:Int, xoffset:Int, x:Int, y:Int, width:Int ):Void;
	public static function copyTexSubImage2D( target:Int, level:Int, xoffset:Int, yoffset:Int, x:Int, y:Int, width:Int, height:Int ):Void;
	public static function map1d( target:Int, u1:Float, u2:Float, stride:Int, order:Int, points:Float ):Void;
	public static function map2d( target:Int, u1:Float, u2:Float, ustride:Int, uorder:Int, v1:Float, v2:Float, vstride:Int, vorder:Int, points:Float ):Void;
	public static function getMapdv( target:Int, query:Int, v:Float ):Void;
*/
	/** <nekobind suffix="d"/> **/
	public static function evalCoord1( u:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function evalCoord2( u:Float, v:Float ):Void;
	/** <nekobind><cptr name="u" type="float" min-size="1"/></nekobind> **/
// unavailable on OSX?
//	public static function evalCoord1df( u:Dynamic ):Void;
	/** <nekobind><cptr name="u" type="float" min-size="2"/></nekobind> **/
// unavailable on OSX?
//	public static function evalCoord2df( u:Dynamic ):Void;
	/** <nekobind><cptr name="u" type="double" min-size="1"/></nekobind> **/
	public static function evalCoord1dv( u:Dynamic ):Void;
	/** <nekobind><cptr name="u" type="double" min-size="2"/></nekobind> **/
	public static function evalCoord2dv( u:Dynamic ):Void;
	
	/** <nekobind suffix="d"/> **/
	public static function mapGrid1( un:Int, u1:Float, u2:Float ):Void;
	/** <nekobind suffix="d"/> **/
	public static function mapGrid2( un:Int, u1:Float, u2:Float, vn:Int, v1:Float, v2:Float ):Void;
	public static function evalPoint1( i:Int ):Void;
	public static function evalPoint2( i:Int, j:Int ):Void;
	public static function evalMesh1( mode:Int, i1:Int, i2:Int ):Void;
	public static function evalMesh2( mode:Int, i1:Int, i2:Int, j1:Int, j2:Int ):Void;
	
	/** <nekobind suffix="f"/> **/
	public static function fog( pname:Int, param:Float ):Void;
//	public static function fogfv( pname:Int, params:Float ):Void;
	
	/** <nekobind><cptr name="buffer" type="float" min-size="size"/></nekobind> **/
	public static function feedbackBuffer( size:Int, type:Int, buffer:Float ):Void;
	public static function passThrough( token:Float ):Void;
	/** <nekobind><cptr name="buffer" type="GLuint" min-size="size"/></nekobind> **/
	public static function selectBuffer( size:Int, buffer:Dynamic ):Void;
	
	public static function initNames( ):Void;
	public static function loadName( name:Int ):Void;
	public static function pushName( name:Int ):Void;
	public static function popName( ):Void;
	
	public static var MULTISAMPLE:Int;
	public static var BGR:Int;
	public static var BGRA:Int;
	
	/* OpenGL >1.0 (or so)
	public static var RESCALE_NORMAL:Int;
	public static var CLAMP_TO_EDGE:Int;
	public static var MAX_ELEMENTS_VERTICES:Int;
	public static var MAX_ELEMENTS_INDICES:Int;
	public static var UNSIGNED_BYTE_3_3_2:Int;
	public static var UNSIGNED_BYTE_2_3_3_REV:Int;
	public static var UNSIGNED_SHORT_5_6_5:Int;
	public static var UNSIGNED_SHORT_5_6_5_REV:Int;
	public static var UNSIGNED_SHORT_4_4_4_4:Int;
	public static var UNSIGNED_SHORT_4_4_4_4_REV:Int;
	public static var UNSIGNED_SHORT_5_5_5_1:Int;
	public static var UNSIGNED_SHORT_1_5_5_5_REV:Int;
	public static var UNSIGNED_INT_8_8_8_8:Int;
	public static var UNSIGNED_INT_8_8_8_8_REV:Int;
	public static var UNSIGNED_INT_10_10_10_2:Int;
	public static var UNSIGNED_INT_2_10_10_10_REV:Int;
	public static var LIGHT_MODEL_COLOR_CONTROL:Int;
	public static var SINGLE_COLOR:Int;
	public static var SEPARATE_SPECULAR_COLOR:Int;
	public static var TEXTURE_MIN_LOD:Int;
	public static var TEXTURE_MAX_LOD:Int;
	public static var TEXTURE_BASE_LEVEL:Int;
	public static var TEXTURE_MAX_LEVEL:Int;
	public static var SMOOTH_POINT_SIZE_RANGE:Int;
	public static var SMOOTH_POINT_SIZE_GRANULARITY:Int;
	public static var SMOOTH_LINE_WIDTH_RANGE:Int;
	public static var SMOOTH_LINE_WIDTH_GRANULARITY:Int;
	public static var ALIASED_POINT_SIZE_RANGE:Int;
	public static var ALIASED_LINE_WIDTH_RANGE:Int;
	public static var PACK_SKIP_IMAGES:Int;
	public static var PACK_IMAGE_HEIGHT:Int;
	public static var UNPACK_SKIP_IMAGES:Int;
	public static var UNPACK_IMAGE_HEIGHT:Int;
	public static var TEXTURE_3D:Int;
	public static var PROXY_TEXTURE_3D:Int;
	public static var TEXTURE_DEPTH:Int;
	public static var TEXTURE_WRAP_R:Int;
	public static var MAX_3D_TEXTURE_SIZE:Int;
	public static var TEXTURE_BINDING_3D:Int;
	public static function DrawRangeElements( mode:Int, start:Int, end:Int, count:Int, type:Int, indices:Void ):Void;
	public static function TexImage3D( target:Int, level:Int, internalFormat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int, pixels:Void ):Void;
	public static function TexSubImage3D( target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int, pixels:Void ):Void;
	public static function CopyTexSubImage3D( target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, x:Int, y:Int, width:Int, height:Int ):Void;
	public static var CONSTANT_COLOR:Int;
	public static var ONE_MINUS_CONSTANT_COLOR:Int;
	public static var CONSTANT_ALPHA:Int;
	public static var ONE_MINUS_CONSTANT_ALPHA:Int;
	public static var COLOR_TABLE:Int;
	public static var POST_CONVOLUTION_COLOR_TABLE:Int;
	public static var POST_COLOR_MATRIX_COLOR_TABLE:Int;
	public static var PROXY_COLOR_TABLE:Int;
	public static var PROXY_POST_CONVOLUTION_COLOR_TABLE:Int;
	public static var PROXY_POST_COLOR_MATRIX_COLOR_TABLE:Int;
	public static var COLOR_TABLE_SCALE:Int;
	public static var COLOR_TABLE_BIAS:Int;
	public static var COLOR_TABLE_FORMAT:Int;
	public static var COLOR_TABLE_WIDTH:Int;
	public static var COLOR_TABLE_RED_SIZE:Int;
	public static var COLOR_TABLE_GREEN_SIZE:Int;
	public static var COLOR_TABLE_BLUE_SIZE:Int;
	public static var COLOR_TABLE_ALPHA_SIZE:Int;
	public static var COLOR_TABLE_LUMINANCE_SIZE:Int;
	public static var COLOR_TABLE_INTENSITY_SIZE:Int;
	public static var CONVOLUTION_1D:Int;
	public static var CONVOLUTION_2D:Int;
	public static var SEPARABLE_2D:Int;
	public static var CONVOLUTION_BORDER_MODE:Int;
	public static var CONVOLUTION_FILTER_SCALE:Int;
	public static var CONVOLUTION_FILTER_BIAS:Int;
	public static var REDUCE:Int;
	public static var CONVOLUTION_FORMAT:Int;
	public static var CONVOLUTION_WIDTH:Int;
	public static var CONVOLUTION_HEIGHT:Int;
	public static var MAX_CONVOLUTION_WIDTH:Int;
	public static var MAX_CONVOLUTION_HEIGHT:Int;
	public static var POST_CONVOLUTION_RED_SCALE:Int;
	public static var POST_CONVOLUTION_GREEN_SCALE:Int;
	public static var POST_CONVOLUTION_BLUE_SCALE:Int;
	public static var POST_CONVOLUTION_ALPHA_SCALE:Int;
	public static var POST_CONVOLUTION_RED_BIAS:Int;
	public static var POST_CONVOLUTION_GREEN_BIAS:Int;
	public static var POST_CONVOLUTION_BLUE_BIAS:Int;
	public static var POST_CONVOLUTION_ALPHA_BIAS:Int;
	public static var CONSTANT_BORDER:Int;
	public static var REPLICATE_BORDER:Int;
	public static var CONVOLUTION_BORDER_COLOR:Int;
	public static var COLOR_MATRIX:Int;
	public static var COLOR_MATRIX_STACK_DEPTH:Int;
	public static var MAX_COLOR_MATRIX_STACK_DEPTH:Int;
	public static var POST_COLOR_MATRIX_RED_SCALE:Int;
	public static var POST_COLOR_MATRIX_GREEN_SCALE:Int;
	public static var POST_COLOR_MATRIX_BLUE_SCALE:Int;
	public static var POST_COLOR_MATRIX_ALPHA_SCALE:Int;
	public static var POST_COLOR_MATRIX_RED_BIAS:Int;
	public static var POST_COLOR_MATRIX_GREEN_BIAS:Int;
	public static var POST_COLOR_MATRIX_BLUE_BIAS:Int;
	public static var POST_COLOR_MATRIX_ALPHA_BIAS:Int;
	public static var HISTOGRAM:Int;
	public static var PROXY_HISTOGRAM:Int;
	public static var HISTOGRAM_WIDTH:Int;
	public static var HISTOGRAM_FORMAT:Int;
	public static var HISTOGRAM_RED_SIZE:Int;
	public static var HISTOGRAM_GREEN_SIZE:Int;
	public static var HISTOGRAM_BLUE_SIZE:Int;
	public static var HISTOGRAM_ALPHA_SIZE:Int;
	public static var HISTOGRAM_LUMINANCE_SIZE:Int;
	public static var HISTOGRAM_SINK:Int;
	public static var MINMAX:Int;
	public static var MINMAX_FORMAT:Int;
	public static var MINMAX_SINK:Int;
	public static var TABLE_TOO_LARGE:Int;
	public static var BLEND_EQUATION:Int;
	public static var MIN:Int;
	public static var MAX:Int;
	public static var FUNC_ADD:Int;
	public static var FUNC_SUBTRACT:Int;
	public static var FUNC_REVERSE_SUBTRACT:Int;
	public static var BLEND_COLOR:Int;
	public static function ColorTable( target:Int, internalformat:Int, width:Int, format:Int, type:Int, table:Void ):Void;
	public static function ColorSubTable( target:Int, start:Int, count:Int, format:Int, type:Int, data:Void ):Void;
	public static function ColorTableParameteriv( target:Int, pname:Int, params:Int ):Void;
	public static function ColorTableParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function CopyColorSubTable( target:Int, start:Int, x:Int, y:Int, width:Int ):Void;
	public static function CopyColorTable( target:Int, internalformat:Int, x:Int, y:Int, width:Int ):Void;
	public static function GetColorTable( target:Int, format:Int, type:Int, table:Void ):Void;
	public static function GetColorTableParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function GetColorTableParameteriv( target:Int, pname:Int, params:Int ):Void;
	public static function BlendEquation( mode:Int ):Void;
	public static function BlendColor( red:Float, green:Float, blue:Float, alpha:Float ):Void;
	public static function Histogram( target:Int, width:Int, internalformat:Int, sink:Int ):Void;
	public static function ResetHistogram( target:Int ):Void;
	public static function GetHistogram( target:Int, reset:Int, format:Int, type:Int, values:Void ):Void;
	public static function GetHistogramParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function GetHistogramParameteriv( target:Int, pname:Int, params:Int ):Void;
	public static function Minmax( target:Int, internalformat:Int, sink:Int ):Void;
	public static function ResetMinmax( target:Int ):Void;
	public static function GetMinmax( target:Int, reset:Int, format:Int, types:Int, values:Void ):Void;
	public static function GetMinmaxParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function GetMinmaxParameteriv( target:Int, pname:Int, params:Int ):Void;
	public static function ConvolutionFilter1D( target:Int, internalformat:Int, width:Int, format:Int, type:Int, image:Void ):Void;
	public static function ConvolutionFilter2D( target:Int, internalformat:Int, width:Int, height:Int, format:Int, type:Int, image:Void ):Void;
	public static function ConvolutionParameterf( target:Int, pname:Int, params:Float ):Void;
	public static function ConvolutionParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function ConvolutionParameteri( target:Int, pname:Int, params:Int ):Void;
	public static function ConvolutionParameteriv( target:Int, pname:Int, params:Int ):Void;
	public static function CopyConvolutionFilter1D( target:Int, internalformat:Int, x:Int, y:Int, width:Int ):Void;
	public static function CopyConvolutionFilter2D( target:Int, internalformat:Int, x:Int, y:Int, width:Int, height:Int ):Void;
	public static function GetConvolutionFilter( target:Int, format:Int, type:Int, image:Void ):Void;
	public static function GetConvolutionParameterfv( target:Int, pname:Int, params:Float ):Void;
	public static function GetConvolutionParameteriv( target:Int, pname:Int, params:Int ):Void;
	public static function SeparableFilter2D( target:Int, internalformat:Int, width:Int, height:Int, format:Int, type:Int, row:Void, column:Void ):Void;
	public static function GetSeparableFilter( target:Int, format:Int, type:Int, row:Void, column:Void, span:Void ):Void;
	public static var TEXTURE0:Int;
	public static var TEXTURE1:Int;
	public static var TEXTURE2:Int;
	public static var TEXTURE3:Int;
	public static var TEXTURE4:Int;
	public static var TEXTURE5:Int;
	public static var TEXTURE6:Int;
	public static var TEXTURE7:Int;
	public static var TEXTURE8:Int;
	public static var TEXTURE9:Int;
	public static var TEXTURE10:Int;
	public static var TEXTURE11:Int;
	public static var TEXTURE12:Int;
	public static var TEXTURE13:Int;
	public static var TEXTURE14:Int;
	public static var TEXTURE15:Int;
	public static var TEXTURE16:Int;
	public static var TEXTURE17:Int;
	public static var TEXTURE18:Int;
	public static var TEXTURE19:Int;
	public static var TEXTURE20:Int;
	public static var TEXTURE21:Int;
	public static var TEXTURE22:Int;
	public static var TEXTURE23:Int;
	public static var TEXTURE24:Int;
	public static var TEXTURE25:Int;
	public static var TEXTURE26:Int;
	public static var TEXTURE27:Int;
	public static var TEXTURE28:Int;
	public static var TEXTURE29:Int;
	public static var TEXTURE30:Int;
	public static var TEXTURE31:Int;
	public static var ACTIVE_TEXTURE:Int;
	public static var CLIENT_ACTIVE_TEXTURE:Int;
	public static var MAX_TEXTURE_UNITS:Int;
	public static var NORMAL_MAP:Int;
	public static var REFLECTION_MAP:Int;
	public static var TEXTURE_CUBE_MAP:Int;
	public static var TEXTURE_BINDING_CUBE_MAP:Int;
	public static var TEXTURE_CUBE_MAP_POSITIVE_X:Int;
	public static var TEXTURE_CUBE_MAP_NEGATIVE_X:Int;
	public static var TEXTURE_CUBE_MAP_POSITIVE_Y:Int;
	public static var TEXTURE_CUBE_MAP_NEGATIVE_Y:Int;
	public static var TEXTURE_CUBE_MAP_POSITIVE_Z:Int;
	public static var TEXTURE_CUBE_MAP_NEGATIVE_Z:Int;
	public static var PROXY_TEXTURE_CUBE_MAP:Int;
	public static var MAX_CUBE_MAP_TEXTURE_SIZE:Int;
	public static var COMPRESSED_ALPHA:Int;
	public static var COMPRESSED_LUMINANCE:Int;
	public static var COMPRESSED_LUMINANCE_ALPHA:Int;
	public static var COMPRESSED_INTENSITY:Int;
	public static var COMPRESSED_RGB:Int;
	public static var COMPRESSED_RGBA:Int;
	public static var TEXTURE_COMPRESSION_HINT:Int;
	public static var TEXTURE_COMPRESSED_IMAGE_SIZE:Int;
	public static var TEXTURE_COMPRESSED:Int;
	public static var NUM_COMPRESSED_TEXTURE_FORMATS:Int;
	public static var COMPRESSED_TEXTURE_FORMATS:Int;
	public static var MULTISAMPLE:Int;
	public static var SAMPLE_ALPHA_TO_COVERAGE:Int;
	public static var SAMPLE_ALPHA_TO_ONE:Int;
	public static var SAMPLE_COVERAGE:Int;
	public static var SAMPLE_BUFFERS:Int;
	public static var SAMPLES:Int;
	public static var SAMPLE_COVERAGE_VALUE:Int;
	public static var SAMPLE_COVERAGE_INVERT:Int;
	public static var MULTISAMPLE_BIT:Int;
	public static var TRANSPOSE_MODELVIEW_MATRIX:Int;
	public static var TRANSPOSE_PROJECTION_MATRIX:Int;
	public static var TRANSPOSE_TEXTURE_MATRIX:Int;
	public static var TRANSPOSE_COLOR_MATRIX:Int;
	public static var COMBINE:Int;
	public static var COMBINE_RGB:Int;
	public static var COMBINE_ALPHA:Int;
	public static var SOURCE0_RGB:Int;
	public static var SOURCE1_RGB:Int;
	public static var SOURCE2_RGB:Int;
	public static var SOURCE0_ALPHA:Int;
	public static var SOURCE1_ALPHA:Int;
	public static var SOURCE2_ALPHA:Int;
	public static var OPERAND0_RGB:Int;
	public static var OPERAND1_RGB:Int;
	public static var OPERAND2_RGB:Int;
	public static var OPERAND0_ALPHA:Int;
	public static var OPERAND1_ALPHA:Int;
	public static var OPERAND2_ALPHA:Int;
	public static var RGB_SCALE:Int;
	public static var ADD_SIGNED:Int;
	public static var INTERPOLATE:Int;
	public static var SUBTRACT:Int;
	public static var CONSTANT:Int;
	public static var PRIMARY_COLOR:Int;
	public static var PREVIOUS:Int;
	public static var DOT3_RGB:Int;
	public static var DOT3_RGBA:Int;
	public static var CLAMP_TO_BORDER:Int;
	public static function ActiveTexture( texture:Int ):Void;
	public static function ClientActiveTexture( texture:Int ):Void;
	public static function CompressedTexImage1D( target:Int, level:Int, internalformat:Int, width:Int, border:Int, imageSize:Int, data:Void ):Void;
	public static function CompressedTexImage2D( target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, imageSize:Int, data:Void ):Void;
	public static function CompressedTexImage3D( target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, imageSize:Int, data:Void ):Void;
	public static function CompressedTexSubImage1D( target:Int, level:Int, xoffset:Int, width:Int, format:Int, imageSize:Int, data:Void ):Void;
	public static function CompressedTexSubImage2D( target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, imageSize:Int, data:Void ):Void;
	public static function CompressedTexSubImage3D( target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, imageSize:Int, data:Void ):Void;
	public static function GetCompressedTexImage( target:Int, lod:Int, img:Void ):Void;
	public static function MultiTexCoord1d( target:Int, s:Float ):Void;
	public static function MultiTexCoord1dv( target:Int, v:Float ):Void;
	public static function MultiTexCoord1f( target:Int, s:Float ):Void;
	public static function MultiTexCoord1fv( target:Int, v:Float ):Void;
	public static function MultiTexCoord1i( target:Int, s:Int ):Void;
	public static function MultiTexCoord1iv( target:Int, v:Int ):Void;
	public static function MultiTexCoord1s( target:Int, s:Int ):Void;
	public static function MultiTexCoord1sv( target:Int, v:Int ):Void;
	public static function MultiTexCoord2d( target:Int, s:Float, t:Float ):Void;
	public static function MultiTexCoord2dv( target:Int, v:Float ):Void;
	public static function MultiTexCoord2f( target:Int, s:Float, t:Float ):Void;
	public static function MultiTexCoord2fv( target:Int, v:Float ):Void;
	public static function MultiTexCoord2i( target:Int, s:Int, t:Int ):Void;
	public static function MultiTexCoord2iv( target:Int, v:Int ):Void;
	public static function MultiTexCoord2s( target:Int, s:Int, t:Int ):Void;
	public static function MultiTexCoord2sv( target:Int, v:Int ):Void;
	public static function MultiTexCoord3d( target:Int, s:Float, t:Float, r:Float ):Void;
	public static function MultiTexCoord3dv( target:Int, v:Float ):Void;
	public static function MultiTexCoord3f( target:Int, s:Float, t:Float, r:Float ):Void;
	public static function MultiTexCoord3fv( target:Int, v:Float ):Void;
	public static function MultiTexCoord3i( target:Int, s:Int, t:Int, r:Int ):Void;
	public static function MultiTexCoord3iv( target:Int, v:Int ):Void;
	public static function MultiTexCoord3s( target:Int, s:Int, t:Int, r:Int ):Void;
	public static function MultiTexCoord3sv( target:Int, v:Int ):Void;
	public static function MultiTexCoord4d( target:Int, s:Float, t:Float, r:Float, q:Float ):Void;
	public static function MultiTexCoord4dv( target:Int, v:Float ):Void;
	public static function MultiTexCoord4f( target:Int, s:Float, t:Float, r:Float, q:Float ):Void;
	public static function MultiTexCoord4fv( target:Int, v:Float ):Void;
	public static function MultiTexCoord4i( target:Int, s:Int, t:Int, r:Int, q:Int ):Void;
	public static function MultiTexCoord4iv( target:Int, v:Int ):Void;
	public static function MultiTexCoord4s( target:Int, s:Int, t:Int, r:Int, q:Int ):Void;
	public static function MultiTexCoord4sv( target:Int, v:Int ):Void;
	public static function LoadTransposeMatrixd( m:Float ):Void;
	public static function LoadTransposeMatrixf( m:Float ):Void;
	public static function MultTransposeMatrixd( m:Float ):Void;
	public static function MultTransposeMatrixf( m:Float ):Void;
	public static function SampleCoverage( value:Float, invert:Int ):Void;
	public static var ARB_multitexture:Int;
	public static var TEXTURE0_ARB:Int;
	public static var TEXTURE1_ARB:Int;
	public static var TEXTURE2_ARB:Int;
	public static var TEXTURE3_ARB:Int;
	public static var TEXTURE4_ARB:Int;
	public static var TEXTURE5_ARB:Int;
	public static var TEXTURE6_ARB:Int;
	public static var TEXTURE7_ARB:Int;
	public static var TEXTURE8_ARB:Int;
	public static var TEXTURE9_ARB:Int;
	public static var TEXTURE10_ARB:Int;
	public static var TEXTURE11_ARB:Int;
	public static var TEXTURE12_ARB:Int;
	public static var TEXTURE13_ARB:Int;
	public static var TEXTURE14_ARB:Int;
	public static var TEXTURE15_ARB:Int;
	public static var TEXTURE16_ARB:Int;
	public static var TEXTURE17_ARB:Int;
	public static var TEXTURE18_ARB:Int;
	public static var TEXTURE19_ARB:Int;
	public static var TEXTURE20_ARB:Int;
	public static var TEXTURE21_ARB:Int;
	public static var TEXTURE22_ARB:Int;
	public static var TEXTURE23_ARB:Int;
	public static var TEXTURE24_ARB:Int;
	public static var TEXTURE25_ARB:Int;
	public static var TEXTURE26_ARB:Int;
	public static var TEXTURE27_ARB:Int;
	public static var TEXTURE28_ARB:Int;
	public static var TEXTURE29_ARB:Int;
	public static var TEXTURE30_ARB:Int;
	public static var TEXTURE31_ARB:Int;
	public static var ACTIVE_TEXTURE_ARB:Int;
	public static var CLIENT_ACTIVE_TEXTURE_ARB:Int;
	public static var MAX_TEXTURE_UNITS_ARB:Int;
	public static function ActiveTextureARB( texture:Int ):Void;
	public static function ClientActiveTextureARB( texture:Int ):Void;
	public static function MultiTexCoord1dARB( target:Int, s:Float ):Void;
	public static function MultiTexCoord1dvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord1fARB( target:Int, s:Float ):Void;
	public static function MultiTexCoord1fvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord1iARB( target:Int, s:Int ):Void;
	public static function MultiTexCoord1ivARB( target:Int, v:Int ):Void;
	public static function MultiTexCoord1sARB( target:Int, s:Int ):Void;
	public static function MultiTexCoord1svARB( target:Int, v:Int ):Void;
	public static function MultiTexCoord2dARB( target:Int, s:Float, t:Float ):Void;
	public static function MultiTexCoord2dvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord2fARB( target:Int, s:Float, t:Float ):Void;
	public static function MultiTexCoord2fvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord2iARB( target:Int, s:Int, t:Int ):Void;
	public static function MultiTexCoord2ivARB( target:Int, v:Int ):Void;
	public static function MultiTexCoord2sARB( target:Int, s:Int, t:Int ):Void;
	public static function MultiTexCoord2svARB( target:Int, v:Int ):Void;
	public static function MultiTexCoord3dARB( target:Int, s:Float, t:Float, r:Float ):Void;
	public static function MultiTexCoord3dvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord3fARB( target:Int, s:Float, t:Float, r:Float ):Void;
	public static function MultiTexCoord3fvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord3iARB( target:Int, s:Int, t:Int, r:Int ):Void;
	public static function MultiTexCoord3ivARB( target:Int, v:Int ):Void;
	public static function MultiTexCoord3sARB( target:Int, s:Int, t:Int, r:Int ):Void;
	public static function MultiTexCoord3svARB( target:Int, v:Int ):Void;
	public static function MultiTexCoord4dARB( target:Int, s:Float, t:Float, r:Float, q:Float ):Void;
	public static function MultiTexCoord4dvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord4fARB( target:Int, s:Float, t:Float, r:Float, q:Float ):Void;
	public static function MultiTexCoord4fvARB( target:Int, v:Float ):Void;
	public static function MultiTexCoord4iARB( target:Int, s:Int, t:Int, r:Int, q:Int ):Void;
	public static function MultiTexCoord4ivARB( target:Int, v:Int ):Void;
	public static function MultiTexCoord4sARB( target:Int, s:Int, t:Int, r:Int, q:Int ):Void;
	public static function MultiTexCoord4svARB( target:Int, v:Int ):Void;
	public static function Map1d_01( target:Int, stride:Int, order:Int, points:Float ):Void;
*/
	public static function __init__() : Void {
		DLLLoader.addLibToPath("opengl");
		untyped {
			var loader = untyped __dollar__loader;
			GL = loader.loadmodule("opengl".__s,loader).GL__impl;
		}
	}
}
