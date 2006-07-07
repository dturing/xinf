#include <stdlib.h>
#include <dlfcn.h>
#include <errno.h>
#include <GL/gl.h>

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gstgltexturesink.h"

static GstElementDetails gst_gltexturesink_details = {
  "OpenGL Texture sink",
  "Sink/Video",
  "copies the incoming video to a OpenGL texture",
  "Daniel Fischer <dan@subsignal.org>",
};


static void gst_gltexturesink_class_init (GstGLTextureSinkClass * klass);
static void gst_gltexturesink_init (GstGLTextureSink * gltexturesink);
static void gst_gltexturesink_base_init (gpointer g_class);


static GstStaticPadTemplate gst_gltexturesink_sink_template_factory =
    GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-raw-rgb, "
        "framerate = (fraction) [ 0, MAX ], "
        "width = (int) [ 1, MAX ], "
		"depth = (int)24, "
		"bpp = (int)32, "
        "height = (int) [ 1, MAX ] ")
    );

enum
{
  ARG_0,
  ARG_TEXTURE_ID,
  ARG_TEXTURE_WIDTH,
  ARG_TEXTURE_HEIGHT,
  ARG_WIDTH,
  ARG_HEIGHT,
  ARG_MUTEX,
  ARG_TEXTURE_READY,
  ARG_TEXTURE_CONSUMED
};

GstElementClass *parent_class = NULL;

static void gst_gltexturesink_finalize (GObject * object);
static void gst_gltexturesink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_gltexturesink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);


static GstFlowReturn
gst_gltexturesink_show_frame (GstBaseSink * sink, GstBuffer * buf)
{
  GstGLTextureSink *gl;
  gl = GST_GLTEXTURESINK (sink);

//	printf("GLTextureSink show_frame (tex #%i)\n", gl->texture_id);
	
  if( gl->texture_id == -1 ) {
	g_error("GL Texture uninitalized");
	return GST_FLOW_ERROR;
  }

	  glPushAttrib( GL_TEXTURE_2D );
		glEnable( GL_TEXTURE_2D );
		glBindTexture( GL_TEXTURE_2D, gl->texture_id );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
		glPixelStorei( GL_UNPACK_ALIGNMENT, 1 );
	    
	    glTexSubImage2D( GL_TEXTURE_2D, 0, 0, 0, gl->video_width, gl->video_height, 
						GL_BGRA, GL_UNSIGNED_BYTE, GST_BUFFER_DATA(buf) );
	
	  glPopAttrib();
	
	g_mutex_lock( gl->mutex );
	g_cond_signal(gl->texture_ready);
 //   g_cond_wait(gl->texture_consumed, gl->mutex);
	g_mutex_unlock( gl->mutex );

    GLenum err = glGetError();
  
  if( err > 0 ) {
	g_warning("OpenGL error: %i %s", err, gluErrorString(err));
  }
  
  return GST_FLOW_OK;
}

static gboolean
gst_gltexturesink_setcaps (GstBaseSink * sink, GstCaps * caps)
{
  gboolean ret;
  GstGLTextureSink *gl;
  gl = GST_GLTEXTURESINK (sink);

  GstStructure *structure;
  structure = gst_caps_get_structure (caps, 0);
  ret = gst_structure_get_int (structure, "width", &gl->video_width);
  ret &= gst_structure_get_int (structure, "height", &gl->video_height);
	
  if( gl->texture_id != -1 ) {
	g_error("Should delete old texture");
  }
	
  g_mutex_lock(gl->mutex);
	  GLuint tex;
	  tex=-1;
	  glGenTextures(1,&tex);
	  gl->texture_id = tex;
	  
	  if( tex==-1 ) {
		g_error("Couldn't initialize texture-- must run within a valid OpenGL context");
	  }
	  
	  gl->texture_width=64; while( gl->texture_width<gl->video_width ) gl->texture_width<<=1;
	  gl->texture_height=64; while( gl->texture_height<gl->video_height ) gl->texture_height<<=1;

	  g_message("initialize tex #%i, %ix%i for image %ix%i",tex, gl->texture_width, gl->texture_height, gl->video_width, gl->video_height );
		glBindTexture( GL_TEXTURE_2D, gl->texture_id );
	  glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, gl->texture_width, gl->texture_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL );
  g_mutex_unlock(gl->mutex);
	
  return( ret );
}

static void
gst_gltexturesink_init (GstGLTextureSink * gltexturesink)
{
	gltexturesink->texture_id=-1;
	gltexturesink->mutex = g_mutex_new();
	gltexturesink->texture_ready = g_cond_new();
	gltexturesink->texture_consumed = g_cond_new();
}


/* Finalize is called only once, dispose can be called multiple times.
 * We use mutexes and don't reset stuff to NULL here so let's register
 * as a finalize. */
static void
gst_gltexturesink_finalize (GObject * object)
{
  GstGLTextureSink *gltexturesink;
  gltexturesink = GST_GLTEXTURESINK (object);
	
  if( gltexturesink->mutex ) g_free( gltexturesink->mutex );
  if( gltexturesink->texture_ready ) g_free( gltexturesink->texture_ready );
  if( gltexturesink->texture_consumed ) g_free( gltexturesink->texture_consumed );
	  
	printf("GLTextureSink finalize\n");
}
	
