<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>

		<head>
			<title>Familie {von xml laden}</title>
			<style>
				body {
					font-family: Arial;
					background-color: #FFEEFF:
				}
				ul.tree, ul.tree ul {
					list-style-type: none;
					background: url(vline.png) repeat-y;
					margin: 0; padding: 0;
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
					background: #fff url(lastnode.png) no-repeat;
				}
			</style>
		</head>
		<body>
			<h1>Familie {von xml laden}</h1>
			<h2>Beschreibung</h2>
			<p>Hier kann eine Beschreibung der Familie aus dem XML geladen werden. Sowas wie "Die Windsors stinken immer". Sorry, liebe Queen. :)</p>
			<h2>Stammbaum</h2>
			<ul class="tree">
				<xsl:apply-templates select="family/persons/person">
					<xsl:sort select="@birthDate" />
				</xsl:apply-templates>
			</ul>
		</body>

		</html>
	</xsl:template>
	<xsl:template name="personData">
		<xsl:element name="p">
			<strong><xsl:value-of select="@firstName" /><xsl:text> </xsl:text><xsl:value-of select="@familyName" /><br/></strong>
			<i><xsl:text>*</xsl:text><xsl:value-of select="@birthDate" /></i>
		</xsl:element>
	</xsl:template>
	<xsl:template name="person" match="family/persons/person">
		<!-- Only build tree for oldest familiy member-->
		<xsl:if test="position()=1">
			<li>
				<!-- Display persons data-->
				<xsl:call-template name="personData" />
				<ul>
					 <!-- Iterate over relationships sorted by date of relationship-->
					<xsl:variable name="personId" select="@id" />
					<xsl:for-each select="//relationship[@partner1=$personId or @partner2=$personId]">
						<xsl:sort select="@date"/>
						<xsl:variable name="partnerId">
							<xsl:choose>
								<xsl:when test="@partner1=$personId">
									<xsl:value-of select="@partner2" />
								</xsl:when>
								<xsl:when test="@partner2=$personId">
									<xsl:value-of select="@partner1" />
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<li>
							<!-- Display data of relationship partner -->
							<xsl:for-each select="//person[@id=$partnerId]">
								<xsl:call-template name="personData" />
							</xsl:for-each>
							<ul>
								<!-- Iterate over children of relationship sorted by birth date-->
								<xsl:for-each select="./child">
									<xsl:sort select="//person[@id=current()/@id]/@birthDate" />
									<!-- recursively use person template -->
									<xsl:variable name="childPersonId" select="@id" />
									<xsl:apply-templates select="//person[@id=$childPersonId]" />
								</xsl:for-each>
							</ul>
						</li>
					</xsl:for-each>
				</ul>
			</li>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
