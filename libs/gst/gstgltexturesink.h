#ifndef __GST_GLTEXTURESINK_H__
#define __GST_GLTEXTURESINK_H__

#include <gst/gst.h>
#include <gst/video/gstvideosink.h>

G_BEGIN_DECLS


#define GST_TYPE_GLTEXTURESINK \
  (gst_gltexturesink_get_type())
#define GST_GLTEXTURESINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_GLTEXTURESINK,GstGLTextureSink))
#define GST_GLTEXTURESINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_GLTEXTURESINK,GstGLTextureSinkClass))
#define GST_IS_GLTEXTURESINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_GLTEXTURESINK))
#define GST_IS_GLTEXTURESINK_CLASS(obj) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_GLTEXTURESINK))

typedef struct _GstGLTextureSink GstGLTextureSink;
typedef struct _GstGLTextureSinkClass GstGLTextureSinkClass;

struct _GstGLTextureSink {
  GstVideoSink videosink;

  guint texture_id;
  guint video_width, video_height;     /* size of incoming video */
  guint texture_width, texture_height;     /* allocated size of texture */
  GMutex *mutex;
  GCond *texture_ready;
  GCond *texture_consumed;
};

struct _GstGLTextureSinkClass {
  GstVideoSinkClass parent_class;
};

GType gst_gltexturesink_get_type(void);

G_END_DECLS

#endif /* __GST_GLTEXTURESINK_H__ */
