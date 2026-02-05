 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValBulkConfig
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '2E56B172-3BA2-48CA-9598-DAB3574970E0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValBulkConfig ON; 
 
        INSERT INTO TValBulkConfig([ValBulkConfigId], [RefProdProviderId], [MatchingCriteria], [DownloadDay], [DownloadTime], [ProcessDay], [ProcessTime], [ProviderFileDateOffset], [URL], [RequestXSL], [FieldNames], [TransformXSL], [Protocol], [SupportedService], [SupportedFileTypeId], [SupportedDelimiter], [ConcurrencyId])
        SELECT 1,558, '|2|', 'monday', '10:00', 'monday', '18:30',-3, 'https://data.cofunds.co.uk/data', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
       <xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
       <xsl:param name="url"/>
       <xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
       <xsl:param name="processDate">20070101</xsl:param>
       <xsl:template match="/">
              <xsl:element name="requestdata">
                     <xsl:variable name="protocol" select="msxsl:node-set($selectedNode)/@Protocol"/>
                     <xsl:variable name="supportedService" select="msxsl:node-set($selectedNode)/@SupportedService"/>
                     <xsl:variable name="supportedFileType" select="msxsl:node-set($selectedNode)/@SupportedFileType"/>
                     <xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
                     <xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
                     <xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
                     <xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
                     <xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
                     <xsl:variable name="fileName">
                           <xsl:text><![CDATA[l1_]]></xsl:text>
                           <xsl:value-of select="$usernameForURL"/>
                           <xsl:text><![CDATA[_]]></xsl:text>
                           <xsl:value-of select="$processDate"/>
                           <xsl:text><![CDATA[_who.txt]]></xsl:text>
                     </xsl:variable>
                     <xsl:variable name="saveDownloadFileAs">
                           <xsl:text><![CDATA[SV_]]></xsl:text>
                           <xsl:value-of select="$indigoClientId"/>
                           <xsl:text><![CDATA[_]]></xsl:text>
                           <xsl:value-of select="$valScheduleItemId"/>
                           <xsl:text><![CDATA[_]]></xsl:text>
                           <xsl:value-of select="$processDate"/>
                           <xsl:text><![CDATA[.txt]]></xsl:text>
                     </xsl:variable>
                     <xsl:variable name="generateUrl">
                           <xsl:value-of select="$url"/>
                           <xsl:text><![CDATA[/]]></xsl:text>
                           <xsl:value-of select="$usernameForURL"/>
                           <xsl:text><![CDATA[/]]></xsl:text>
                           <xsl:value-of select="$fileName"/>
                     </xsl:variable>
                     <xsl:element name="fileName">
                           <xsl:value-of select="$fileName"/>
                     </xsl:element>
                     <xsl:element name="saveDownloadFileAs">
                           <xsl:value-of select="$saveDownloadFileAs"/>
                     </xsl:element>
                     <xsl:element name="url">
                           <xsl:value-of select="$generateUrl"/>
                     </xsl:element>
                     <xsl:element name="httpMethodName">
                           <xsl:text>GET</xsl:text>
                     </xsl:element>
                     <xsl:element name="httpHeaderParams">
                           <xsl:text>Content-Type=text/html</xsl:text>
                     </xsl:element>
                     <xsl:element name="msg"/>
                     <xsl:element name="username">
                           <xsl:value-of select="$usernameForFileAccess"/>
                     </xsl:element>
                     <xsl:element name="password">
                           <xsl:value-of select="$passwordForFileAccess"/>
                     </xsl:element>
                     <xsl:element name="protocol">
                           <xsl:value-of select="$protocol"/>
                     </xsl:element>
                     <xsl:element name="supportedService">
                           <xsl:value-of select="$supportedService"/>
                     </xsl:element>
                     <xsl:element name="supportedFileType">
                           <xsl:value-of select="$supportedFileType"/>
                     </xsl:element>
              </xsl:element>
       </xsl:template>
