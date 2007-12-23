<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="results">
    <html>
        <head>
            <title>xinf test results</title>
            <style type="text/css">
                th, td {
                    padding: 3px 3px 3px 3px;
                    margin: 0;
                    vertical-align: top;
                }
                th {
                    background: #eee;
                    font-weight: normal;
                    text-align: left;
                }
                img {
                    border: 0;
                    margin: 0
                }
            </style>
        </head>
        <body bgcolor="#ddd">
            <table>
                <tr>
                    <th>Test</th>
                    <th>Ref</th>
                    <xsl:for-each select="//testrun">
                        <th title="{@date}"><xsl:value-of select="@platform"/></th>
                    </xsl:for-each>
                </tr>
                
                <xsl:for-each select="testrun[position()=1]/case">
                    <xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
                    <tr>
                        <td><xsl:value-of select="@name"/></td>
                        <td>
                            <a href="static/{../@suite}/png/{@name}.png"><img width="80" height="60" style="background:white;" src="static/{../@suite}/png/{@name}.png"/></a>
                            <!-- <a href="static/{../@suite}/svg/{@name}.svg">SVG</a> -->
                        </td>
                        <xsl:for-each select="//testrun">
                            <xsl:choose>
                                <xsl:when test="case/@name=$name">
                                    <xsl:apply-templates select="case[@name=$name]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td>[no result]</td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </table>
        </body>
    </html>
  </xsl:template>

  <xsl:template match="case">
        <xsl:variable name="style">
        <xsl:choose>
            <xsl:when test="result/@pass='true'">background:#73d216;</xsl:when>
            <xsl:otherwise>background:#cc0000; color:#fff; font-weight:bold;</xsl:otherwise>
        </xsl:choose>
        </xsl:variable>

        <td style="{$style}">
            <a href="results/{@name}-{../@platform}.png"><img width="80" height="60" style="background:white;" src="results/{@name}-{../@platform}.png"/></a>
			<a href="results/{@name}-{../@platform}-diff.png"><img width="80" height="60" style="background:white;" src="results/{@name}-{../@platform}-diff.png"/></a>
			<div><xsl:value-of select="."/></div>
        </td>
    </xsl:template>

</xsl:stylesheet>