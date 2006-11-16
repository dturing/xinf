#include <stdlib.h>
#include <dlfcn.h>
#include <errno.h>

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gstmemorysink.h"

static GstElementDetails gst_memorysink_details = {
  "Memory sink",
  "Sink/Video",
  "saves the incoming video to RAM memory",
  "Daniel Fischer <dan@subsignal.org>",
};


static void gst_memorysink_class_init (GstMemorySinkClass * klass);
static void gst_memorysink_init (GstMemorySink * memorysink);
static void gst_memorysink_base_init (gpointer g_class);


static GstStaticPadTemplate gst_memorysink_sink_template_factory =
    GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
	GST_STATIC_CAPS_ANY
/*	
    GST_STATIC_CAPS ("video/x-raw-rgb, "
        "framerate = (fraction) [ 0, MAX ], "
        "width = (int) [ 1, MAX ], "
		"depth = (int)24, "
		"bpp = (int)32, "
        "height = (int) [ 1, MAX ] ") 
*/	
    );

enum
{
  ARG_0,
  ARG_N_FRAMES,
  ARG_WIDTH,
  ARG_HEIGHT
};

static void gst_memorysink_finalize (GObject * object);
static void gst_memorysink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_memorysink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);


static GstFlowReturn
gst_memorysink_show_frame (GstBaseSink * sink, GstBuffer * buf)
{
  GstMemorySink *element;
  element = GST_MEMORYSINK (sink);

	int c = element->cFrame;
	if( element->frames[c]==NULL ) {
		element->frames[c] = (unsigned char *)malloc( GST_BUFFER_SIZE(buf) );
	}
	// FIXME: this is dangerous, we're not sure the buffer is big enough FIXME
	memcpy( element->frames[c], GST_BUFFER_DATA(buf), GST_BUFFER_SIZE(buf) );
	
	GstStructure *msg = gst_structure_new("data",
		"data", G_TYPE_POINTER, element->frames[c],
		"size", G_TYPE_INT, GST_BUFFER_SIZE(buf),
		"element", G_TYPE_STRING, gst_element_get_name(element),
		NULL );
	gst_bus_post( gst_element_get_bus(GST_ELEMENT(sink)),
		gst_message_new_application( GST_OBJECT(sink), msg ) );
	
	element->cFrame = (c+1)%element->nFrames;
	
  return GST_FLOW_OK;
}

static gboolean
gst_memorysink_setcaps (GstBaseSink * sink, GstCaps * caps)
{
  gboolean ret;
  int i;
  GstMemorySink *element;
  element = GST_MEMORYSINK (sink);

  GstStructure *structure;
  structure = gst_caps_get_structure (caps, 0);
  ret = gst_structure_get_int (structure, "width", &element->video_width);
  ret &= gst_structure_get_int (structure, "height", &element->video_height);

  for( i=0; i<element->nFrames; i++ ) {
	  if( element->frames[i] )
		free(element->frames[i]);
	  element->frames[i] = NULL;
  }
  
  return( ret );
}

static void
gst_memorysink_init (GstMemorySink * memorysink)
{
	int i;
	memorysink->nFrames=1;
	memorysink->cFrame=0;
	memorysink->frames=(unsigned char**)malloc(memorysink->nFrames*sizeof(unsigned char*));
	for( i=0; i<memorysink->nFrames; i++ ) {
	  memorysink->frames[i] = NULL;
	}
}


static void
gst_memorysink_finalize (GObject * object)
{
  GstMemorySink *memorysink;
  memorysink = GST_MEMORYSINK (object);
	
	//  FIXME free memory
  printf("MemorySink finalize\n");
}
	
static void
gst_memorysink_base_init (gpointer g_class)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (g_class);

  gst_element_class_add_pad_template (element_class, gst_static_pad_template_get(&gst_memorysink_sink_template_factory) );
  gst_element_class_set_details (element_class, &gst_memorysink_details);
}

static void
gst_memorysink_class_init (GstMemorySinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;

  GstElementClass *parent_class = g_type_class_peek_parent (klass);

  gobject_class->set_property = gst_memorysink_set_property;
  gobject_class->get_property = gst_memorysink_get_property;

  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_N_FRAMES,
      g_param_spec_int ("n", "Number of Frames", "maximum number of frames to buffer",
          0.0, G_MAXINT, 1.0, G_PARAM_READWRITE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_WIDTH,
      g_param_spec_int ("width", "Image Width", "Width (in pixels) of the image on the texture",
          0.0, G_MAXINT, 1.0, G_PARAM_READABLE));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_HEIGHT,
      g_param_spec_int ("height", "Image Height", "Height (in pixels) of the image on the texture",
          0.0, G_MAXINT, 1.0, G_PARAM_READABLE));

  gobject_class->finalize = gst_memorysink_finalize;
  gstbasesink_class->set_caps = GST_DEBUG_FUNCPTR (gst_memorysink_setcaps);
  gstbasesink_class->render = GST_DEBUG_FUNCPTR (gst_memorysink_show_frame);
}

static void
gst_memorysink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstMemorySink *memorysink;
  g_return_if_fail (GST_IS_MEMORYSINK (object));
  memorysink = GST_MEMORYSINK (object);

  switch( prop_id ) {
	case ARG_N_FRAMES:
		memorysink->nFrames = g_value_get_int( value );
		break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_memorysink_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstMemorySink *memorysink;
  g_return_if_fail (GST_IS_MEMORYSINK (object));
  memorysink = GST_MEMORYSINK (object);
	
  switch( prop_id ) {
    case ARG_WIDTH:
      g_value_set_int (value, memorysink->video_width);
      break;
    case ARG_HEIGHT:
      g_value_set_int (value, memorysink->video_height);
      break;
    case ARG_N_FRAMES:
      g_value_set_int (value, memorysink->nFrames);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

GType
gst_memorysink_get_type(void)
{
	static GType type = 0;

	if (type == 0) {
		static const GTypeInfo info = {
			sizeof (GstMemorySinkClass),
			(GBaseInitFunc) gst_memorysink_base_init,
			(GBaseFinalizeFunc) NULL,
			(GClassInitFunc) gst_memorysink_class_init,
			(GClassFinalizeFunc) NULL,
			NULL /* class_data */,
			sizeof (GstMemorySink),
			0 /* n_preallocs */,
			(GInstanceInitFunc) gst_memorysink_init,
		};

		type = g_type_register_static (GST_TYPE_VIDEO_SINK, "GstMemorySink", &info, (GTypeFlags)0);
	}

	return type;
}

/* global plugin init stuff */
static gboolean
plugin_init (GstPlugin *plugin)
{
	return gst_element_register( plugin, "memorysink", GST_RANK_NONE, GST_TYPE_MEMORYSINK );
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
	"http://subsignal.org/gst-memorysink/"
);
