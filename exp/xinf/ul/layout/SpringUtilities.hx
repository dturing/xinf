package xinf.ul.layout;

import xinf.ul.Component;
import xinf.ul.Container;
import xinf.ul.layout.SpringLayout;

class SpringUtilities {
    public static function makeGrid( parent:Container,
        cols:Int, rows:Int, xPad:Float, yPad:Float ) {
        var layout = new SpringLayout();
        parent.layout = layout;
        
        var xPadSpring = Spring.constant(xPad);
        var yPadSpring = Spring.constant(yPad);
        var initialXSpring = new LeftSpring(parent);
        var initialYSpring = new TopSpring(parent);
        var max = rows * cols;

        // assure we have enough components
        if( parent.getComponent(max-1) == null ) throw("Grid requires "+rows+"x"+cols+" children to be attached.");

        // Springs for assuring all cells have same size
        var maxWidth = layout.getConstraints(parent.getComponent(0)).getWidth();
        var maxHeight = layout.getConstraints(parent.getComponent(0)).getHeight();
        for( i in 1...max ) {
            var cons = layout.getConstraints( parent.getComponent(i) );
            maxWidth = Spring.max( maxWidth, cons.getWidth() );
            maxHeight = Spring.max( maxHeight, cons.getHeight() );
        }
        for( c in parent.getComponents() ) {
            var cons = layout.getConstraints( c );
            cons.setWidth( maxWidth );
            cons.setHeight( maxHeight );
        }
        
        // Springs for adjusting North/West constraints
        var lastCons:Constraints = null;
        var lastRowCons:Constraints = null;
        var i=0;
        for( c in parent.getComponents() ) {
            var cons = layout.getConstraints( c );
            
            if( i%cols == 0 ) {
                // start of new row
                lastRowCons = lastCons;
                cons.setX( initialXSpring );
            } else {
                // x depends on previous
                cons.setX( Spring.sum( lastCons.getEast(), xPadSpring ) );
            }
            
            if( i/cols < 1.0 ) {
                // first row
                cons.setY( initialYSpring );
            } else {
                cons.setY( Spring.sum( lastRowCons.getSouth(), yPadSpring ) );
            }
            lastCons = cons;
            i++;
        }
        
        // parent's size
        var pCons = layout.getConstraints(parent);
        pCons.setEast( Spring.sum( new RightSpring(parent), lastCons.getEast() ) );
        pCons.setSouth( Spring.sum( new BottomSpring(parent), lastCons.getSouth() ) );
    }

    public static function makeCompactGrid( parent:Container,
        cols:Int, rows:Int, xPad:Float, yPad:Float ) {
        var layout = new SpringLayout();
        parent.layout = layout;
        
        var xPadSpring = Spring.constant(xPad);
        var yPadSpring = Spring.constant(yPad);
        
        // Springs for assuring all cells in a column have same width
        var x:Spring = new LeftSpring(parent);
        for( c in 0...cols ) {
            var width = Spring.constant(0);
            for( r in 0...rows ) {
                var comp = parent.getComponent( (r*cols)+c );
                if( comp==null ) throw("Container does not contain enough components for "+cols+"x"+rows+", only "+parent.children.length );
                var cons = layout.getConstraints( comp );
                width = Spring.max( width,
                        cons.getWidth() );
            }
            for( r in 0...rows ) {
                var comp = parent.getComponent( (r*cols)+c );
                if( comp==null ) throw("Container does not contain enough components for "+cols+"x"+rows );
                var cons = layout.getConstraints( comp );
                cons.setX(x);
                cons.setWidth(width);
            }
            x = Spring.sum( x, Spring.sum( width, xPadSpring ) );
        }

        // Springs for assuring all cells in a row have same height
        var y:Spring = new TopSpring(parent);
        for( r in 0...rows ) {
            var height = Spring.constant(0);
            for( c in 0...cols ) {
                var cons = layout.getConstraints( parent.getComponent( (r*cols)+c ) );
                height = Spring.max( height, cons.getHeight() );
            }
            for( c in 0...cols ) {
                var cons = layout.getConstraints( parent.getComponent( (r*cols)+c ) );
                cons.setY(y);
                cons.setHeight(height);
            }
            y = Spring.sum( y, Spring.sum( height, yPadSpring ) );
        }
        
        // parent's size
        var pCons = layout.getConstraints(parent);
        pCons.setEast( x );
        pCons.setSouth( y );
    }}
