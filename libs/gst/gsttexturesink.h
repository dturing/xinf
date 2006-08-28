#ifndef __GST_TEXTURESINK_H__
#define __GST_TEXTURESINK_H__

#include <gst/gst.h>
#include <gst/video/gstvideosink.h>

G_BEGIN_DECLS


#define GST_TYPE_TEXTURESINK \
  (gst_texturesink_get_type())
#define GST_TEXTURESINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_TEXTURESINK,GstTextureSink))
#define GST_TEXTURESINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_TEXTURESINK,GstTextureSinkClass))
#define GST_IS_TEXTURESINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_TEXTURESINK))
#define GST_IS_TEXTURESINK_CLASS(obj) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_TEXTURESINK))

typedef struct _GstTextureSink GstTextureSink;
typedef struct _GstTextureSinkClass GstTextureSinkClass;

struct _GstTextureSink {
  GstVideoSink videosink;

  guint texture_id, texture_n;	/* first id and number of textures - id space must be continuous */
  guint texture_c; 				/* current offset in texture ids */
  guint video_width, video_height;     /* size of incoming video */
  guint texture_width, texture_height;     /* allocated size of texture */
  GMutex *mutex;
  GCond *texture_ready;
  GCond *texture_consumed;
};

struct _GstTextureSinkClass {
  GstVideoSinkClass parent_class;
};

GType gst_texturesink_get_type(void);

G_END_DECLS

#endif /* __GST_TEXTURESINK_H__ */
