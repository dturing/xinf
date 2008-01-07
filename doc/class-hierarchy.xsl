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
	<html><head><title>Xinf API Reference</title>

	<style type="text/css">@import url(content/../xinfapi.css);</style></head><body>

	<script type="text/javascript">
	<!--
		function toggle(id) {
			var e = document.getElementById(id);
			e.isopen = !e.isopen;
			e.style.display = e.isopen?"block":"none";
			return false;
		}
	-->
	</script>

	<div class="document">

	<div class="title">
		<!--<img src="http://xinf.org/img/header.gif"/>-->
		Xinf API Reference
	</div>

	<h1>Class Hierarchy</h1>
	
	<ul>
	<xsl:apply-templates select="*" mode="root">
		<xsl:sort select="@path"/>
	</xsl:apply-templates>
	</ul>

	</div></body></html>
</xsl:template>

<xsl:template match="*[extends]" mode="root"/>
<xsl:template match="class[starts-with(@path,'xinf.')]" mode="root" priority="-1">
	<xsl:apply-templates select="." mode="extends"/>
<!--
	<xsl:variable name="path">
		<xsl:value-of select="@path"/>
	</xsl:variable>
	<li>
		<a href="content/{translate(@path,'.','/')}.html" class="xinf {translate(@path,'.','_')}">
			<xsl:value-of select="@path"/>
		</a>
		<ul>
			<xsl:apply-templates select="/*/*[extends[@path=$path]]" mode="extends"/>
		</ul>
	</li>
	-->
</xsl:template>
<xsl:template match="*" mode="root" priority="-2"/>

<xsl:template match="class" mode="extends">
	<xsl:variable name="name">
		<xsl:call-template name="name-from-path">
			<xsl:with-param name="path" select="@path"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="package">
		<xsl:call-template name="package-from-path">
			<xsl:with-param name="path" select="@path"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="path">
		<xsl:value-of select="@path"/>
	</xsl:variable>
	<li>
		<xsl:text>	</xsl:text>
		<a href="content/{translate(@path,'.','/')}.html" class="xinf {translate($package,'.','_')}">
			<xsl:value-of select="@path"/>
		</a>
		<ul>
			<xsl:apply-templates select="/*/*[extends[@path=$path]]" mode="extends"/>
		</ul>
	</li>
</xsl:template>

<xsl:template name="name-from-path">
	<xsl:param name="path"/>
	<xsl:for-each select="str:split($path,'.')">
		<xsl:choose>
			<xsl:when test="following-sibling::token"/>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template name="package-from-path">
	<xsl:param name="path"/>
	<xsl:param name="separator">.</xsl:param>
	<xsl:for-each select="str:split($path,'.')">
		<xsl:choose>
			<xsl:when test="following-sibling::token[following-sibling::token]">
				<xsl:value-of select="."/>
				<xsl:value-of select="$separator"/>
			</xsl:when>
			<xsl:when test="following-sibling::token">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>

