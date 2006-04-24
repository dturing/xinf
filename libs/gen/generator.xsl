<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
				
	<xsl:output method="text" indent="no"/>

<xsl:param name="module">FOO</xsl:param>

<xsl:template match="/">
import nekogen.Generator;
import nekogen.CWrapper;
import nekogen.HaxeExtern;
import nekogen.HaxeImpl;

class <xsl:value-of select="$module"/>Generator {
    public static function main() {
        var g = new CWrapper("<xsl:value-of select="$module"/>");
        generate(g);
        
        var h = new HaxeExtern("<xsl:value-of select="$module"/>");
        generate(h);
        
        var i = new HaxeImpl("<xsl:value-of select="$module"/>");
        generate(i);
    }

    public static function generate( gen:Generator ) {
<xsl:apply-templates/>
        gen.finish();
    }
}

</xsl:template>

<xsl:template match="constant">
    <xsl:text>        gen.constant("</xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text>","</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text>","</xsl:text>
    <xsl:value-of select="@value"/>
    <xsl:text>");
</xsl:text>
</xsl:template>

<xsl:template match="cdecl[@kind='function']">
    <xsl:text>        gen.func("</xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text>","</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text>", [</xsl:text>
    <xsl:apply-templates select="parmlist/parm" mode="parm"/>
    <xsl:text> ] );
</xsl:text>
</xsl:template>

<xsl:template match="cdecl[@kind='typedef' and parmlist]" priority="2">
<!--
    <xsl:text>FUNC_TYPE </xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="parmlist/parm" mode="parm"/>
    <xsl:text>
</xsl:text>
-->
</xsl:template>

<xsl:template match="cdecl[@kind='typedef']">
    <xsl:text>        gen.typedef("</xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text>","</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text>");
</xsl:text>
</xsl:template>

<xsl:template match="cdecl" priority="-1">
<!--
    <xsl:text>UNKNOWN </xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@kind"/>
    <xsl:text>
</xsl:text>
-->
</xsl:template>


<xsl:template match="parm" mode="parm">
    <xsl:if test="@name">
        <xsl:text> [ "</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>","</xsl:text>
        <xsl:value-of select="@type"/>
        <xsl:text>"]</xsl:text>

        <xsl:if test="following-sibling::parm">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="*" priority="-1">
    <xsl:copy select=".">
        <xsl:apply-templates select="*"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
