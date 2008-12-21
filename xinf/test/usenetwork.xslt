<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
	<xsl:template match="@useNetwork" priority="-1">
		<xsl:attribute name="useNetwork">1</xsl:attribute>
	</xsl:template>
	<xsl:template match="*|@*|text()" priority="-1">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>

