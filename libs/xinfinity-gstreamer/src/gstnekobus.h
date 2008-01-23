#ifndef __GST_NEKOBUS_H__
#define __GST_NEKOBUS_H__

#include <gst/gst.h>
#include <gst/base/gstbasesink.h>

G_BEGIN_DECLS


#define GST_TYPE_NEKOBUS \
  (gst_nekobus_get_type())
#define GST_NEKOBUS(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_NEKOBUS,GstNekoBus))
#define GST_NEKOBUS_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_NEKOBUS,GstNekoBusClass))
#define GST_IS_NEKOBUS(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_NEKOBUS))
#define GST_IS_NEKOBUS_CLASS(obj) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_NEKOBUS))

typedef struct _GstNekoBus GstNekoBus;
typedef struct _GstNekoBusClass GstNekoBusClass;

struct _GstNekoBus {
  GstBaseSink videosink;
};

struct _GstNekoBusClass {
  GstBaseSinkClass parent_class;
};

GType gst_nekobus_get_type(void);

G_END_DECLS

#endif /* __GST_NEKOBUS_H__ */
