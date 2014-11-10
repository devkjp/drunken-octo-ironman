<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>

		<head>
			<title>Family Tree</title>
			<style>
				body {
					font-family: Arial;
				}
			</style>
		</head>

		<body>
			<h1>Family Tree</h1>
			<ul>
				<xsl:apply-templates select="family/persons/person">
					<xsl:sort select="@birthDate" />
				</xsl:apply-templates>
			</ul>
		</body>

		</html>
	</xsl:template>
	<xsl:template name="personData">
		<xsl:element name="p">
			<xsl:value-of select="@firstName" /><xsl:text> </xsl:text><xsl:value-of select="@familyName" />	<br/>
			<xsl:value-of select="@birthDate" />
		</xsl:element>
	</xsl:template>
	<xsl:template name="person" match="family/persons/person">
		<xsl:if test="position()=1">
			<li>
				<xsl:call-template name="personData" />
				<ul>
					<xsl:variable name="personId" select="@id" />
					<xsl:for-each select="//relationship[@partner1=$personId]">
						<xsl:variable name="partnerId" select="@partner2" />
						<li>
								<xsl:for-each select="//person[@id=$partnerId]">
									<xsl:call-template name="personData" />
									</xsl:for-each>
							<ul>
								<xsl:for-each select="./child">
									<xsl:variable name="childPersonId" select="@id" />
									<xsl:for-each select="//person[@id=$childPersonId]">
										<xsl:call-template name="person" />
									</xsl:for-each>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:for-each>
					<xsl:for-each select="//relationship[@partner2=$personId]">
						<xsl:variable name="partnerId" select="@partner1" />
						<li>
								<xsl:for-each select="//person[@id=$partnerId]">
									<xsl:call-template name="personData" />
									</xsl:for-each>
							<ul>
								<xsl:for-each select="./child">
									<xsl:variable name="childPersonId" select="@id" />
									<xsl:for-each select="//person[@id=$childPersonId]">
										<xsl:call-template name="person" />
									</xsl:for-each>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:for-each> 
				</ul>
			</li>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>