%module GdkPixbuf

void g_type_init();
typedef bool gboolean;

typedef enum {
	GDK_COLORSPACE_RGB
} GdkColorspace;

struct GdkPixbuf {
};

typedef enum {
        /* image data hosed */
        GDK_PIXBUF_ERROR_CORRUPT_IMAGE,
        /* no mem to load image */
        GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY,
        /* bad option passed to save routine */
        GDK_PIXBUF_ERROR_BAD_OPTION,
        /* unsupported image type (sort of an ENOSYS) */
        GDK_PIXBUF_ERROR_UNKNOWN_TYPE,
        /* unsupported operation (load, save) for image type */
        GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION,
        GDK_PIXBUF_ERROR_FAILED
} GdkPixbufError;


void       gdk_pixbuf_unref    (GdkPixbuf *pixbuf);

GdkColorspace gdk_pixbuf_get_colorspace      (const GdkPixbuf *pixbuf);
int           gdk_pixbuf_get_n_channels      (const GdkPixbuf *pixbuf);
gboolean      gdk_pixbuf_get_has_alpha       (const GdkPixbuf *pixbuf);
int           gdk_pixbuf_get_bits_per_sample (const GdkPixbuf *pixbuf);
guchar       *gdk_pixbuf_get_pixels          (const GdkPixbuf *pixbuf);
int           gdk_pixbuf_get_width           (const GdkPixbuf *pixbuf);
int           gdk_pixbuf_get_height          (const GdkPixbuf *pixbuf);
int           gdk_pixbuf_get_rowstride       (const GdkPixbuf *pixbuf);

GdkPixbuf *gdk_pixbuf_new (GdkColorspace colorspace, gboolean has_alpha, int bits_per_sample,
			   int width, int height);
GdkPixbuf *gdk_pixbuf_copy (const GdkPixbuf *pixbuf);
GdkPixbuf *gdk_pixbuf_new_subpixbuf (GdkPixbuf *src_pixbuf,
                                     int        src_x,
                                     int        src_y,
                                     int        width,
                                     int        height);

GdkPixbuf *gdk_pixbuf_new_from_file (const char *filename,
                                     GError    **error);
GdkPixbuf *gdk_pixbuf_new_from_file_at_size (const char *filename,
					     int         width, 
					     int         height,
					     GError    **error);
GdkPixbuf *gdk_pixbuf_new_from_file_at_scale (const char *filename,
					      int         width, 
					      int         height,
					      gboolean    preserve_aspect_ratio,
					      GError    **error);

GdkPixbuf *gdk_pixbuf_new_from_data (const guchar *data,
				     GdkColorspace colorspace,
				     gboolean has_alpha,
				     int bits_per_sample,
				     int width, int height,
				     int rowstride,
				     GdkPixbufDestroyNotify destroy_fn,
				     gpointer destroy_fn_data);

GdkPixbuf *gdk_pixbuf_new_from_xpm_data (const char **data);
GdkPixbuf* gdk_pixbuf_new_from_inline	(gint          data_length,
					 const guint8 *data,
					 gboolean      copy_pixels,
					 GError      **error);
       
	   
/* Mutations */
void       gdk_pixbuf_fill              (GdkPixbuf    *pixbuf,
                                         guint32       pixel);


/** GdkPixbufLoader **/
/* signals are not handled--
    this is just good for decoding images from data that is already in memory,
    not in a file... */
GdkPixbufLoader *gdk_pixbuf_loader_new();
GdkPixbufLoader *gdk_pixbuf_loader_new_with_type( const char *image_type, GError **error );
GdkPixbufLoader *gdk_pixbuf_loader_new_with_mime_type( const char *mime_type, GError **error );
gboolean gdk_pixbuf_loader_write( GdkPixbufLoader *loader, unsigned char *buf, int count, GError **error );
gboolean gdk_pixbuf_loader_close( GdkPixbufLoader *loader, GError **error );
GdkPixbuf *gdk_pixbuf_loader_get_pixbuf( GdkPixbufLoader *loader );

%include <GdkPixbuf.runtime>
