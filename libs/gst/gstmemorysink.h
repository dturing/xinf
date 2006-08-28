#ifndef __GST_MEMORYSINK_H__
#define __GST_MEMORYSINK_H__

#include <gst/gst.h>
#include <gst/video/gstvideosink.h>

G_BEGIN_DECLS


#define GST_TYPE_MEMORYSINK \
  (gst_memorysink_get_type())
#define GST_MEMORYSINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_MEMORYSINK,GstMemorySink))
#define GST_MEMORYSINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_MEMORYSINK,GstMemorySinkClass))
#define GST_IS_MEMORYSINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_MEMORYSINK))
#define GST_IS_MEMORYSINK_CLASS(obj) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_MEMORYSINK))

typedef struct _GstMemorySink GstMemorySink;
typedef struct _GstMemorySinkClass GstMemorySinkClass;

struct _GstMemorySink {
  GstVideoSink videosink;

  guint nFrames, cFrame;
  void **frames;
  guint video_width, video_height;     /* size of incoming video */
};

struct _GstMemorySinkClass {
  GstVideoSinkClass parent_class;
};

GType gst_memorysink_get_type(void);

G_END_DECLS

#endif /* __GST_MEMORYSINK_H__ */
