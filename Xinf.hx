/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import xinf.geom.Types;

typedef TPoint = xinf.geom.TPoint

typedef Translate = xinf.geom.Translate
typedef Identity = xinf.geom.Identity
typedef Scale = xinf.geom.Scale
typedef Rotate = xinf.geom.Rotate
typedef Concatenate = xinf.geom.Concatenate
typedef Matrix = xinf.geom.Matrix
typedef Transform = xinf.geom.TransformList
typedef TransformList = xinf.geom.TransformList

typedef MouseEvent = xinf.event.MouseEvent
typedef KeyboardEvent = xinf.event.KeyboardEvent
typedef FrameEvent = xinf.event.FrameEvent
typedef GeometryEvent = xinf.event.GeometryEvent
typedef SimpleEvent = xinf.event.SimpleEvent
typedef ScrollEvent = xinf.event.ScrollEvent
typedef UIEvent = xinf.event.UIEvent
typedef LinkEvent = xinf.event.LinkEvent

typedef Document = xinf.xml.Document

typedef Root = xinf.ony.Root

#if xinfony_null
typedef Svg = xinf.ony.null.Svg
typedef Element = xinf.ony.null.Element
typedef Group = xinf.ony.null.Group
typedef Rectangle = xinf.ony.null.Rectangle
typedef Ellipse = xinf.ony.null.Ellipse
typedef Circle = xinf.ony.null.Circle
typedef Image = xinf.ony.null.Image
typedef Path = xinf.ony.null.Path
typedef Line = xinf.ony.null.Line
typedef Polygon = xinf.ony.null.Polygon
typedef Polyline = xinf.ony.null.Polyline
typedef Text = xinf.ony.null.Text
typedef TextArea = xinf.ony.null.TextArea
typedef Use = xinf.ony.null.Use
typedef Definitions = xinf.ony.null.Definitions
typedef Crop = xinf.ony.null.Crop

typedef Link = xinf.ony.Link

//tmp, for doc
typedef Binding = xinf.xml.Binding;

#else
typedef Svg = xinf.ony.erno.Svg
typedef Element = xinf.ony.erno.Element
typedef Group = xinf.ony.erno.Group
typedef Rectangle = xinf.ony.erno.Rectangle
typedef Ellipse = xinf.ony.erno.Ellipse
typedef Circle = xinf.ony.erno.Circle
typedef Image = xinf.ony.erno.Image
typedef Path = xinf.ony.erno.Path
typedef Line = xinf.ony.erno.Line
typedef Polygon = xinf.ony.erno.Polygon
typedef Polyline = xinf.ony.erno.Polyline
typedef Text = xinf.ony.erno.Text
typedef TextArea = xinf.ony.erno.EditableTextArea
typedef Use = xinf.ony.erno.Use
typedef Definitions = xinf.ony.erno.Definitions
typedef Link = xinf.ony.Link

typedef Crop = xinf.ony.erno.Crop
#end

typedef TraitAccess = xinf.traits.TraitAccess
typedef FloatTrait = xinf.traits.FloatTrait
typedef IntTrait = xinf.traits.IntTrait
typedef StringTrait = xinf.traits.StringTrait
typedef LengthTrait = xinf.ony.traits.LengthTrait

typedef Length = xinf.ony.type.Length
typedef Paint = xinf.ony.type.Paint
typedef PreserveAspectRatio = xinf.ony.type.PreserveAspectRatio
typedef TextAnchor = xinf.ony.type.TextAnchor
typedef Display = xinf.ony.type.Display
typedef Visibility = xinf.ony.type.Visibility

