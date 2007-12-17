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
                
                <xsl:for-each select="testrun[position()=1]/result">
                    <xsl:variable name="name"><xsl:value-of select="@test"/></xsl:variable>
                    <tr>
                        <td><xsl:value-of select="@test"/></td>
                        <td>
                            <a href="static/{../@suite}/png/{@test}.png"><img width="40" height="30" style="background:white;" src="static/{../@suite}/png/{@test}.png"/></a>
                            <a href="static/{../@suite}/svg/{@test}.svg">SVG</a>
                        </td>
                        <xsl:for-each select="//testrun">
                            <xsl:choose>
                                <xsl:when test="result/@test=$name">
                                    <xsl:apply-templates select="result[@test=$name]" mode="pass"/>
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

  <xsl:template match="result" mode="pass">
        <xsl:variable name="style">
        <xsl:choose>
            <xsl:when test="@pass='true'">background:#73d216;</xsl:when>
            <xsl:when test="@expect-fail='true'">background:#fce94f;</xsl:when>
            <xsl:otherwise>background:#cc0000; color:#fff; font-weight:bold;</xsl:otherwise>
        </xsl:choose>
        </xsl:variable>

        <xsl:variable name="text">
        <xsl:choose>
            <xsl:when test="@pass='true'">passed</xsl:when>
            <xsl:when test="@expect-fail='true'">exp fail</xsl:when>
            <xsl:otherwise>FAIL</xsl:otherwise>
        </xsl:choose>
        </xsl:variable>

        <td style="{$style}"
            title="{.}">
            <xsl:if test="@image">
                <a href="{@image}"><img width="40" height="30" src="{@image}"></img></a>
                <a href="results/{@test}-{@platform}-diff.png"><img width="40" height="30" src="results/{@test}-{@platform}-diff.png"></img></a>
            </xsl:if>
        </td>
    </xsl:template>

</xsl:stylesheet>