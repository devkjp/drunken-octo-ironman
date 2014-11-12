<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>

        <head>
            <xsl:element name="title">
                <xsl:value-of select="//family/@name" /></xsl:element>
            <style>
                body {
                    font-family: Arial;
                    background-color: #6A553F;
                }
                div.content {
                    background-color: #D5C0AF;
                    width: 95%;
                    margin: auto;
                    padding: 10px;
                    min-width: 620px;
                    -moz-box-shadow: 1px 1px 5px 6px #3C3228;
                    -webkit-box-shadow: 1px 1px 5px 6px #3C3228;
                    box-shadow: 1px 1px 5px 6px #3C3228;
                }
                div.familytree {
                    padding-left: 20px;
                    min-width: 480;
                }
                h1,
                h2,
                strong {
                    color: #17110D;
                }
                ul.tree,
                ul.tree ul {
                    list-style-type: none;
                    background: url(vline.png) repeat-y;
                    margin: 0;
                    padding: 0;
                }
                ul.tree ul {
                    margin-left: 10px;
                }
                ul.tree li {
                    margin: 0;
                    padding: 0 12px;
                    line-height: 20px;
                    background: url(node.png) no-repeat;
                }
                ul.tree li:last-child {
                    background: #D5C0AF url(lastnode.png) no-repeat;
                }
                span {
                    font-size: 0.9em;
                    font-style: italic;
                    color: #7A3A29;
                }
                hr {
                    width: 100%;
                    color: #7A3A29;
                }
            </style>
        </head>

        <body>
            <div class="content">
                <xsl:element name="h1">
                    <xsl:value-of select="//family/@name" /></xsl:element>
                <h2>Beschreibung</h2>
                <xsl:element name="p">
                    <xsl:value-of select="//family/@description" /></xsl:element>
                <h2>Stammbaum</h2>
                <div class="familytree">
                    <ul class="tree">
                        <xsl:apply-templates select="family/persons/person">
                            <xsl:sort select="@birthDate" />
                        </xsl:apply-templates>
                    </ul>
                </div>
                <hr/>
                <span>Vorlesung Web-Services; Kurs TIT12; Gruppe N: Michael Christa, Dominik Fuchs, Jonas Polkehn</span>
            </div>
        </body>

        </html>
    </xsl:template>
    <xsl:template name="person" match="family/persons/person">
        <xsl:if test="position()=1">
            <li>
                <xsl:call-template name="personData" />
                <xsl:call-template name="relationshipData" />
            </li>
        </xsl:if>
    </xsl:template>
    <xsl:template name="personData">
        <xsl:element name="p">
            <strong>
				<xsl:value-of select="@firstName" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="@familyName" />
				<br/>
			</strong>
            <i>
				<xsl:text>*</xsl:text>
				<xsl:value-of select="@birthDate" />
                <xsl:if test="@dateOfDeath">
                    <xsl:text>  ☨ </xsl:text>
                    <xsl:value-of select="@dateOfDeath" />
                </xsl:if>
			</i>
        </xsl:element>
    </xsl:template>
    <xsl:template name="relationshipData">
        <ul>
            <xsl:variable name="personId" select="@id" />
            <xsl:for-each select="//relationship[@partner1=current()/@id or @partner2=current()/@id]">
                <xsl:sort select="@weddingDay" />
                <xsl:variable name="partnerId" select="./@*[not(.=$personId) and contains(name(.),'partner')]" />
                <li>
                    <xsl:call-template name="relationshipPartnerData">
                        <xsl:with-param name="partnerId" select="$partnerId" />
                    </xsl:call-template>
                    <xsl:if test="./child">
                        <xsl:call-template name="childData" />
                    </xsl:if>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="relationshipPartnerData">
        <xsl:param name="partnerId" />
        <xsl:choose>
            <xsl:when test="@actualState='geschieden'">
                <xsl:element name="span">
                    <!-- Geschieden von:
                    <br/>-->
                    <xsl:text>⚭ </xsl:text><xsl:value-of select="@weddingDay" />
                    <xsl:text> ⚮ </xsl:text><xsl:value-of select="@dissolutionDay" />
                </xsl:element>
            </xsl:when>
            <xsl:when test="@actualState='verheiratet'">
                <xsl:element name="span"><!--Verheiratet mit:
                    <br/>-->
                    <xsl:text>⚭ </xsl:text><xsl:value-of select="@weddingDay" />
                </xsl:element>
            </xsl:when>
            <xsl:when test="@actualState='verwitwet'">
                <xsl:element name="span"><!-- Witwe(r) von:
                    <br/> -->
                    <xsl:text>⚭ </xsl:text><xsl:value-of select="@weddingDay" />
                    <xsl:text> ⚮ </xsl:text><xsl:value-of select="@dissolutionDay" /></xsl:element>
            </xsl:when>
        </xsl:choose>
        <xsl:for-each select="//person[@id=$partnerId]">
            <xsl:call-template name="personData" />
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="childData">
        <xsl:element name="span">Kinder der Beziehung:</xsl:element>
        <ul>
            <xsl:for-each select="./child">
                <xsl:sort select="//person[@id=current()/@id]/@birthDate" />
                <!-- recursively use person template -->
                <xsl:variable name="childPersonId" select="@id" />
                <xsl:apply-templates select="//person[@id=$childPersonId]" />
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>