</xsl:stylesheet>', 'zzIGNOREzz|PortfolioId|PortfolioType|zzIGNOREzz|MEXId|FundName|HoldingId|Quantity|EffectiveDate|zzIGNOREzz|CustomerReference|zzIGNOREzz|Title|zzIGNOREzz|CustomerFirstName|CustomerLastName|CustomerDoB|CustomerNINumber|ClientAddressLine1|ClientAddressLine2|ClientAddressLine3|ClientAddressLine4|ClientPostCode|zzIGNOREzz|AdviserReference|AdviserFirstName|AdviserLastName|AdviserCompanyName|zzIGNOREzz|Price|PriceDate|HoldingValue|Currency|CustomerSubType|Designation|AdviserOfficePostCode|FundProviderName|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|PortfolioReference|ISIN|SEDOL|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|WorkInProgressIndicator|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz', '', 'https',83,20, '|',11 UNION ALL 
        SELECT 23,941, NULL, NULL, '15:00', NULL, NULL,0, NULL, NULL, NULL, NULL, 'soap',19,0, NULL,4 UNION ALL 
        SELECT 27,2640, '18', NULL, NULL, NULL, NULL,0, 'clientftp.bnymellon.com', NULL, NULL, NULL, 'sftp',19,0, NULL,2 UNION ALL 
        SELECT 28,576, NULL, NULL, NULL, NULL, NULL,0, 'https://user.transact-online.co.uk/Login/TOL_RemoteService.cfm', NULL, NULL, NULL, 'https',19,0, NULL,3 UNION ALL 
        SELECT 29,2377, '16', NULL, NULL, NULL, NULL,0, 'gw.hubwise.co.uk', NULL, NULL, NULL, 'sftp',19,0, NULL,3 UNION ALL 
        SELECT 30,181, '16', NULL, NULL, NULL, NULL,0, 'ftp.jbrearley.co.uk', NULL, NULL, NULL, 'sftp',19,0, NULL,2 UNION ALL 
        SELECT 31,1984, '16', NULL, NULL, NULL, NULL,0, 'sftp.praemium.co.uk', NULL, NULL, NULL, 'sftp',19,0, NULL,2 UNION ALL 
        SELECT 32,2334, '16', NULL, NULL, NULL, NULL,0, 'moveitdmz-non443.zurich.com', NULL, NULL, NULL, 'https',31,0, NULL,4 UNION ALL 
        SELECT 33,1796, '16', NULL, NULL, NULL, NULL,0, 'webservice', NULL, NULL, NULL, 'https',19,0, NULL,2 UNION ALL 
        SELECT 34,2825, '16', NULL, NULL, NULL, NULL,0, 'moveitdmz-non443.zurich.com', NULL, NULL, NULL, 'https',19,0, NULL,3 UNION ALL 
        SELECT 35,2604, '16', NULL, NULL, NULL, NULL,0, 'cssftpi.charles-stanley.co.uk', NULL, NULL, NULL, 'sftp',19,0, NULL,2 UNION ALL 
        SELECT 36,3070, '16', NULL, NULL, NULL, NULL,0, 'https://data.cofunds.co.uk/data', NULL, NULL, NULL, 'https',19,0, NULL,2 UNION ALL 
        SELECT 37,2610, NULL, NULL, NULL, NULL, NULL,0, 'pl032sftpv.fnz.net', NULL, NULL, NULL, 'sftp',31,0, NULL,4 UNION ALL 
        SELECT 3,1543, '|6|', 'saturday', '13:00', 'saturday', '19:15',0, '46.28.250.71', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="translate($usernameForFileAccess,&quot;abcdefghijklmnopqrstuvwxyz&quot;,&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 1024 5a:e0:57:44:a7:8c:a6:65:97:31:78:f3:7c:82:08:9c</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PortfolioReference|zzzIGNOREzzz|CustomerFirstName|CustomerLastName|zzzIGNOREzzz|CustomerDoB|CustomerNINumber|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|ClientPostCode|zzzIGNOREzzz|AdviserFirstName|AdviserLastName|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|PortfolioType|zzzIGNOREzzz|FundName|ISIN|MEXId|SEDOL|Quantity|EffectiveDate|Price|PriceDate|HoldingValue|Currency', '', 'sftp',19,20, '|',6 UNION ALL 
        SELECT 4,1405, '|6|', '', '', '', '19:00',0, 'rest', '<?xml version="1.0" encoding="UTF-8"?>
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	  <xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	  <xsl:param name="url"/>
	  <xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	  <xsl:param name="processDate">20070101</xsl:param>
	  <xsl:template match="/">
		<xsl:element name="requestdata">
		  <xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
		  <xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
		  <xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
		  <xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
		  <xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
		  <xsl:variable name="fileName">
			<xsl:value-of select="substring-before($usernameForURL, ''_'')"/>
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$processDate"/>
			<xsl:text>.csv</xsl:text>
		  </xsl:variable>
		  <xsl:variable name="saveDownloadFileAs">
			<xsl:value-of select="$indigoClientId"/>
			<xsl:text>\</xsl:text>
			<xsl:text>SV_</xsl:text>
			<xsl:value-of select="$indigoClientId"/>
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$valScheduleItemId"/>
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$processDate"/>
			<xsl:text>.txt</xsl:text>
		  </xsl:variable>
		  <xsl:variable name="generateUrl">
			<xsl:value-of select="$url"/>
		  </xsl:variable>
		  <xsl:element name="fileName">
			<xsl:value-of select="$fileName"/>
		  </xsl:element>
		  <xsl:element name="saveDownloadFileAs">
			<xsl:value-of select="$saveDownloadFileAs"/>
		  </xsl:element>
		  <xsl:element name="url">
			<xsl:value-of select="$generateUrl"/>
		  </xsl:element>
		  <xsl:element name="msg"/>
		  <xsl:element name="username">
			<xsl:value-of select="$usernameForFileAccess"/>
		  </xsl:element>
		  <xsl:element name="password">
			<xsl:value-of select="$passwordForFileAccess"/>
		  </xsl:element>
		</xsl:element>
	  </xsl:template>
	</xsl:stylesheet>', 'CustomerReference|PortfolioReference|PortfolioType|EffectiveDate__PriceDate|ISIN|FundName|Price|Quantity|HoldingValue|Currency|zzzIGNOREzzz|AdviserLastName|CustomerLastName|ClientPostCode', '', 'rest',19,20, '|',6 UNION ALL 
        SELECT 5,1555, '|8|', 'monday', '09:00', 'monday', '20:00',0, '89.250.39.1', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>Investment_Cash_Holdings_Consolidated.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-dss 1024 da:04:3e:63:6d:7b:cd:be:a7:95:a1:84:ea:6c:e0:62</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PortfolioReference|PortfolioType|EffectiveDate|Sedol|MEXId|EpicCode|CitiCode|FundName|Price|Quantity|HoldingValue|AdviserLastName|CustomerLastName|ClientPostCode|ISIN|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|AccountReference|zzzIGNOREzzz|GBPBalance|Currency|ForeignBalance|AvailableCash|AccountName', '', 'sftp',19,20, '|',3 UNION ALL 
        SELECT 8,1019, '|9|', '', '', '', '19:00',0, '', '<?xml version="1.0" encoding="UTF-8"?>
		<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		  <xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
		  <xsl:param name="url"/>
		  <xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
		  <xsl:param name="processDate">20070101</xsl:param>
		  <xsl:template match="/">
			<xsl:element name="requestdata">
			  <xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			  <xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			  <xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			  <xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			  <xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			  <xsl:variable name="fileName">
				<xsl:text>Investment_Cash_Holdings_Consolidated.txt</xsl:text>
			  </xsl:variable>
			  <xsl:variable name="saveDownloadFileAs">
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>\</xsl:text>
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			  </xsl:variable>
			  <xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			  </xsl:variable>
			  <xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			  </xsl:element>
			  <xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			  </xsl:element>
			  <xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			  </xsl:element>
			  <xsl:element name="msg"/>
			  <xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			  </xsl:element>
  			  <xsl:element name="fingerprint">
				<xsl:text>ssh-dss 1024 da:04:3e:63:6d:7b:cd:be:a7:95:a1:84:ea:6c:e0:62</xsl:text>
			  </xsl:element>
			  <xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			  </xsl:element>
			</xsl:element>
		  </xsl:template>
		</xsl:stylesheet>', '', '
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" encoding="UTF-8" />
	<xsl:param name="TargetColumnSeparator" >|</xsl:param>
	<xsl:template match="/BulkValuation">
		<xsl:for-each select="Record">
			<xsl:call-template name="output-tokens">
				<xsl:with-param name="columnlist">
	CustomerReference|PortfolioReference|PortfolioType|SubPlanReference|SubPlanType|EffectiveDate|SEDOL|FundName|Price|Quantity|HoldingValue|AdvisorFirstName|AdviserLastName|CustomerFirstName|CustomerLastName|CustomerDoB|ClientPostCode|CustomerNINumber|GBPBalance|Currency|AvailableCash|AccountName|AccountReference|PriceDate|
					</xsl:with-param>
			</xsl:call-template>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="output-tokens">
		<xsl:param name="columnlist"/>
		<xsl:variable name="newlist" select="concat(normalize-space($columnlist), '' '')"/>
		<xsl:variable name="first" select="substring-before($newlist, ''|'')"/>
		<xsl:variable name="remaining" select="substring-after($newlist, ''|'')"/>
		<xsl:value-of select="*[local-name() = $first]"/>
		<xsl:if test="$remaining">
			<xsl:if test="string-length($remaining)  &gt; 1">
				<xsl:value-of select="$TargetColumnSeparator"></xsl:value-of>			
			</xsl:if>
			<xsl:call-template name="output-tokens">
				<xsl:with-param name="columnlist" select="$remaining"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>', 'sftp',35,13, '|',2 UNION ALL 
        SELECT 17,2288, '|6|', 'saturday', '14:30:00', 'sunday', '10:00',0, '193.130.113.235:2055', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="$usernameForFileAccess"/>
				<xsl:text>_valuation_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 2048 23:d8:85:15:93:4a:de:fa:87:d9:52:c5:b3:44:a0:12</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'PlanReference|PriceDate|Sedol|FundName|Price|Quantity|HoldingValue|Currency|CustomerFirstName|PlanType|CustomerDoB|CustomerNINumber', '', 'sftp',19,20, '|',3 UNION ALL 
        SELECT 12,2438, '|15|', 'saturday', '15:00', 'saturday', '21:45',0, 'pl014sftpv.fnz.net', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="clientFSA">
					<xsl:choose>
						<xsl:when test="msxsl:node-set($selectedNode)/@GroupFSA != &quot;&quot; " >
							<xsl:value-of select="msxsl:node-set($selectedNode)/@GroupFSA"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="msxsl:node-set($selectedNode)/@IndigoClientFSA"/>						
						</xsl:otherwise>
					</xsl:choose>
			</xsl:variable>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>valuations/</xsl:text>
				<xsl:value-of select="$clientFSA"/>
				<xsl:text>.csv</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:text>GBIntelFTP</xsl:text>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 2048 5f:99:80:e1:36:cc:60:3d:11:c1:4b:bc:1f:6b:21:a1</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:text>disPute5</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', '', '', 'sftp',23,20, '|',15 UNION ALL 
        SELECT 13,2247, '|6|', 'sunday', '06:30:00', 'sunday', '19:30',0, 'ftp.wealthtime.co.uk', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="$usernameForFileAccess"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 2048 a2:65:4c:81:1c:3b:a4:50:4a:35:36:43:50:6b:d6:6d</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PlanReference|PlanType|PriceDate|Sedol|ISIN|FundName|Price|Quantity|HoldingValue|Currency|AdviserFirstName|AdviserLastName|CustomerFirstName|CustomerLastName|CustomerDoB|CustomerNINumber', '', 'sftp',19,20, '|',7 UNION ALL 
        SELECT 15,2313, '|6|', 'saturday', '15:30:00', 'sunday', '13:00',0, 'sftp.rowan-dartington.co.uk', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="$usernameForFileAccess"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 1024 c4:12:83:84:1b:89:d0:3a:15:4a:46:f2:5e:36:9a:d7</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PlanReference|PlanType|PriceDate|ISIN|FundName|Price|Quantity|HoldingValue|Currency|AdviserFirstName|AdviserLastName|CustomerFirstName|CustomerLastName|CustomerDoB|ClientPostCode|CustomerNINumber', '', 'sftp',19,20, '|',7 UNION ALL 
        SELECT 9,878, '|10|', 'sunday', '14:30', 'sunday', '20:30',-2, 'sftp.brooksmacdonald.com:2222', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="$usernameForFileAccess"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.csv</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 2048 8b:dc:f3:d2:f0:fc:c6:54:9f:86:c4:31:a3:ab:79:c6</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PortfolioReference|FundName|ISIN|zzzIGNOREzzz|Currency|zzzIGNOREzzz|Quantity|Price|zzzIGNOREzzz|EffectiveDate|HoldingValue|zzzIGNOREzzz|zzzIGNOREzzz|CustomerFirstName|CustomerLastName|CustomerDoB|CustomerNINumber|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|zzzIGNOREzzz|PortfolioType', '', 'sftp',19,20, '||',13 UNION ALL 
        SELECT 19,2215, '|6|', 'saturday', '13:30:00', 'saturday', '21:00',0, 'peftp7.fnzc.co.uk', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
  <xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
  <xsl:param name="url"/>
  <xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
  <xsl:param name="processDate">20070101</xsl:param>
  <xsl:template match="/">
    <xsl:element name="requestdata">
      <xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
      <xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
      <xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
      <xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
      <xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
      <xsl:variable name="fileName">
        <xsl:text>&#42;_</xsl:text>
        <xsl:value-of select="$processDate"/>
        <xsl:text>.xml</xsl:text>
      </xsl:variable>
      <xsl:variable name="saveDownloadFileAs">
        <xsl:text>SV_</xsl:text>
        <xsl:value-of select="$indigoClientId"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$valScheduleItemId"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$processDate"/>
        <xsl:text>.txt&#42;</xsl:text>
      </xsl:variable>
      <xsl:variable name="generateUrl">
        <xsl:value-of select="$url"/>
      </xsl:variable>
      <xsl:element name="fileName">
        <xsl:value-of select="$fileName"/>
      </xsl:element>
      <xsl:element name="saveDownloadFileAs">
        <xsl:value-of select="$saveDownloadFileAs"/>
      </xsl:element>
      <xsl:element name="url">
        <xsl:value-of select="$generateUrl"/>
      </xsl:element>
      <xsl:element name="msg"/>
      <xsl:element name="username">
        <xsl:value-of select="$usernameForFileAccess"/>
      </xsl:element>
      <xsl:element name="fingerprint">
        <xsl:text>ssh-rsa 2048 59:39:25:55:34:b6:b0:d8:c8:3f:76:66:ed:85:93:da</xsl:text>
      </xsl:element>
      <xsl:element name="password">
        <xsl:value-of select="$passwordForFileAccess"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>', '', '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" encoding="ISO-8859-1"/>
	<xsl:template match="/">
		<xsl:apply-templates select="Records/ArrayOfClient/Client"/>
	</xsl:template>
	<xsl:template match="Records/ArrayOfClient/Client">
		<xsl:for-each select=".//Holding">
			<xsl:value-of select="string(./../../../../ClientDetails/AccountReference)"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="string(./../../../../ClientDetails/ClientFirstName)"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="string(./../../../../ClientDetails/ClientLastName)"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="./../../../../ClientDetails/Postcode"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="./../../../../ClientDetails/NationalInsuranceNumber"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="./../../ProductDetails/SubAccountReference"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="./../../ProductDetails/SubAccountType"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="InstrumentName"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="Price"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="PriceDate"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="Units"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="Value"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="SEDOL"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="Currency"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>', 'sftp',19,13, '|',3 UNION ALL 
        SELECT 24,2625, '|6|', NULL, '11:30', NULL, NULL,0, 'platformtpi.aegon.co.uk', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>Valuation_</xsl:text>
				<xsl:value-of select="substring($processDate,1,4)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring($processDate,5,2)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring($processDate,7,2)"/>
				<xsl:text>.xml</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-dss 1024 da:04:3e:63:6d:7b:cd:be:a7:95:a1:84:ea:6c:e0:62</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'ClientReference|Date|ClientLastName|Postcode|DateofBirth|NINumber|AdviserLastName|PlanReference|PlanType|InvestmentName|Price|PriceDate|ValuationHolding|Value|Sedol|EPIC|MEX|CitiCode|ISIN|Currency', '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" encoding="ISO-8859-1"/>
	<xsl:template match="ValuationData">
		<xsl:apply-templates select="HoldingsData/client"/>
		<xsl:apply-templates select="CashData/client"/>
	</xsl:template>
	<xsl:template match="HoldingsData/client">
		<xsl:variable name="clientRef" select="string(client_reference)"/>
		<xsl:variable name="date" select="string(date)"/>
		<xsl:variable name="responsibility" select="string(responsibility)"/>
		<xsl:variable name="client_name" select="string(client_name)"/>
		<xsl:variable name="postcode" select="string(postcode)"/>
		<xsl:variable name="date_of_birth" select="string(date_of_birth)"/>
		<xsl:variable name="ni_number" select="string(ni_number)"/>
		<xsl:for-each select="plan">
			<xsl:variable name="planRef" select="string(plan_reference)"/>
			<xsl:variable name="planType" select="string(plan_type)"/>
			<xsl:for-each select="investments/investment">
				<xsl:call-template name="investment">
					<xsl:with-param name="clientRef" select="$clientRef"/>
					<xsl:with-param name="date" select="$date"/>
					<xsl:with-param name="responsibility" select="$responsibility"/>
					<xsl:with-param name="client_name" select="$client_name"/>
					<xsl:with-param name="postcode" select="$postcode"/>
					<xsl:with-param name="date_of_birth" select="$date_of_birth"/>
					<xsl:with-param name="ni_number" select="$ni_number"/>
					<xsl:with-param name="planRef" select="$planRef"/>
					<xsl:with-param name="planType" select="$planType"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="CashData/client">
		<xsl:variable name="clientRef" select="string(client_reference)"/>
		<xsl:variable name="date" select="string(date)"/>
		<xsl:variable name="responsibility" select="string(responsibility)"/>
		<xsl:variable name="client_name" select="string(client_name)"/>
		<xsl:variable name="postcode" select="string(postcode)"/>
		<xsl:variable name="date_of_birth" select="string(date_of_birth)"/>
		<xsl:variable name="ni_number" select="string(ni_number)"/>
		<xsl:for-each select="plan">
			<xsl:variable name="planRef" select="string(plan_reference)"/>
			<xsl:variable name="planType" select="string(plan_type)"/>
			<xsl:for-each select="//CashData/client/plan/plan_reference[text() = $planRef]">
				<xsl:call-template name="cash">
					<xsl:with-param name="clientRef" select="$clientRef"/>
					<xsl:with-param name="date" select="$date"/>
					<xsl:with-param name="responsibility" select="$responsibility"/>
					<xsl:with-param name="client_name" select="$client_name"/>
					<xsl:with-param name="postcode" select="$postcode"/>
					<xsl:with-param name="date_of_birth" select="$date_of_birth"/>
					<xsl:with-param name="ni_number" select="$ni_number"/>
					<xsl:with-param name="planRef" select="$planRef"/>
					<xsl:with-param name="planType" select="$planType"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="investment">
		<xsl:param name="clientRef"/>
		<xsl:param name="date"/>
		<xsl:param name="responsibility"/>
		<xsl:param name="client_name"/>
		<xsl:param name="postcode"/>
		<xsl:param name="date_of_birth"/>
		<xsl:param name="ni_number"/>
		<xsl:param name="planRef"/>
		<xsl:param name="planType"/>
		<xsl:value-of select="$clientRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$client_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$postcode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date_of_birth"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$ni_number"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$responsibility"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planType"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="investment_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="price"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="price_date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="valuation_holding"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="value"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="sedol"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="epic"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="mex"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="citicode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="ISIN"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="currency"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	<xsl:template name="cash">
		<xsl:param name="clientRef"/>
		<xsl:param name="date"/>
		<xsl:param name="responsibility"/>
		<xsl:param name="client_name"/>
		<xsl:param name="postcode"/>
		<xsl:param name="date_of_birth"/>
		<xsl:param name="ni_number"/>
		<xsl:param name="planRef"/>
		<xsl:param name="planType"/>
		<xsl:value-of select="$clientRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$client_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$postcode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date_of_birth"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$ni_number"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$responsibility"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planType"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="Cash"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="1"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../../date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../balance"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../balance"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="None"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../currency"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