static void
gst_gltexturesink_base_init (gpointer g_class)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (g_class);

  gst_element_class_add_pad_template (element_class, gst_static_pad_template_get(&gst_gltexturesink_sink_template_factory) );
  gst_element_class_set_details (element_class, &gst_gltexturesink_details);
}

static void
gst_gltexturesink_class_init (GstGLTextureSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->set_property = gst_gltexturesink_set_property;
  gobject_class->get_property = gst_gltexturesink_get_property;

/*  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_MUTE,
      g_param_spec_boolean ("mute", "mute", "mute", FALSE, G_PARAM_READWRITE));

  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_VOLUME,
      g_param_spec_double ("volume", "volume", "volume",
          0.0, VOLUME_MAX_DOUBLE, 1.0, G_PARAM_READWRITE));
*/

  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TEXTURE_ID,
      g_param_spec_int ("texture", "Texture ID", "ID of the OpenGL texture.",
          0.0, G_MAXINT, 1.0, G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TEXTURE_WIDTH,
      g_param_spec_int ("texture_width", "Texture Width", "Width (in pixels) of the texture",
          0.0, G_MAXINT, 1.0, G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TEXTURE_HEIGHT,
      g_param_spec_int ("texture_height", "Texture Height", "Height (in pixels) of the texture",
          0.0, G_MAXINT, 1.0, G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_WIDTH,
      g_param_spec_int ("width", "Image Width", "Width (in pixels) of the image on the texture",
          0.0, G_MAXINT, 1.0, G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_HEIGHT,
      g_param_spec_int ("height", "Image Height", "Height (in pixels) of the image on the texture",
          0.0, G_MAXINT, 1.0, G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_MUTEX,
      g_param_spec_pointer ("mutex", "GL Mutex", "will be locked when this element does GL operations",
		G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TEXTURE_READY,
      g_param_spec_pointer ("texture_ready", "TextureReady Condition", "will signal texture availability",
		G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TEXTURE_CONSUMED,
      g_param_spec_pointer ("texture_consumed", "TextureConsumed Condition", "will wait for this before setting a new texture image",
		G_PARAM_READABLE));

  gobject_class->finalize = gst_gltexturesink_finalize;
  gstbasesink_class->set_caps = GST_DEBUG_FUNCPTR (gst_gltexturesink_setcaps);
  gstbasesink_class->render = GST_DEBUG_FUNCPTR (gst_gltexturesink_show_frame);
}

static void
gst_gltexturesink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstGLTextureSink *gltexturesink;
  g_return_if_fail (GST_IS_GLTEXTURESINK (object));
  gltexturesink = GST_GLTEXTURESINK (object);

  switch( prop_id ) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_gltexturesink_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstGLTextureSink *gltexturesink;
  g_return_if_fail (GST_IS_GLTEXTURESINK (object));
  gltexturesink = GST_GLTEXTURESINK (object);
	
  switch( prop_id ) {
    case ARG_WIDTH:
      g_value_set_int (value, gltexturesink->video_width);
      break;
    case ARG_HEIGHT:
      g_value_set_int (value, gltexturesink->video_height);
      break;
    case ARG_TEXTURE_ID:
      g_value_set_int (value, gltexturesink->texture_id);
      break;
    case ARG_TEXTURE_WIDTH:
      g_value_set_int (value, gltexturesink->texture_width);
      break;
    case ARG_TEXTURE_HEIGHT:
      g_value_set_int (value, gltexturesink->texture_height);
      break;
    case ARG_MUTEX:
      g_value_set_pointer (value, gltexturesink->mutex);
      break;
    case ARG_TEXTURE_READY:
      g_value_set_pointer (value, gltexturesink->texture_ready);
      break;
    case ARG_TEXTURE_CONSUMED:
      g_value_set_pointer (value, gltexturesink->texture_consumed);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

GType
gst_gltexturesink_get_type(void)
{
	static GType type = 0;

	if (type == 0) {
		static const GTypeInfo info = {
			sizeof (GstGLTextureSinkClass),
			(GBaseInitFunc) gst_gltexturesink_base_init,
			(GBaseFinalizeFunc) NULL,
			(GClassInitFunc) gst_gltexturesink_class_init,
			(GClassFinalizeFunc) NULL,
			NULL /* class_data */,
			sizeof (GstGLTextureSink),
			0 /* n_preallocs */,
			(GInstanceInitFunc) gst_gltexturesink_init,
		};

		type = g_type_register_static (GST_TYPE_VIDEO_SINK, "GstGLTextureSink", &info, (GTypeFlags)0);
	}

	return type;
}

/* global plugin init stuff */
static gboolean
plugin_init (GstPlugin *plugin)
{
	return gst_element_register( plugin, "texturesink", GST_RANK_NONE, GST_TYPE_GLTEXTURESINK );
}

#define PACKAGE "xinf"
GST_PLUGIN_DEFINE_STATIC(
	0,
	10,
	"xinf-plugins",
	"xinf-specific gstreamer plugins",
	plugin_init,
	"1",
	"LGPL",
	"xinf gstreamer module",
	"http://subsignal.org/gst-gltexturesink/"
);
