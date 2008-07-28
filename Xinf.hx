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
typedef Node = xinf.xml.Node

typedef Root = xinf.ony.Root

#if xinfony_null
typedef Svg = xinf.ony.Svg
typedef Element = xinf.ony.Element
typedef Group = xinf.ony.Group
typedef Rectangle = xinf.ony.Rectangle
typedef Ellipse = xinf.ony.Ellipse
typedef Circle = xinf.ony.Circle
typedef Image = xinf.ony.Image
typedef Path = xinf.ony.Path
typedef Line = xinf.ony.Line
typedef Polygon = xinf.ony.Polygon
typedef Polyline = xinf.ony.Polyline
typedef Text = xinf.ony.Text
typedef TextArea = xinf.ony.TextArea
typedef Use = xinf.ony.Use
typedef Definitions = xinf.ony.Definitions
typedef Link = xinf.ony.Link

typedef Crop = xinf.ony.Crop

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