</xsl:stylesheet>', 'ftp',19,13, '|',1 UNION ALL 
        SELECT 25,2432, '|6|', NULL, '11:30', NULL, NULL,0, 'platformtpi.aegon.co.uk', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>Valuation_</xsl:text>
				<xsl:value-of select="substring($processDate,1,4)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring($processDate,5,2)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring($processDate,7,2)"/>
				<xsl:text>.xml</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-dss 1024 da:04:3e:63:6d:7b:cd:be:a7:95:a1:84:ea:6c:e0:62</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'ClientReference|Date|ClientLastName|Postcode|DateofBirth|NINumber|AdviserLastName|PlanReference|PlanType|InvestmentName|Price|PriceDate|ValuationHolding|Value|Sedol|EPIC|MEX|CitiCode|ISIN|Currency', '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" encoding="ISO-8859-1"/>
	<xsl:template match="ValuationData">
		<xsl:apply-templates select="HoldingsData/client"/>
		<xsl:apply-templates select="CashData/client"/>
	</xsl:template>
	<xsl:template match="HoldingsData/client">
		<xsl:variable name="clientRef" select="string(client_reference)"/>
		<xsl:variable name="date" select="string(date)"/>
		<xsl:variable name="responsibility" select="string(responsibility)"/>
		<xsl:variable name="client_name" select="string(client_name)"/>
		<xsl:variable name="postcode" select="string(postcode)"/>
		<xsl:variable name="date_of_birth" select="string(date_of_birth)"/>
		<xsl:variable name="ni_number" select="string(ni_number)"/>
		<xsl:for-each select="plan">
			<xsl:variable name="planRef" select="string(plan_reference)"/>
			<xsl:variable name="planType" select="string(plan_type)"/>
			<xsl:for-each select="investments/investment">
				<xsl:call-template name="investment">
					<xsl:with-param name="clientRef" select="$clientRef"/>
					<xsl:with-param name="date" select="$date"/>
					<xsl:with-param name="responsibility" select="$responsibility"/>
					<xsl:with-param name="client_name" select="$client_name"/>
					<xsl:with-param name="postcode" select="$postcode"/>
					<xsl:with-param name="date_of_birth" select="$date_of_birth"/>
					<xsl:with-param name="ni_number" select="$ni_number"/>
					<xsl:with-param name="planRef" select="$planRef"/>
					<xsl:with-param name="planType" select="$planType"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="CashData/client">
		<xsl:variable name="clientRef" select="string(client_reference)"/>
		<xsl:variable name="date" select="string(date)"/>
		<xsl:variable name="responsibility" select="string(responsibility)"/>
		<xsl:variable name="client_name" select="string(client_name)"/>
		<xsl:variable name="postcode" select="string(postcode)"/>
		<xsl:variable name="date_of_birth" select="string(date_of_birth)"/>
		<xsl:variable name="ni_number" select="string(ni_number)"/>
		<xsl:for-each select="plan">
			<xsl:variable name="planRef" select="string(plan_reference)"/>
			<xsl:variable name="planType" select="string(plan_type)"/>
			<xsl:for-each select="//CashData/client/plan/plan_reference[text() = $planRef]">
				<xsl:call-template name="cash">
					<xsl:with-param name="clientRef" select="$clientRef"/>
					<xsl:with-param name="date" select="$date"/>
					<xsl:with-param name="responsibility" select="$responsibility"/>
					<xsl:with-param name="client_name" select="$client_name"/>
					<xsl:with-param name="postcode" select="$postcode"/>
					<xsl:with-param name="date_of_birth" select="$date_of_birth"/>
					<xsl:with-param name="ni_number" select="$ni_number"/>
					<xsl:with-param name="planRef" select="$planRef"/>
					<xsl:with-param name="planType" select="$planType"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="investment">
		<xsl:param name="clientRef"/>
		<xsl:param name="date"/>
		<xsl:param name="responsibility"/>
		<xsl:param name="client_name"/>
		<xsl:param name="postcode"/>
		<xsl:param name="date_of_birth"/>
		<xsl:param name="ni_number"/>
		<xsl:param name="planRef"/>
		<xsl:param name="planType"/>
		<xsl:value-of select="$clientRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$client_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$postcode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date_of_birth"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$ni_number"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$responsibility"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planType"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="investment_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="price"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="price_date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="valuation_holding"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="value"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="sedol"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="epic"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="mex"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="citicode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="ISIN"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="currency"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	<xsl:template name="cash">
		<xsl:param name="clientRef"/>
		<xsl:param name="date"/>
		<xsl:param name="responsibility"/>
		<xsl:param name="client_name"/>
		<xsl:param name="postcode"/>
		<xsl:param name="date_of_birth"/>
		<xsl:param name="ni_number"/>
		<xsl:param name="planRef"/>
		<xsl:param name="planType"/>
		<xsl:value-of select="$clientRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$client_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$postcode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date_of_birth"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$ni_number"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$responsibility"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planType"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="Cash"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="1"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../../date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../balance"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../balance"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="None"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../currency"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
