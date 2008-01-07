<?xml version="1.0"?>
<xsl:stylesheet	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'
	xmlns:str="http://exslt.org/strings"
	>

<!-- quick rundown of haxe xml output:

	<haxe>
		<class path="mypackage.MyClass" params="T" file="./path/to/Source.hx>
			<myFunction public="1" line="xx">
				<f a="string">
			</myFunction>
			<my
		</class>
		<enum path="package.SampleEnum>
		<typedef>
	</haxe>

-->

<xsl:template match="haxe">
	<html><body><ul>
	<xsl:apply-templates select="*" mode="root">
		<xsl:sort select="@path"/>
	</xsl:apply-templates>
	</ul></body></html>
</xsl:template>

<xsl:template match="*[extends]" mode="root"/>
<xsl:template match="*[starts-with(@path,'xinf.')]" mode="root" priority="-1">
	<xsl:variable name="path">
		<xsl:value-of select="@path"/>
	</xsl:variable>
	<li>
		<xsl:value-of select="@path"/>
		<ul>
			<xsl:apply-templates select="/*/*[extends[@path=$path]]" mode="extends"/>
		</ul>
	</li>
</xsl:template>
<xsl:template match="*" mode="root" priority="-2"/>

<xsl:template match="*" mode="extends">
	<xsl:variable name="path">
		<xsl:value-of select="@path"/>
	</xsl:variable>
	<li>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="@path"/>
		<ul>
			<xsl:apply-templates select="/*/*[extends[@path=$path]]" mode="extends"/>
		</ul>
	</li>
</xsl:template>

</xsl:stylesheet>

