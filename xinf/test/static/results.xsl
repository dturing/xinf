<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="results">
    <html>
        <head>
            <style type="text/css">
                td {
                    padding: 2px 5px 2px 5px;
                }
            </style>
        </head>
        <body>
            <table>
                <xsl:apply-templates/>
            </table>
        </body>
    </html>
  </xsl:template>

  <xsl:template match="info">
        <tr>
            <td></td>
            <td><xsl:value-of select="@test"/></td>
            <td><xsl:value-of select="@platform"/></td>
            <td></td>
            <td><xsl:value-of select="."/></td>
        </tr>
  </xsl:template>

  <xsl:template match="result">
        <tr>
            <td><xsl:value-of select="@nr"/></td>
            <td><xsl:value-of select="@test"/></td>
            <td><xsl:value-of select="@platform"/></td>
            <xsl:call-template name="pass"/>
            <td><xsl:value-of select="."/></td>
        </tr>
  </xsl:template>
  
  <xsl:template name="pass">
        <xsl:choose>
            <xsl:when test="@pass='true'">
                <td style="background:#00aa00; color:#fff; font-weight:bold;">PASS</td>
            </xsl:when>
            <xsl:otherwise>
                <td style="background:#aa0000; color:#fff; font-weight:bold;">FAIL</td>
            </xsl:otherwise>
        </xsl:choose>
  </xsl:template>

</xsl:stylesheet>