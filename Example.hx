import Xinf;

import Type;

import xinf.ony.PathSegment;

class Example {

	public static function main() {
	
		var t = new Text();
		t.x = 25; t.y = 370;
		t.text = "xinf "+xinf.Version.version+" '"+xinf.Version.tagline+"' r"+xinf.Version.revision+" built "+xinf.Version.built;
		t.style.fill = Color.BLACK;
		Root.attach(t);
	
		var g = new Group();
	
		var r = new Rectangle();
		r.width=r.height=100;
		r.style.fill = Color.BLUE;
		r.transform = new Translate( 25, 25 );
		g.attach(r);

		var c = new Circle();
		c.cx=50; c.cy=50; 
		c.r=50;
		c.style.fill = Color.RED;
		c.transform = new Translate( 150, 25 );
		g.attach(c);

		var p = new Path();
		p.segments = [
			MoveTo( 0, 100 ),
			CubicTo( 0,50, 50,50, 50, 0 ),
			QuadraticTo( 100, 0, 100, 100 ),
			LineTo( 0, 100 ),
		];
		p.style.fill = Color.GREEN;
		p.transform = new Translate( 275, 25 );
		g.attach(p);

		var p = new Polygon();
		p.points = [
			{ x:000., y:050. },
			{ x:050., y:000. },
			{ x:050., y:100. },
			{ x:100., y:050. },
		];
		p.style.stroke = Color.RED;
		p.style.fill = Color.TRANSPARENT;
		p.style.strokeWidth = 4;
		p.transform = new Translate( 25, 150 );
		g.attach(p);

		var l = new Line();
		l.x1 = l.y1 = 0;
		l.x2 = l.y2 = 100;
		l.style.stroke = Color.GREEN;
		l.style.strokeWidth = 4;
		l.transform = new Translate( 150, 150 );
		g.attach(l);

		var e = new Ellipse();
		e.cx = e.cy = 0;
		e.rx = 20; e.ry=70;
		e.style.fill = Color.BLUE;
		e.transform = new Concatenate(
						new Rotate( 45 ),
						new Translate( 275+50, 150+50 ) 
						);
		g.attach(e);
		
		Root.attach(g);
		
		#if neko
		var u = new Use();
		u.peer = g;
		u.transform = new Concatenate(
						new Scale( .3, .3 ),
						new Translate( 25, 275 )
						);
		Root.attach( u );
		#end

		Root.main();
	}
	
}
