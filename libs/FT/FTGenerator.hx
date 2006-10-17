
import nekobind.Generator;
import nekobind.CWrapper;
import nekobind.HaxeExtern;
import nekobind.HaxeImpl;

class FTGenerator {
    public static function main() {
        var g = new CWrapper("FT");
        generate(g);
        
        var h = new HaxeExtern("FT");
        generate(h);
        
        var i = new HaxeImpl("FT");
        generate(i);
    }

    public static function generate( gen:Generator ) {
        gen.func("ft_failure_2s","void", [ [ "one","p.q(const).char"],  [ "two","p.q(const).char"] ] );
        gen.func("ft_failure_v","void", [ [ "one","p.q(const).char"],  [ "v","value"] ] );
        gen.func("_font_finalize","void", [ [ "v","value"] ] );
        gen.func("ft_init","void", [ ] );
        gen.func("ftLoadFont","value", [ [ "filename","p.q(const).char"],  [ "include_glyphs","p.q(const).char"],  [ "width","int"],  [ "height","int"] ] );
        gen.func("importGlyphPoints","void", [ [ "points","p.FT_Vector"],  [ "n","int"],  [ "callbacks","value"],  [ "lineTo","field"],  [ "curveTo","field"],  [ "cubic","bool"] ] );
        gen.func("ftIterateGlyphs","value", [ [ "font","value"],  [ "callbacks","value"] ] );

        gen.finish();
    }
}

