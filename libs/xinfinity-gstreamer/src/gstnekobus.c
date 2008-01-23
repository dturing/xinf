#include <stdlib.h>
#include <dlfcn.h>
#include <errno.h>

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gstnekobus.h"

static GstElementDetails gst_nekobus_details = {
  "NekoBus",
  "Sink/Video",
  "posts incoming buffers on the bus for the nekovm to catch them",
  "Daniel Fischer <dan@subsignal.org>",
};


static void gst_nekobus_class_init (GstNekoBusClass * klass);
static void gst_nekobus_init (GstNekoBus * nekobus);
static void gst_nekobus_base_init (gpointer g_class);


static GstStaticPadTemplate gst_nekobus_sink_template_factory =
    GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
	GST_STATIC_CAPS_ANY
    );

enum
{
  ARG_0
};

static void gst_nekobus_finalize (GObject * object);
static void gst_nekobus_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_nekobus_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);


static GstFlowReturn
gst_nekobus_show_frame (GstBaseSink * sink, GstBuffer * buf)
{
  GstNekoBus *element;
  element = GST_NEKOBUS (sink);
	
	GstStructure *msg = gst_structure_new("nekobus::data",
		"element", G_TYPE_STRING, gst_element_get_name( GST_ELEMENT(element) ),
		"buffer", GST_TYPE_BUFFER, buf,
		NULL );
	gst_bus_post( gst_element_get_bus(GST_ELEMENT(sink)),
		gst_message_new_application( GST_OBJECT(sink), msg ) );

	/* we're leaving the buffer unref'ing to the bus receiver :/ 
	 -- what if noone receives the msg? FIXME */
	
  return GST_FLOW_OK;
}

static void
gst_nekobus_init (GstNekoBus * nekobus)
{
}

	
static void
gst_nekobus_base_init (gpointer g_class)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (g_class);

  gst_element_class_add_pad_template (element_class, gst_static_pad_template_get(&gst_nekobus_sink_template_factory) );
  gst_element_class_set_details (element_class, &gst_nekobus_details);
}

static void
gst_nekobus_class_init (GstNekoBusClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;

  GstElementClass *parent_class = g_type_class_peek_parent (klass);

  gobject_class->set_property = gst_nekobus_set_property;
  gobject_class->get_property = gst_nekobus_get_property;

  gstbasesink_class->render = GST_DEBUG_FUNCPTR (gst_nekobus_show_frame);
}

static void
gst_nekobus_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstNekoBus *nekobus;
  g_return_if_fail (GST_IS_NEKOBUS (object));
  nekobus = GST_NEKOBUS (object);

  switch( prop_id ) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_nekobus_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstNekoBus *nekobus;
  g_return_if_fail (GST_IS_NEKOBUS (object));
  nekobus = GST_NEKOBUS (object);
	
  switch( prop_id ) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

GType
gst_nekobus_get_type(void)
{
	static GType type = 0;

	if (type == 0) {
		static const GTypeInfo info = {
			sizeof (GstNekoBusClass),
			(GBaseInitFunc) gst_nekobus_base_init,
			(GBaseFinalizeFunc) NULL,
			(GClassInitFunc) gst_nekobus_class_init,
			(GClassFinalizeFunc) NULL,
			NULL /* class_data */,
			sizeof (GstNekoBus),
			0 /* n_preallocs */,
			(GInstanceInitFunc) gst_nekobus_init,
		};

		type = g_type_register_static (GST_TYPE_BASE_SINK, "GstNekoBus", &info, (GTypeFlags)0);
	}

	return type;
}

/* global plugin init stuff */
static gboolean
plugin_init (GstPlugin *plugin)
{
	return gst_element_register( plugin, "nekobus", GST_RANK_NONE, GST_TYPE_NEKOBUS );
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
	"http://subsignal.org/gst-nekobus/"
);
