<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:output method="html"/>
<xsl:variable name="backgroundPortrait" select="'app_bg_portrait.png'"/>
<xsl:variable name="backgroundLandscape" select="'app_bg_landscape.png'"/>
<xsl:variable name="backToScanButton" select="'app_btn_backtoscan.png'"/>
<xsl:variable name="bigFont" select="'font-family: &quot;AvenirNext-Bold&quot;, sans-serif; font-size: 26;'"/>
<xsl:variable name="normalFont" select="'font-family: &quot;Helvetica-Bold&quot;, sans-serif; font-size: 22;'"/>
<xsl:variable name="smallFont" select="'font-family: &quot;Helvetica-Light&quot;, sans-serif; font-size: 18;'"/>
<xsl:variable name="tinyFont" select="'font-family: &quot;Helvetica-LightOblique&quot;, sans-serif; font-size: 16;'"/>
<xsl:variable name="quoteFont" select="'font-family: &quot;Helvetica-LightOblique&quot;, sans-serif; font-size: 20;'"/>
<xsl:variable name="color1" select="'rgb(255,255,255);'"/>
<xsl:variable name="color2" select="'rgb(73,64,52);'"/>
<xsl:variable name="color3" select="'rgb(180,172,139);'"/>
<xsl:variable name="color4" select="'rgb(180,172,139);'"/>
<xsl:variable name="color5" select="'rgb(180,172,139);'"/>
<xsl:variable name="color6" select="'rgb(246,188,28);'"/>
<xsl:variable name="opacity" select="'0.6'"/>

<xsl:template match="/">
	<html>
	<head>
		<style>
			body {
			<!-- background-image: url("<xsl:value-of select="$backgroundPortrait"/>"); -->
			<!-- background-repeat: no-repeat; -->
			<!-- background-attachment: fixed; -->
            background-color: rgba(0, 0, 0, 0.4);
			<!--padding: 0px;-->
			margin: 0px;
			}
			a:link {
			text-decoration: none;
			}
			a:visited {
			text-decoration: none;
			}
			a:hover {
			text-decoration: none;
			}
			a:active {
			text-decoration: none;
			}
			.title {
			text-align: center;
			color: <xsl:value-of select="$color1"/>;
			<xsl:value-of select="$bigFont"/>
			margin: 50px 0px 30px 0px;
			}	
			.subtitle {
			color: <xsl:value-of select="$color3"/>;
			<xsl:value-of select="$normalFont"/>;
			margin: 20px 20px;
			}
			.paragraph {
			text-align: left;
			color: <xsl:value-of select="$color1"/>;
			<xsl:value-of select="$smallFont"/>;
			margin: 26px 26px;
			text-align: justify;
			white-space: pre-line;
			}	
			.image {
			display: block;
			margin-left: auto;
			margin-right: auto;
			}	
			.comment {
			text-align: left;
			color: <xsl:value-of select="$color1"/>;
			<xsl:value-of select="$smallFont"/>;
			margin: 20px 20px;
			}	
			.source {
			text-align: left;
			color: <xsl:value-of select="$color1"/>;
			<xsl:value-of select="$tinyFont"/>;
			margin: 20px 20px;
			}	
			.citation {
			text-align: left;
			color: <xsl:value-of select="$color1"/>;
			<xsl:value-of select="$quoteFont"/>;
			margin: 50px 50px;
			text-align: justify;
			}
			.subsection {
			<xsl:value-of select="$smallFont"/>;
			border: 1px solid <xsl:value-of select="$color4"/>;
			color: <xsl:value-of select="$color5"/>;
			background: <xsl:value-of select="$color2"/>;
			border-radius: 10px;
			width: 300px;
			text-align: center;
			padding: 15px 15px;
			margin: 10px auto 10px auto;
			}
			.arrow {
			font-family: "AvenirNext-Bold";
			font-size: 80;
			color: <xsl:value-of select="$color5"/>;
			}

		</style>
	</head>
	<body>
	<!-- <div id="container" style="width:768px;">
	<div style="width:130px; height:130px; float:left;">
	<img width="100" style=" display: block; margin: 15px auto auto auto;">
	<xsl:attribute name="src"><xsl:value-of select="$backToScanButton"/></xsl:attribute>
	</img>
	</div>
	<a href="javascript:history.go(-1)">
		<div class="subsection" style="width:60px; float:right; margin: 15px 15px 0px 0px;">Retour</div>
	</a> -->
	<xsl:apply-templates/>
	<!-- </div> -->
	</body>
	</html>
