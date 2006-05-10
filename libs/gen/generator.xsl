<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
				
	<xsl:output method="text" indent="no"/>

<xsl:param name="module">FOO</xsl:param>

<xsl:template match="/">
import nekobind.Generator;
import nekobind.CWrapper;
import nekobind.HaxeExtern;
import nekobind.HaxeImpl;

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

<xsl:template match="enum">
    <xsl:apply-templates match="enumitem"/>

    <xsl:text>        gen.typedef("enum </xsl:text>
    <xsl:value-of select="@unnamed"/>
    <xsl:text>","int");
</xsl:text>
</xsl:template>

<xsl:template match="enumitem">
    <xsl:text>        gen.constant("</xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text>","unsigned int","</xsl:text>
    <xsl:choose>
        <xsl:when test="@enumvalue">
            <xsl:value-of select="@enumvalue"/>
        </xsl:when>
        <xsl:when test="@enumvalueex">
            <xsl:value-of select="@enumvalueex"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>0</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>");
</xsl:text>
</xsl:template>

<xsl:template match="cdecl[substring(@decl,1,1)='f']">
    <!-- somehow, the swig xml output doesnt put a ").p" onto pointer return types,
         so we do it here -->
    <xsl:variable name="type">
        <xsl:choose>
            <xsl:when test="contains(@decl,').p')">
                <xsl:text>p.</xsl:text>
                <xsl:value-of select="@type"/>
                <xsl:message>using implicit pointer return type "p.<xsl:value-of select="@type"/>" for func <xsl:value-of select="@name"/> (decl is <xsl:value-of select="@decl"/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@type"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:text>        gen.func("</xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text>","</xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text>", [</xsl:text>
    <xsl:apply-templates select="parmlist/parm" mode="parm"/>
    <xsl:text> ] );
</xsl:text>
</xsl:template>

<xsl:template match="cdecl[@storage='typedef' and parmlist]" priority="2">
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

<xsl:template match="cdecl[@storage='typedef']">
    <xsl:text>        gen.typedef("</xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text>","</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text>");
</xsl:text>
</xsl:template>

<xsl:template match="class">
    <xsl:text>        gen.classDefinition("</xsl:text>
    <xsl:value-of select="@sym_name"/>
    <xsl:text>", [ </xsl:text>
    
    <xsl:for-each select="cdecl">
        <xsl:text>[ "</xsl:text>
            <xsl:value-of select="@sym_name"/>
            <xsl:text>","</xsl:text>
            <xsl:value-of select="@decl"/>
            <xsl:value-of select="@type"/>
        <xsl:text>" ] </xsl:text>
        <xsl:if test="following-sibling::cdecl">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:for-each>
    
    <xsl:text>]);
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