</xsl:stylesheet>', 'ftp',19,13, '|',1 UNION ALL 
        SELECT 26,1596, NULL, NULL, NULL, NULL, NULL,0, 'peftp2.fnzc.co.uk', NULL, NULL, NULL, 'sftp',31,0, NULL,3 UNION ALL 
        SELECT 21,556, '|6|', 'saturday', '18:00', 'sunday', '14:00',0, 'https://www.sippcentre.co.uk/adviserlinks/AJBG.DataProvision.WebService.asmx', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/> <xsl:param name="url"/> <xsl:param name="selectedNode" select="//ValSchedules/ValSchedule [position()=1]"/> <xsl:param name="processDate">20070101</xsl:param>
<xsl:template match="/">
<xsl:element name="requestdata">
<xsl:variable name="protocol" select="msxsl:node-set($selectedNode)/@Protocol"/>
<xsl:variable name="supportedService" select="msxsl:node-set($selectedNode)/@SupportedService"/>
<xsl:variable name="supportedFileType" select="msxsl:node-set($selectedNode)/@SupportedFileType"/>
<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
<xsl:variable name="fileName"/>
<xsl:variable name="saveDownloadFileAs"> <xsl:text><![CDATA[SV_]]></xsl:text>
<xsl:value-of select="$indigoClientId"/> <xsl:text><![CDATA[_]]></xsl:text>
<xsl:value-of select="$valScheduleItemId"/> <xsl:text><![CDATA[_]]></xsl:text>
<xsl:value-of select="$processDate"/>
<xsl:text><![CDATA[.txt]]></xsl:text>
</xsl:variable>
<xsl:element name="fileName">
<xsl:value-of select="$fileName"/>
</xsl:element>
<xsl:element name="saveDownloadFileAs">
<xsl:value-of select="$saveDownloadFileAs"/> </xsl:element> <xsl:element name="url"> <xsl:value-of select="$url"/> </xsl:element> <xsl:element name="httpMethodName"> <xsl:text>POST</xsl:text> </xsl:element> <xsl:element name="httpHeaderParams"> <xsl:text>Content-Type=text/xml|SOAPAction="http://tempuri.org/GetValuations"</xsl:text>
</xsl:element>
<xsl:element name="msg">
<xsl:element name="soapenv:Envelope" namespace="http://schemas.xmlsoap.org/soap/envelope/">
<xsl:element name="soapenv:Header" namespace="http://schemas.xmlsoap.org/soap/envelope/" ></xsl:element> <xsl:element name="soapenv:Body" namespace="http://schemas.xmlsoap.org/soap/envelope/" > <xsl:element name="tem:GetValuations" namespace="http://tempuri.org/"> <xsl:element name="get:request" namespace="http://www.ajbell.co.uk/schemas/xsd/businessModel/dataProvision/GetValuationsRequest">
<xsl:element name="get:Username" namespace="http://www.ajbell.co.uk/schemas/xsd/businessModel/dataProvision/GetValuationsRequest">
<xsl:value-of select="$usernameForFileAccess"/> </xsl:element> <xsl:element name="get:Password" namespace="http://www.ajbell.co.uk/schemas/xsd/businessModel/dataProvision/GetValuationsRequest">
<xsl:value-of select="$passwordForFileAccess"/> </xsl:element> <xsl:element name="get:SoftwareProviderRequest" namespace="http://www.ajbell.co.uk/schemas/xsd/businessModel/dataProvision/GetValuationsRequest">IntelliFlo</xsl:element>
</xsl:element>
</xsl:element>
</xsl:element>
</xsl:element>
</xsl:element>
<xsl:element name="username"/>
<xsl:element name="password"/>
<xsl:element name="protocol">
<xsl:value-of select="$protocol"/>
</xsl:element>
<xsl:element name="supportedService">
<xsl:value-of select="$supportedService"/> </xsl:element> <x', '', '', 'soap',19,13, '|',3 UNION ALL 
        SELECT 22,2572, '|6|', '', '', '', '19:00',0, '', '<?xml version="1.0" encoding="ISO-8859-1"?>
	                                        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	                                          <xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	                                          <xsl:param name="url"/>
	                                          <xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	                                          <xsl:param name="processDate">20070101</xsl:param>
	                                          <xsl:template match="/">
		                                        <xsl:element name="requestdata">
		                                          <xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
		                                          <xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
		                                          <xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
		                                          <xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
		                                          <xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
		                                          <xsl:variable name="fileName">
			                                        <xsl:value-of select="$usernameForFileAccess"/>
                                                    <xsl:text>_valuation_</xsl:text>
			                                        <xsl:value-of select="$processDate"/>
			                                        <xsl:text>.txt</xsl:text>
		                                          </xsl:variable>
		                                          <xsl:variable name="saveDownloadFileAs">
			                                        <xsl:value-of select="$indigoClientId"/>
			                                        <xsl:text>\</xsl:text>
			                                        <xsl:text>SV_</xsl:text>
			                                        <xsl:value-of select="$indigoClientId"/>
			                                        <xsl:text>_</xsl:text>
			                                        <xsl:value-of select="$valScheduleItemId"/>
			                                        <xsl:text>_</xsl:text>
			                                        <xsl:value-of select="$processDate"/>
			                                        <xsl:text>.txt</xsl:text>
		                                          </xsl:variable>
		                                          <xsl:variable name="generateUrl">
			                                        <xsl:value-of select="$url"/>
		                                          </xsl:variable>
		                                          <xsl:element name="fileName">
			                                        <xsl:value-of select="$fileName"/>
		                                          </xsl:element>
		                                          <xsl:element name="saveDownloadFileAs">
			                                        <xsl:value-of select="$saveDo', 'ProviderName|PolicyNumber|Sedol|MEXId|ISIN|CitiCode|ProviderFundCode|FundName|NumberOfUnits|UnitsDate|UnitsPrice|UnitspriceDate|Currency', '', 'sftp',128,20, ',',2 UNION ALL 
        SELECT 2,567, '|1|', 'wednesday', '08:00', 'wednesday', '18:30',0, 'https://www.reportingservices.fidelity.co.uk/ukrep/ReportingServiceServlet', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="//ValSchedules/ValSchedule [position()=1]"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="protocol" select="msxsl:node-set($selectedNode)/@Protocol"/>
			<xsl:variable name="supportedService" select="msxsl:node-set($selectedNode)/@SupportedService"/>
			<xsl:variable name="supportedFileType" select="msxsl:node-set($selectedNode)/@SupportedFileType"/>
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="fileName"/>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text><![CDATA[SV_]]></xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text><![CDATA[_]]></xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text><![CDATA[_]]></xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text><![CDATA[.txt]]></xsl:text>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$url"/>
			</xsl:element>
			<xsl:element name="httpMethodName">
				<xsl:text>POST</xsl:text>
			</xsl:element>
			<xsl:element name="httpHeaderParams">
				<xsl:text>Content-Type=text/html</xsl:text>
			</xsl:element>
			<xsl:element name="msg">
				<xsl:element name="RequestList">
					<xsl:element name="informationRequest">
						<xsl:attribute name="UserId"><xsl:value-of select="$usernameForFileAccess"/></xsl:attribute>
						<xsl:attribute name="PIN"><xsl:value-of select="$passwordForFileAccess"/></xsl:attribute>
						<xsl:attribute name="reportType">IFA-H</xsl:attribute>
						<xsl:attribute name="VendorVersionIdentifier">Intelliflo</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="username"/>
			<xsl:element name="password"/>
			<xsl:element name="protocol">
				<xsl:value-of select="$protocol"/>
			</xsl:element>
			<xsl:element name="supportedService">
				<xsl:value-of select="$supportedService"/>
			</xsl:element>
			<xsl:element name="supportedFileType">
				<xsl:value-of select="$supportedFileType"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'zzIGNOREzz|Sedol|ISIN|Quantity|EffectiveDate|FundName|PortfolioType|PortfolioReference|Title|CustomerFirstName|CustomerLastName|CustomerNINumber|ClientAddressLine1|ClientAddressLine2|ClientAddressLine3|ClientAddressLine4|ClientPostCode|CustomerDoB|Price|zzIGNOREzz|PriceDate|zzIGNOREzz|HoldingValue|zzIGNOREzz|AdviserFirstName|AdviserReference|AdviserOfficePostCode|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|zzIGNOREzz|AdviserCompanyName', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://www.intelliflo-ltd.com" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" indent="no"/>
	<!-- VBScript Functions -->
	<msxsl:script language="vbscript" implements-prefix="user"><![CDATA[	
		On Error Resume Next

		Function ReplaceText(theString, replaceWhat, replaceWith)
			ReplaceText = Replace(theString, replaceWhat, replaceWith)
		End Function
	]]></msxsl:script>
	<xsl:template match="/">
		<xsl:for-each select="//ReportData/DataRow">
			<xsl:if test="position() != &quot;1&quot;">
				<xsl:variable name="step1" select="translate(.,''&quot;'',&quot;|&quot;)"/>
				<xsl:variable name="step2" select="user:ReplaceText(string($step1), &quot;|,|&quot;, &quot;|&quot;)"/> 
				<xsl:variable name="step3" select="substring($step2,2, string-length($step2) - 2)" />
				<xsl:value-of select="$step3"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
