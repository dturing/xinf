<?xml version="1.0"?>
<xsl:stylesheet	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'
	xmlns:str="http://exslt.org/strings"
	>

<xsl:template match="root">
			<div id="master_index">
				<ul>
					<xsl:apply-templates select="package[@path='xinf']/package">
						<xsl:sort select="@path"/>
					</xsl:apply-templates>
				</ul>
			</div>
</xsl:template>

<xsl:template match="package[@path='xinf.support']"/>
<xsl:template match="package[@path='xinf.inity']"/>
<xsl:template match="package[@path='xinf.test']"/>
<xsl:template match="package[@path='xinf.ony._Path']"/>
<xsl:template match="package[@path='xinf.ony._PathParser']"/>

<xsl:template match="package">
	<xsl:variable name="package">
		<xsl:value-of select="translate(@path,'.','_')"/>
	</xsl:variable>
	
	<li class="xinf {$package}">
		<a href="#" class="package" onclick="return toggle('index-{$package}')">
			<xsl:value-of select="@name"/>
		</a>
		<span class="package">
			<ul id="index-{$package}">
				<xsl:apply-templates select="package">
					<xsl:sort select="@path"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="class|enum|typedef">
					<xsl:sort select="@path"/>
				</xsl:apply-templates>
			</ul>
		</span>
	</li>
</xsl:template>


<xsl:template match="class|enum|typedef">
	<li>
		<a href="$baseUrl${translate(@path,'.','/')}.html">
			<xsl:for-each select="str:split(@path,'.')">
				<xsl:choose>
					<xsl:when test="following-sibling::token"/>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</a>
	</li>
</xsl:template>

</xsl:stylesheet>