</xsl:template>
	
<xsl:template match="title">
	<div style="border: 1px solid;"><p class="title"><xsl:value-of select="."/></p></div>
</xsl:template>
		
<xsl:template match="subtitle">
	<div style="clear:both"><p class="subtitle">
	<xsl:choose>
	<xsl:when test="location = 'gauche' ">
	</xsl:when>
	<xsl:when test="location = 'droite' ">
		<xsl:attribute name="style">text-align: right;</xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
		<xsl:attribute name="style">text-align: center;</xsl:attribute>
	</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="content"/></p></div>
</xsl:template>
		
<xsl:template match="text/paragraph">
	<div style="clear:both"><p class="paragraph"><xsl:value-of select="."/></p></div>
</xsl:template>
		
<xsl:template match="text/image">
	<div style="width:525px; float:left; padding-top: 10px; padding-bottom: 20px;">
		<xsl:choose>
		<xsl:when test="link">
			<a><xsl:attribute name="href">
				<xsl:value-of select="link"/>
			</xsl:attribute>
			<xsl:apply-templates select="path"/>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="path"/>
		</xsl:otherwise>
		</xsl:choose>
	</div>
    <div style="width:243px; float:left;">
    <p class="comment"><br/><br/><br/><xsl:value-of select="comment"/></p>
    <p class="source"><br/><br/><br/><br/><br/><xsl:value-of select="source"/></p>
   </div>
</xsl:template>

<xsl:template match="text/image/path">
		<img>
    		<xsl:attribute name="src">
    			<xsl:value-of select="."/>
    		</xsl:attribute>
    		<xsl:if test="../linkContour = 'oui' ">
    			<xsl:attribute name="style">
    				border: 5px solid <xsl:value-of select="$color6"/>
    			</xsl:attribute>
    		</xsl:if>
    		<xsl:attribute name="class">
     		  	image
    		</xsl:attribute>
				<xsl:if test="../adjust = 'oui' ">
    				<xsl:attribute name="width">
     		  			470
    				</xsl:attribute>
    			</xsl:if>
     	</img>
</xsl:template>

<xsl:template match="text/citation">
	<p class="citation">« <xsl:value-of select="sentence"/> »</p>
	<p class="title"><xsl:value-of select="author"/></p>
</xsl:template>

<xsl:template match="section/subsection">
	<a>
		<xsl:attribute name="href">
			<xsl:value-of select="file"/>
		</xsl:attribute>
	<div class="subsection">
		<xsl:if test="string-length(name) &gt; 30">
			<xsl:attribute name="style">
				width: 400px;
			</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="name"/>
	</div>
	</a>
</xsl:template>

<xsl:template match="slideshow">
<xsl:apply-templates select="title"/>
<xsl:apply-templates select="subtitle"/>
<div id="ejs_photo_box" style="clear: both; width: 768px;"></div>
<xsl:text disable-output-escaping="yes">
&lt;script language="JavaScript">
   ejs_photo = [];
   ejs_legend = [];</xsl:text>
<xsl:apply-templates select="slide"/>
<xsl:text disable-output-escaping="yes">
	function ejs_aff_photos(num)
	{
		if(document.getElementById)
            {
				ejs_g = "";
				ejs_d = "";
				if(num!=0)
					ejs_g += "&lt;div style='float: left; width: 50px; text-align: right; margin-top: 200px;'>&lt;a href='#' onClick='ejs_aff_photos("+(num-1)+");return(false)'>&lt;span class='arrow'>&lt;&lt;/span>&lt;/a>&lt;/div>";
				if(num==0)
					ejs_g += "&lt;div style='float: left; width: 50px;'>&amp;nbsp;&lt;/div>";
				if(num!=(ejs_photo.length-1))
					ejs_d += "&lt;div style='float: left; text-align: left; margin-top: 200px;'>&lt;a href='#' onClick='ejs_aff_photos("+(num+1)+");return(false)'>&lt;span class='arrow'>&gt;&lt;/span>&lt;/a>&lt;/div>";
				ejs_f = ejs_g+"&lt;div style='float: left; width: 660px;'>&lt;img style='display: block; margin-left: auto; margin-right: auto;' src='"+ejs_photo[num]+"' width='600'/>&lt;div class='paragraph' style='background: rgb(50,50,50); padding: 15px 15px;'>"+ejs_legend[num]+"&lt;/div>&lt;/div>"+ejs_d;
				//console.log(ejs_f);
				document.getElementById("ejs_photo_box").innerHTML =
					ejs_f;
			}
	}
	window.onload = new Function("ejs_aff_photos(0)");