', 'https',23,13, '|',5 UNION ALL 
        SELECT 18,1377, '|6|', 'sunday', '14:00', 'sunday', '21:30',0, 'ths-ftp.thesis-plc.com', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="$usernameForFileAccess"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.TXT</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>a2:0d:1e:20:db:3b:e5:1d:f5:3b:fe:57:2d:ee:53:98:5e:53:2e:e5</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
', 'CustomerReference|PlanReference|PlanType|SubPlanReference|SubPlanType|PriceDate|Sedol|MEXId|EpicCode|CitiCode|ISIN|FundName|Price|Quantity|HoldingValue|Currency|AdviserFirstName|AdviserLastName|CustomerFirstName|CustomerLastName|CustomerDoB|ClientPostCode|CustomerNINumber', '', 'ftps',19,20, '|',6 UNION ALL 
        SELECT 20,901, '|6|', 'sunday', '08:00', 'sunday', '20:00',-1, 'transfers.minsys.co.uk', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="$usernameForFileAccess"/>
				<xsl:text>_valuation_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>4d:be:3c:2b:75:e4:eb:b1:b6:29:a7:b1:04:9d:22:0b:7f:56:7c:27</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PlanReference|SubPlanReference|SubPlanType|PlanType|PriceDate|EffectiveDate|Sedol|FundName|Price|Quantity|HoldingValue|Currency|AdviserFirstName|AdviserLastName|CustomerFirstName|CustomerLastName|CustomerDoB|ClientPostCode|CustomerNINumber|PortfolioId|HoldingId|FundProviderName', '', 'ftps',19,20, '|',9 UNION ALL 
        SELECT 16,183, '|6|', 'sunday', '07:30:00', 'sunday', '22:00',-1, '146.101.17.57', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>*</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>*</xsl:text>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 1024 f2:5d:04:be:dd:bb:69:d9:43:71:fb:be:eb:dc:03:6b</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PlanReference|PlanType|PriceDate|EffectiveDate|Sedol|MEXId|ISIN|FundName|Price|Quantity|HoldingValue|Currency|AdviserFirstName|AdviserLastName|CustomerFirstName|CustomerLastName|CustomerDoB|ClientPostCode|CustomerNINumber', '', 'sftp',23,20, '|',3 UNION ALL 
        SELECT 10,1145, '|11|', 'saturday', '07:00', 'sunday', '07:00',0, 'sftp.margetts.com', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>valuation.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text/>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PlanReference|PlanType|PriceDate|ISIN|FundName|Price|Quantity|HoldingValue|Currency|AdviserFirstName|zzzIGNOREzzz|CustomerFirstName', '', 'sftp',19,20, '|',73 UNION ALL 
        SELECT 14,302, '|6|', 'saturday', '15:00:00', 'sunday', '12:00',0, 'transfer.rowan-dartington.co.uk', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:value-of select="$usernameForFileAccess"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 1024 c4:12:83:84:1b:89:d0:3a:15:4a:46:f2:5e:36:9a:d7</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'CustomerReference|PlanReference|PlanType|PriceDate|ISIN|FundName|Price|Quantity|HoldingValue|Currency|AdviserFirstName|AdviserLastName|CustomerFirstName|CustomerLastName|CustomerDoB|ClientPostCode|CustomerNINumber', '', 'sftp',19,20, '|',8 UNION ALL 
        SELECT 11,1509, '|6|', 'saturday', '14:00', 'sunday', '08:00',0, 'edi.parmenion.co.uk', '<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>intelliflo_valuation.xml</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-rsa 2048 68:19:86:44:b2:ed:19:b5:5c:52:91:ed:bb:10:b7:7a</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', '', '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" encoding="ISO-8859-1"/>
	<xsl:template match="/VALUATION/Datas">
		<xsl:for-each select="Data">
			<xsl:value-of select="PLAN_NO"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="AdviserName"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="CLIENT_REF"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="CLIENT_NAME"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="substring(DATEOFBIRTH/text(),7,4)"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="substring(DATEOFBIRTH/text(),4,2)"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="substring(DATEOFBIRTH/text(),1,2)"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="NINUMBER"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="POSTCODE"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="PORTFOLIO_TYPE"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="SEDOL"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="ISIN"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="FUNDNAME"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="PRICE"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="HOLDING"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="VALUE"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="substring(PRICEVALUEDATE/text(),7,4)"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="substring(PRICEVALUEDATE/text(),4,2)"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="substring(PRICEVALUEDATE/text(),1,2)"/>
			<xsl:text>|</xsl:text>
			<xsl:value-of select="PRICECURRENCY"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>', 'sftp',19,13, '|',9 UNION ALL 
        SELECT 6,1814, '|6|', 'saturday', '13:30:00', 'saturday', '20:00',0, 'tpi.noviaonline.co.uk', '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:param name="url"/>
	<xsl:param name="selectedNode" select="/ValSchedules/ValSchedule"/>
	<xsl:param name="processDate">20070101</xsl:param>
	<xsl:template match="/">
		<xsl:element name="requestdata">
			<xsl:variable name="indigoClientId" select="msxsl:node-set($selectedNode)/@IndigoClientId"/>
			<xsl:variable name="valScheduleItemId" select="msxsl:node-set($selectedNode)/ValScheduleItem/@ValScheduleItemId"/>
			<xsl:variable name="usernameForFileAccess" select="msxsl:node-set($selectedNode)/@UserNameForFileAccess"/>
			<xsl:variable name="passwordForFileAccess" select="msxsl:node-set($selectedNode)/@PasswordForFileAccess"/>
			<xsl:variable name="usernameForURL" select="substring-after(msxsl:node-set($selectedNode)/@UserNameForFileAccess,&quot;_&quot;)"/>
			<xsl:variable name="fileName">
				<xsl:text>Valuation_</xsl:text>
				<xsl:value-of select="substring($processDate,1,4)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring($processDate,5,2)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring($processDate,7,2)"/>
				<xsl:text>.xml</xsl:text>
			</xsl:variable>
			<xsl:variable name="saveDownloadFileAs">
				<xsl:text>SV_</xsl:text>
				<xsl:value-of select="$indigoClientId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$valScheduleItemId"/>
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$processDate"/>
				<xsl:text>.txt</xsl:text>
			</xsl:variable>
			<xsl:variable name="generateUrl">
				<xsl:value-of select="$url"/>
			</xsl:variable>
			<xsl:element name="fileName">
				<xsl:value-of select="$fileName"/>
			</xsl:element>
			<xsl:element name="saveDownloadFileAs">
				<xsl:value-of select="$saveDownloadFileAs"/>
			</xsl:element>
			<xsl:element name="url">
				<xsl:value-of select="$generateUrl"/>
			</xsl:element>
			<xsl:element name="msg"/>
			<xsl:element name="username">
				<xsl:value-of select="$usernameForFileAccess"/>
			</xsl:element>
			<xsl:element name="fingerprint">
				<xsl:text>ssh-dss 1024 da:04:3e:63:6d:7b:cd:be:a7:95:a1:84:ea:6c:e0:62</xsl:text>
			</xsl:element>
			<xsl:element name="password">
				<xsl:value-of select="$passwordForFileAccess"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>', 'ClientReference|Date|ClientLastName|Postcode|DateofBirth|NINumber|AdviserLastName|PlanReference|PlanType|InvestmentName|Price|PriceDate|ValuationHolding|Value|Sedol|EPIC|MEX|CitiCode|ISIN|Currency', '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" encoding="ISO-8859-1"/>
	<xsl:template match="ValuationData">
		<xsl:apply-templates select="HoldingsData/client"/>
		<xsl:apply-templates select="CashData/client"/>
	</xsl:template>
	<xsl:template match="HoldingsData/client">
		<xsl:variable name="clientRef" select="string(client_reference)"/>
		<xsl:variable name="date" select="string(date)"/>
		<xsl:variable name="responsibility" select="string(responsibility)"/>
		<xsl:variable name="client_name" select="string(client_name)"/>
		<xsl:variable name="postcode" select="string(postcode)"/>
		<xsl:variable name="date_of_birth" select="string(date_of_birth)"/>
		<xsl:variable name="ni_number" select="string(ni_number)"/>
		<xsl:for-each select="plan">
			<xsl:variable name="planRef" select="string(plan_reference)"/>
			<xsl:variable name="planType" select="string(plan_type)"/>
			<xsl:for-each select="investments/investment">
				<xsl:call-template name="investment">
					<xsl:with-param name="clientRef" select="$clientRef"/>
					<xsl:with-param name="date" select="$date"/>
					<xsl:with-param name="responsibility" select="$responsibility"/>
					<xsl:with-param name="client_name" select="$client_name"/>
					<xsl:with-param name="postcode" select="$postcode"/>
					<xsl:with-param name="date_of_birth" select="$date_of_birth"/>
					<xsl:with-param name="ni_number" select="$ni_number"/>
					<xsl:with-param name="planRef" select="$planRef"/>
					<xsl:with-param name="planType" select="$planType"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="CashData/client">
		<xsl:variable name="clientRef" select="string(client_reference)"/>
		<xsl:variable name="date" select="string(date)"/>
		<xsl:variable name="responsibility" select="string(responsibility)"/>
		<xsl:variable name="client_name" select="string(client_name)"/>
		<xsl:variable name="postcode" select="string(postcode)"/>
		<xsl:variable name="date_of_birth" select="string(date_of_birth)"/>
		<xsl:variable name="ni_number" select="string(ni_number)"/>
		<xsl:for-each select="plan">
			<xsl:variable name="planRef" select="string(plan_reference)"/>
			<xsl:variable name="planType" select="string(plan_type)"/>
			<xsl:for-each select="//CashData/client/plan/plan_reference[text() = $planRef]">
				<xsl:call-template name="cash">
					<xsl:with-param name="clientRef" select="$clientRef"/>
					<xsl:with-param name="date" select="$date"/>
					<xsl:with-param name="responsibility" select="$responsibility"/>
					<xsl:with-param name="client_name" select="$client_name"/>
					<xsl:with-param name="postcode" select="$postcode"/>
					<xsl:with-param name="date_of_birth" select="$date_of_birth"/>
					<xsl:with-param name="ni_number" select="$ni_number"/>
					<xsl:with-param name="planRef" select="$planRef"/>
					<xsl:with-param name="planType" select="$planType"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="investment">
		<xsl:param name="clientRef"/>
		<xsl:param name="date"/>
		<xsl:param name="responsibility"/>
		<xsl:param name="client_name"/>
		<xsl:param name="postcode"/>
		<xsl:param name="date_of_birth"/>
		<xsl:param name="ni_number"/>
		<xsl:param name="planRef"/>
		<xsl:param name="planType"/>
		<xsl:value-of select="$clientRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$client_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$postcode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date_of_birth"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$ni_number"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$responsibility"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planType"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="investment_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="price"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="price_date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="valuation_holding"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="value"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="sedol"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="epic"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="mex"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="citicode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="ISIN"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="currency"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	<xsl:template name="cash">
		<xsl:param name="clientRef"/>
		<xsl:param name="date"/>
		<xsl:param name="responsibility"/>
		<xsl:param name="client_name"/>
		<xsl:param name="postcode"/>
		<xsl:param name="date_of_birth"/>
		<xsl:param name="ni_number"/>
		<xsl:param name="planRef"/>
		<xsl:param name="planType"/>
		<xsl:value-of select="$clientRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$client_name"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$postcode"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$date_of_birth"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$ni_number"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$responsibility"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planRef"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="$planType"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="''Cash''"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="1"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../../date"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../balance"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../balance"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '''' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '''' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '''' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select=" '''' "/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="''None''"/>
		<xsl:text>|</xsl:text>
		<xsl:value-of select="../currency"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
</xsl:stylesheet>', 'ftp',19,13, '|',5 
 
        SET IDENTITY_INSERT TValBulkConfig OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '2E56B172-3BA2-48CA-9598-DAB3574970E0', 
         'Initial load (36 total rows, file 1 of 1) for table TValBulkConfig',
         null, 
         getdate() )
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
-----------------------------------------------------------------------------
-- #Rows Exported: 36
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
