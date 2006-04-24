<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
				
	<xsl:output method="xml" indent="yes"/>

<xsl:template match="attribute">
     <xsl:attribute name="{@name}">
        <xsl:value-of select="@value"/>
     </xsl:attribute>
</xsl:template>
<xsl:template match="attributelist">
    <xsl:apply-templates select="attribute"/>
    <xsl:apply-templates select="parmlist"/>
</xsl:template>

<xsl:template match="*" priority="-1">
    <xsl:copy select=".">
        <xsl:apply-templates select="attributelist"/>
        <xsl:apply-templates select="*[name()!='attributelist']"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