&lt;/script>
</xsl:text>
</xsl:template>

<xsl:template match="slideshow/slide">
<xsl:variable name="apos"><xsl:text>&apos;</xsl:text></xsl:variable>
<xsl:variable name="newline">
	<xsl:text>
</xsl:text>
</xsl:variable>
<xsl:variable name="nl" select="'\n'"/>
<xsl:variable name="comment">
	<xsl:call-template name="replace-substring">
		<xsl:with-param name="original" select="comment"/>
		<xsl:with-param name="substring" select="$newline"/>
		<xsl:with-param name="replacement" select="$nl"/>
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="comment1" select="translate($comment, $apos, '’')"/>
<xsl:text>
	ejs_photo[</xsl:text><xsl:value-of select="position()-1"/><xsl:text>] = '</xsl:text><xsl:value-of select="image"/><xsl:text>';
	ejs_legend[</xsl:text><xsl:value-of select="position()-1"/><xsl:text>] = '</xsl:text><xsl:value-of select="$comment1"/><xsl:text>';
</xsl:text>
</xsl:template>

<xsl:template match="animate">
<xsl:apply-templates select="title"/>
<xsl:apply-templates select="subtitle"/>
<div id="ejs_photo_box" style="clear: both; width: 768px;"></div>
<xsl:text disable-output-escaping="yes">
&lt;script language="JavaScript">
   ejs_photo = [];
   repetition = 'non';</xsl:text>
<xsl:apply-templates select="image"/>
<xsl:apply-templates select="duration"/>
<xsl:apply-templates select="repetition"/>
<xsl:text disable-output-escaping="yes">
	num = -1;
	function ejs_aff_photos()
	{
		num += 1;
		if(document.getElementById)
            {
				ejs_f = "&lt;div style='float: left; width: 760px;'>&lt;img style='display: block; margin-left: auto; margin-right: auto;' src='"+ejs_photo[num]+"' width='600'/>&lt;/div>";
				//console.log(ejs_f);
				document.getElementById("ejs_photo_box").innerHTML =
					ejs_f;
				if(num==(ejs_photo.length-1))
					if (repetition == 'oui')
						num = -1;
					else
						clearInterval(animVar);
			}
	}
	window.onload = new Function("ejs_aff_photos()");
	var animInterval = duration*1000/ejs_photo.length;
	var animVar = window.setInterval(function(){ejs_aff_photos()},animInterval);
&lt;/script>
</xsl:text>
</xsl:template>

<xsl:template match="animate/image">
<xsl:text>
	ejs_photo[</xsl:text><xsl:value-of select="position()-1"/><xsl:text>] = '</xsl:text><xsl:value-of select="."/><xsl:text>';
</xsl:text>
</xsl:template>

<xsl:template match="animate/duration">
<xsl:text>
	duration = </xsl:text><xsl:value-of select="."/><xsl:text>;
</xsl:text>
</xsl:template>

<xsl:template match="animate/repetition">
<xsl:text>
	repetition = '</xsl:text><xsl:value-of select="."/><xsl:text>';
	<!--animRepeat = repetition == 'oui';-->
</xsl:text>
</xsl:template>

<xsl:template name="replace-substring">
	<xsl:param name="original"/>
	<xsl:param name="substring"/>
	<xsl:param name="replacement" select="''"/>
	<xsl:variable name="first">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:value-of select="substring-before($original, $substring)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$original"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="middle">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:value-of select="$replacement"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="last">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:choose>
					<xsl:when test="contains(substring-after($original, $substring),$substring)">
						<xsl:call-template name="replace-substring">
							<xsl:with-param name="original">
								<xsl:value-of select="substring-after($original, $substring)"/>
							</xsl:with-param>
							<xsl:with-param name="substring">
								<xsl:value-of select="$substring"/>
							</xsl:with-param>
							<xsl:with-param name="replacement">
								<xsl:value-of select="$replacement"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-after($original, $substring)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:value-of select="concat($first, $middle, $last)"/>
</xsl:template>

</xsl:stylesheet>