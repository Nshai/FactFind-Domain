 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValuationXSL
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A22E7729-E354-4266-8DD8-E54D72D5775A'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValuationXSL ON; 
 
        INSERT INTO TValuationXSL([ValuationXSLId], [Description], [XSL], [ConcurrencyId])
        SELECT 1, 'Skandia - Pensions and Bonds ONLY', '<!--Valuation Request XSL: Skandia - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message>
			<m_control>
				<xsl:element name="control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="retry_number">0</xsl:element>
				<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="expected_response_type">synchronous</xsl:element>
				<xsl:element name="initiator_id">Intelliflo Plc</xsl:element>
				<xsl:element name="responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</m_control>
			<m_content>
				<intermediary>
					<xsl:element name="sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<agency_address>
						<xsl:element name="postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</agency_address>
				</intermediary>
				<xsl:element name="request_scope">
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
							<xsl:attribute name="type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
							<xsl:attribute name="type">Surrender</xsl:attribute>
						</xsl:if>
					</xsl:element>
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="contract">
					<xsl:element name="contract_reference_number">
						<xsl:value-of select="translate(/RequestVariables/RequestVariable/@PolicyNumber,&quot;abcdefghijklmnopqrstuvwxyz&quot;,&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)"/>
					</xsl:element>
					<xsl:element name="intermediary_case_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</xsl:element>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 2, 'Skandia - Other', '<!--Valuation Request XSL: Skandia - Other-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message>
			<m_control>
				<xsl:element name="control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="retry_number">0</xsl:element>
				<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="expected_response_type">synchronous</xsl:element>
				<xsl:element name="initiator_id">Intelliflo Plc</xsl:element>
				<xsl:element name="responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</m_control>
			<m_content>
				<xsl:element name="b_control">
					<xsl:element name="contract_enquiry_reference">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</xsl:element>
				<intermediary>
					<xsl:element name="sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<agency_address>
						<xsl:element name="postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</agency_address>
				</intermediary>
				<xsl:element name="contract_identification">
					<xsl:attribute name="type">Individual Contract</xsl:attribute>
					<xsl:element name="policy_number">
						<xsl:value-of select="translate(/RequestVariables/RequestVariable/@PolicyNumber,&quot;abcdefghijklmnopqrstuvwxyz&quot;,&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="request_scope">
					<xsl:element name="all_contracts_ind">Yes</xsl:element>
					<xsl:element name="ended_contracts_ind">No</xsl:element>
					<xsl:element name="contract_details_required_ind">Yes</xsl:element>
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
						<xsl:element name="print_required_ind">No</xsl:element>
					</xsl:element>
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="total_fund_value_ind">Yes</xsl:element>
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
						<xsl:element name="print_required_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 3, 'Funds Network - Collective Investments', '<!--Valuation Request XSL: Funds Network - Collective Investments-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<RequestList>
			<xsl:variable name="PolicyYear" select="substring(/RequestVariables/RequestVariable/@PolicyStartDate,1,4)"/>
			<xsl:variable name="PolicyStartDate" select="substring(/RequestVariables/RequestVariable/@PolicyStartDate,1,10)"/>
			<xsl:variable name="TaxYearStartDate" select="concat($PolicyYear,&quot;-04-06&quot;)"/>
			<xsl:variable name="vPortalReference" select="		translate(/RequestVariables/RequestVariable/@PortalReference,&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,&quot;abcdefghijklmnopqrstuvwxyz&quot;)"/>
			<xsl:variable name="TaxYear">
				<xsl:choose>
					<xsl:when test="translate($PolicyStartDate, &quot;-&quot;, &quot;&quot;) &lt; translate($TaxYearStartDate, &quot;-&quot;, &quot;&quot;)">
						<xsl:value-of select="number($PolicyYear) - 1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$PolicyYear"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="RefProdProviderId" select="/RequestVariables/RequestVariable/@RefProdProviderId"/>
			<xsl:variable name="RefPlanTypeId" select="/RequestVariables/RequestVariable/@RefPlanTypeId"/>
			<xsl:variable name="SchemeNameToPass">
				<xsl:choose>
					<xsl:when test="$RefProdProviderId = 567 and $RefPlanTypeId = 26">ISM</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductType"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<InformationRequest>
				<xsl:attribute name="OutputCurrency">GBP</xsl:attribute>
				<xsl:attribute name="VendorVersionIdentifier"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/></xsl:attribute>
				<xsl:attribute name="UserId"><xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/></xsl:attribute>
				<xsl:attribute name="PIN"><xsl:value-of select="/RequestVariables/RequestVariable/@PortalPassword"/></xsl:attribute>
				<AccountInformationRequest>
					<xsl:attribute name="AccountNumber"><xsl:variable name="OrigoProductType" select="translate(/RequestVariables/RequestVariable/@OrigoProductType,&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,&quot;abcdefghijklmnopqrstuvwxyz&quot;)"/><xsl:choose><xsl:when test="(contains($OrigoProductType,&quot;isa&quot;) or contains($OrigoProductType,&quot;pep&quot;)) and not(contains($vPortalReference, &quot;/bundled&quot;))"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>/<xsl:value-of select="$TaxYear"/></xsl:when><xsl:otherwise><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="SchemeName"><xsl:value-of select="$SchemeNameToPass"/></xsl:attribute>
				</AccountInformationRequest>
			</InformationRequest>
		</RequestList>
	</xsl:template>
</xsl:stylesheet>',3 UNION ALL 
        SELECT 4, 'Standard Life - Pensions and Bonds', '<!--Valuation Request XSL: Standard Life - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message>
			<m_control>
				<xsl:element name="control_timestamp"><xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/></xsl:element>
				<xsl:element name="message_id"><xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>	</xsl:element>
				<xsl:element name="retry_number">0</xsl:element>
				<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="message_version"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/></xsl:element>
				<xsl:element name="expected_response_type">synchronous</xsl:element>
				<xsl:element name="initiator_id">Intelliflo Plc</xsl:element>
				<!--KeyInfo Block -->
				<KeyInfo>
					<X509Data>
						<X509IssuerSerial>
							<xsl:element name="X509IssuerName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/></xsl:element>
							<xsl:element name="X509SerialNumber"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/></xsl:element>
						</X509IssuerSerial>
						<xsl:element name="X509SubjectName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/></xsl:element>
					</X509Data>
				</KeyInfo>				
				<xsl:element name="responder_id"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/></xsl:element>
			</m_control>
			<m_content>
				<intermediary>
					<xsl:element name="sib_number"><xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/></xsl:element>
					<xsl:element name="company_name"><xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/></xsl:element>
					<agency_address>
						<xsl:element name="postcode"><xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/></xsl:element>
					</agency_address>
				</intermediary>
				<xsl:element name="request_scope">
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=''Pension''">
							<xsl:attribute name="type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=''Bond''">
							<xsl:attribute name="type">Surrender</xsl:attribute>
						</xsl:if>							
					</xsl:element>					
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<contract>
					<xsl:element name="contract_reference_number"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/></xsl:element>
					<xsl:element name="intermediary_case_reference_number"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/></xsl:element>
				</contract>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 5, 'Friends Provident - Pensions and Bonds ONLY', '<!--Valuation Request XSL: Friends Provident - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message>
			<m_control>
				<xsl:element name="control_timestamp"><xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/></xsl:element>
				<xsl:element name="message_id"><xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>	</xsl:element>
				<xsl:element name="retry_number">0</xsl:element>
				<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="message_version"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/></xsl:element>
				<xsl:element name="expected_response_type">synchronous</xsl:element>
				<xsl:element name="initiator_id">Intelliflo Plc</xsl:element>
				<!--KeyInfo Block -->
				<KeyInfo>
					<X509Data xmlns="http://www.w3.org/2000/09/xmldsig#">
						<X509IssuerSerial>
							<xsl:element name="X509IssuerName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/></xsl:element>
							<xsl:element name="X509SerialNumber"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/></xsl:element>
						</X509IssuerSerial>
						<xsl:element name="X509SubjectName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/></xsl:element>
					</X509Data>
				</KeyInfo>				
				<xsl:element name="responder_id"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/></xsl:element>
			</m_control>
			<m_content>
				<intermediary>
					<xsl:element name="sib_number"><xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/></xsl:element>
					<xsl:element name="company_name"><xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/></xsl:element>
					<agency_address>
						<xsl:element name="postcode"><xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/></xsl:element>
					</agency_address>
				</intermediary>
				<xsl:element name="request_scope">
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=''Pension''">
							<xsl:attribute name="type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=''Bond''">
							<xsl:attribute name="type">Surrender</xsl:attribute>
						</xsl:if>							
					</xsl:element>					
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<contract>
					<xsl:element name="contract_reference_number"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/></xsl:element>
					<xsl:element name="intermediary_case_reference_number"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/></xsl:element>
				</contract>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 7, 'Cofunds', '<!--Valuation Request XSL: Cofunds-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<RequestList Content_Type="text/xml" Portfolio_Request_Ind="Yes">
			<ProcessRequestInstructions>
				<xsl:element name="SubmitAs">namevaluepairwithxml</xsl:element>
			</ProcessRequestInstructions>
			<AccountInformationRequest>
				<message xmlns="http://www.origoservices.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
					<m_control>
						<xsl:element name="control_timestamp">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
						</xsl:element>
						<xsl:element name="message_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
						</xsl:element>
						<xsl:element name="retry_number">0</xsl:element>
						<xsl:element name="message_type">Cofunds Valuation Request</xsl:element>
						<xsl:element name="message_version">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
						</xsl:element>
						<xsl:element name="expected_response_type">synchronous</xsl:element>
						<xsl:element name="initiator_id">Intelliflo</xsl:element>
						<xsl:element name="responder_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
						</xsl:element>
						<xsl:element name="user_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/>
						</xsl:element>
					</m_control>
					<m_content>
						<xsl:element name="b_control">
							<xsl:element name="contract_enquiry_reference">
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
							</xsl:element>
							<xsl:element name="tpsdata"/>
						</xsl:element>
						<intermediary/>
						<xsl:element name="contract_identification">
							<xsl:element name="client_enquiry">
								<xsl:element name="customer_reference_number">
									<xsl:choose>
										<xsl:when test="string-length(/RequestVariables/RequestVariable/@PortalReference) != 0 ">
											<xsl:value-of select="/RequestVariables/RequestVariable/@PortalReference"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:element name="request_scope">
							<xsl:element name="valuation_currency">GBP</xsl:element>
							<fund_code_type_required>ISIN</fund_code_type_required>
							<xsl:element name="tpsdata">
								<xsl:element name="records_per_page">500</xsl:element>
								<xsl:element name="page_number">1</xsl:element>
							</xsl:element>
						</xsl:element>
					</m_content>
				</message>
			</AccountInformationRequest>
			<ProcessResponseInstructions>
				<PreFormatXSLName>PreFormatCofundsData.xsl</PreFormatXSLName>
				<Filter>
					<FilterKey>contractReference</FilterKey>
					<FilterValue>
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</FilterValue>
				</Filter>
			</ProcessResponseInstructions>
		</RequestList>
	</xsl:template>
</xsl:stylesheet>',2 UNION ALL 
        SELECT 8, 'Aviva - Norwich Union - Pensions and Bonds ONLY - UniPass', '<!--Valuation Request XSL: Norwich Union - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message xmlns="http://www.origoservices.com">
			<m_control>
				<xsl:element name="control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="retry_number">0</xsl:element>
				<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="expected_response_type">synchronous</xsl:element>
				<xsl:element name="initiator_id">Intelliflo Ltd</xsl:element>
				<!--KeyInfo Block -->
				<KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</KeyInfo>
				<xsl:element name="responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</m_control>
			<m_content>
				<intermediary>
					<xsl:element name="sib_number">
						<xsl:choose>
							<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:if test="/RequestVariables/RequestVariable/@AdviserPostcode != &quot;&quot; ">
						<agency_address>
							<xsl:element name="postcode">
								<xsl:value-of select="/RequestVariables/RequestVariable/@AdviserPostcode"/>
							</xsl:element>
						</agency_address>
					</xsl:if>
				</intermediary>
				<xsl:element name="request_scope">
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType= &quot;Pension&quot;">
							<xsl:attribute name="type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType= &quot;Bond&quot;">
							<xsl:attribute name="type">Surrender</xsl:attribute>
						</xsl:if>
					</xsl:element>
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<contract>
					<xsl:element name="contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
					<xsl:element name="intermediary_case_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</contract>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>
',1 UNION ALL 
        SELECT 9, 'Prudential - Pensions and Bonds ONLY', '<!--Valuation Request XSL: Prudential - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message xmlns="http://www.origoservices.com">
			<m_control id="m_control" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.origoservices.com">
				<xsl:element name="control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="retry_number">0</xsl:element>
				<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="expected_response_type">synchronous</xsl:element>
				<xsl:element name="initiator_id">Intelliflo Ltd</xsl:element>
				<!--KeyInfo Block -->
				<KeyInfo Id="keyinfo1">
					<X509Data xmlns="http://www.w3.org/2000/09/xmldsig#">
						<X509IssuerSerial>
							<xsl:element name="X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</X509IssuerSerial>
						<xsl:element name="X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</X509Data>
				</KeyInfo>
				<xsl:element name="responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</m_control>
			<m_content>
				<intermediary>
					<xsl:element name="sib_number">
						<xsl:choose>
							<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<agency_address>
						<xsl:element name="postcode">
							<xsl:choose>
								<xsl:when test="/RequestVariables/RequestVariable/@AdviserPostcode != &quot;&quot; ">
									<xsl:value-of select="/RequestVariables/RequestVariable/@AdviserPostcode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</agency_address>
				</intermediary>
				<xsl:element name="request_scope">
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
							<xsl:attribute name="type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
							<xsl:attribute name="type">Surrender</xsl:attribute>
						</xsl:if>
					</xsl:element>
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<contract>
					<xsl:element name="contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
					<xsl:element name="intermediary_case_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</contract>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 12, 'Scottish Mutual - Bonds ONLY', '<!--Valuation Request XSL: Scottish Mutual - Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<RequestList Content_Type="application/x-www-form-urlencoded">
			<ProcessRequestInstructions>
				<xsl:element name="Intelliflo_Portal_UserNameTag">userid</xsl:element>
				<xsl:element name="Intelliflo_Portal_Username"><xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/></xsl:element>
				<xsl:element name="Intelliflo_Portal_PasswordTag">password</xsl:element>
				<xsl:element name="Intelliflo_Portal_Password"><xsl:value-of select="/RequestVariables/RequestVariable/@PortalPassword"/></xsl:element>
				<xsl:element name="SubmitAs">namevaluepairwithxml</xsl:element>
			</ProcessRequestInstructions>
			<AccountInformationRequest>
				<xsl:text>xmlData=</xsl:text>
				<xsl:element name="message">
					<xsl:element name="m_control">
						<xsl:element name="control_timestamp">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
						</xsl:element>
						<xsl:element name="message_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
						</xsl:element>
						<xsl:element name="retry_number">0</xsl:element>
						<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
						<xsl:element name="message_version">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
						</xsl:element>
						<xsl:element name="expected_response_type">synchronous</xsl:element>
						<xsl:element name="initiator_id">Intelliflo Ltd</xsl:element>
						<xsl:element name="responder_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
						</xsl:element>
						<xsl:element name="user_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="m_content">
						<xsl:element name="b_control">
							<xsl:element name="contract_enquiry_reference">
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
							</xsl:element>
						</xsl:element>
						<intermediary>
							<xsl:element name="sib_number">
								<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
							</xsl:element>
							<xsl:element name="company_name">
								<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
							</xsl:element>
							<agency_address>
								<xsl:element name="postcode">
									<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
								</xsl:element>
							</agency_address>
						</intermediary>
						<xsl:element name="request_scope">
							<xsl:element name="valuation_currency">GBP</xsl:element>
							<xsl:element name="fund_code_type_required">SEDOL</xsl:element>
							<xsl:element name="valuation_request">
								<xsl:attribute name="type">Current</xsl:attribute>
							</xsl:element>
							<xsl:element name="valuation_request">
								<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
									<xsl:attribute name="type">Transfer</xsl:attribute>
								</xsl:if>
								<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
									<xsl:attribute name="type">Surrender</xsl:attribute>
								</xsl:if>
							</xsl:element>
							<xsl:element name="fund_breakdown_request">
								<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:element name="contract">
							<xsl:element name="contract_reference_number">
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
							</xsl:element>
							<xsl:element name="intermediary_case_reference_number">
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:text/>
			</AccountInformationRequest>
		</RequestList>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 14, 'Scottish Equitable - Pensions and Bonds ONLY', '<!--Valuation Request XSL: Scottish Equitable - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
    <xsl:template match="/">
        <mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <mtg:m_control>
                <xsl:element name="mtg:control_timestamp"><xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/></xsl:element>
                <xsl:element name="mtg:message_id"><xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/> </xsl:element>
                <xsl:element name="mtg:retry_number">0</xsl:element>
                <xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
                <xsl:element name="mtg:message_version"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/></xsl:element>
                <xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
                <xsl:element name="mtg:initiator_id">Intelliflo Ltd</xsl:element>
                <!--KeyInfo Block -->
                <mtg:KeyInfo>
                    <ds:X509Data>
                        <ds:X509IssuerSerial>
                            <xsl:element name="ds:X509IssuerName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/></xsl:element>
                            <xsl:element name="ds:X509SerialNumber"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/></xsl:element>
                        </ds:X509IssuerSerial>
                        <xsl:element name="ds:X509SubjectName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/></xsl:element>
                    </ds:X509Data>
                </mtg:KeyInfo>              
                <xsl:element name="mtg:responder_id"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/></xsl:element>
            </mtg:m_control>
            <ce:m_content>
                <ce:b_control>
                    <ce:contract_enquiry_reference>SIT Test XML</ce:contract_enquiry_reference>
                </ce:b_control>
                <xsl:element name="ce:request_scope">
		    <xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
                    <xsl:element name="ce:valuation_currency">GBP</xsl:element>
                    <xsl:element name="ce:fund_code_type_required">SEDOL</xsl:element>
                    <xsl:element name="ce:valuation_request">
                        <xsl:attribute name="ce:type">Current</xsl:attribute>
                    </xsl:element>
	  	    <xsl:element name="ce:valuation_request">
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=''Pension''">
				<xsl:attribute name="ce:type">Transfer</xsl:attribute>
			</xsl:if>
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=''Bond''">
				<xsl:attribute name="ce:type">Surrender</xsl:attribute>
			</xsl:if>							
		    </xsl:element>
                </xsl:element>
                <ce:contract>
                    <xsl:element name="ce:contract_reference_number"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/></xsl:element>
                    <xsl:element name="ce:intermediary_case_reference_number"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/></xsl:element>
                </ce:contract>
            </ce:m_content>
        </mtg:message>
    </xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 15, 'Standard Life - Pensions v2', '<!--Valuation Request XSL: Standard Life - Pensions v2-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd">
			<mtg:m_control>
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">Intelliflo Plc</xsl:element>
				<!--KeyInfo Block -->
				<mtg:KeyInfo>
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</mtg:KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content id="m_content1">
				<xsl:element name="ce:intermediary">
					<xsl:element name="ce:sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="ce:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="ce:agency_address">
						<xsl:element name="ce:postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:request_scope">
					<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
					<xsl:element name="ce:valuation_currency">GBP</xsl:element>
					<xsl:element name="ce:fund_code_type_required">MEX</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:attribute name="ce:type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
							<xsl:attribute name="ce:type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
							<xsl:attribute name="ce:type">Surrender</xsl:attribute>
						</xsl:if>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:contract">
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 16, 'Standard Life - Collective Investments v1.2', '<!--Valuation Request XSL: Standard Life - Collective Investments v1.2-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message xmlns="http://www.origoservices.com" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.origoservices.com CECIVValuationRequest.xsd">
			<mtg:m_control>
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">Intelliflo Plc</xsl:element>
				<!--KeyInfo Block -->
				<mtg:KeyInfo>
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</mtg:KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<m_content id="m_content1">
				<xsl:element name="intermediary">
					<xsl:element name="sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="agency_address">
						<xsl:element name="postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="request_scope">
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="fund_code_type_required">MEX</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
					<xsl:element name="transaction_history_request">
						<xsl:element name="summary_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="contract">
					<xsl:element name="contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 17, 'Transact - Collective Investments', '<!--Valuation Request XSL: Transact - Collective Investments-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<RequestList Content_Type="application/x-www-form-urlencoded">
			<ProcessRequestInstructions>
				<xsl:element name="SubmitAs">namevaluepair</xsl:element>
			</ProcessRequestInstructions>
			<xsl:variable name="AccessCode">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/>
			</xsl:variable>
			<xsl:variable name="PIN">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PortalPassword"/>
			</xsl:variable>
			<xsl:variable name="RequestedService">
				<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
			</xsl:variable>
			<xsl:variable name="AccessType">Real</xsl:variable>
			<xsl:variable name="ProviderKey">
				<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
			</xsl:variable>
			<xsl:variable name="PolicyNumber">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
			</xsl:variable>
			<AccountInformationRequest>accessCode=<xsl:value-of select="$AccessCode"/>&amp;PIN=<xsl:value-of select="$PIN"/>&amp;requestedService=<xsl:value-of select="$RequestedService"/>&amp;AccessType=<xsl:value-of select="$AccessType"/>&amp;providerKey=<xsl:value-of select="substring-after($ProviderKey,&quot;,&quot;)"/>
			</AccountInformationRequest>
			<ProcessResponseInstructions>
				<FieldNames Delimiter="|">Version_Number|unused1|Transact_Investment_Key|Number_of_Units|Valuation_Date|Investment_Name|Facility_Name|Facility_Key|Salutation|Given_Names|Family_Name|NINO|DOB|isin|unused14|unused2|unused3|unused4|unused5|unused6|unused7|Partner_Salutation|Partner_Given_Names|Partner_Family_Name|Partner_NINO|Partner_DOB|unused8|unused9|unused10|unused11|unused12|unused13|Price|Currency_Code|Price_Date|Investment_Type|Transact_Portfolio_Number</FieldNames>
				<PreFormatXSLName>PreFormatTransactData.xsl</PreFormatXSLName>
				<Filter>
					<FilterKey>Facility_Key</FilterKey>
					<FilterValue>
						<xsl:value-of select="translate($PolicyNumber,&quot;-&quot;,&quot;&quot;)"/>
					</FilterValue>
				</Filter>
			</ProcessResponseInstructions>
		</RequestList>
	</xsl:template>
</xsl:stylesheet>',2 UNION ALL 
        SELECT 18, 'Seven Investment Management', '<!--Valuation Request XSL: Seven Investment Management-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<xsl:variable name="ProviderKey"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/></xsl:variable>
		<xsl:element name="request">
			<xsl:attribute name="type">holdings</xsl:attribute>
			<xsl:attribute name="id">
				<xsl:value-of select="substring-after($ProviderKey,'','')"/>
			</xsl:attribute>
			<xsl:attribute name="ifa">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/>
			</xsl:attribute>
			<xsl:attribute name="password">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PortalPassword"/>
			</xsl:attribute>
			<xsl:element name="client">
				<xsl:attribute name="id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 19, 'Legal &amp; General - Pensions and Bonds ONLY v2 UniPass', '<!--Valuation Request XSL: Legal &amp; General - Pensions and Bonds ONLY v2 - UniPass-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
			<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd</xsl:attribute>
		</xsl:if>
		<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
			<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEBondSingleContractRequest.xsd</xsl:attribute>
		</xsl:if>
			<mtg:m_control id="m_control1">
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">IntelliFlo Ltd</xsl:element>
				<!--KeyInfo Block -->
				<mtg:KeyInfo>
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</mtg:KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:text>Legal &amp; General</xsl:text>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content id="m_content1">
				<xsl:element name="ce:b_control">
					<xsl:element name="ce:contract_enquiry_reference">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:request_scope">
					<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
					<xsl:element name="ce:valuation_currency">GBP</xsl:element>
					<xsl:element name="ce:fund_code_type_required">MEX</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:attribute name="ce:type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
							<xsl:attribute name="ce:type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
							<xsl:attribute name="ce:type">Surrender</xsl:attribute>
						</xsl:if>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:contract">
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>
',1 UNION ALL 
        SELECT 20, 'The Hartford - Bonds v2 ONLY', '<!--Valuation Request XSL: The Hartford - Bonds v2 ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.origostandards.com/schema/ce/v2 CEBondSingleContractRequest.xsd">
			<mtg:m_control id="m_control1">
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">Intelliflo Ltd</xsl:element>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content id="m_content1">
				<xsl:element name="ce:b_control">
					<xsl:element name="ce:contract_enquiry_reference">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:intermediary">
					<xsl:element name="ce:sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="ce:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="ce:agency_address">
						<xsl:element name="ce:postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:request_scope">
					<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
					<xsl:element name="ce:valuation_currency">GBP</xsl:element>
					<xsl:element name="ce:fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:attribute name="ce:type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:attribute name="ce:type">Surrender</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:contract">
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 21, 'Axa Sun Life - Pensions and Bonds ONLY - UniPass', '<!--Valuation Request XSL: Axa Sun Life - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<RequestList Cache_Control="no-store" Accept="text/xml" Accept_Charset="ISO-8859-1" Accept_Language="en-gb" Accept_Encoding="none" Content_Type="text/xml" Content_Encoding="none" Content_Language="en-gb">
			<ProcessRequestInstructions>
				<xsl:element name="SubmitAs">namevaluepairwithxml</xsl:element>
			</ProcessRequestInstructions>
			<AccountInformationRequest>
				<message>
					<m_control>
						<xsl:element name="control_timestamp">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
						</xsl:element>
						<xsl:element name="message_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
						</xsl:element>
						<xsl:element name="retry_number">0</xsl:element>
						<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
						<xsl:element name="message_version">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
						</xsl:element>
						<xsl:element name="expected_response_type">synchronous</xsl:element>
						<xsl:element name="initiator_id">IntelliFlo Ltd</xsl:element>
						<!--KeyInfo Block -->
						<KeyInfo>
							<X509Data>
								<X509IssuerSerial>
									<xsl:element name="X509IssuerName">
										<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
									</xsl:element>
									<xsl:element name="X509SerialNumber">
										<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
									</xsl:element>
								</X509IssuerSerial>
								<xsl:element name="X509SubjectName">
									<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
								</xsl:element>
							</X509Data>
						</KeyInfo>
						<xsl:element name="responder_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
						</xsl:element>
					</m_control>
					<m_content>
						<b_control>
							<contract_enquiry_reference>
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
							</contract_enquiry_reference>
						</b_control>
						<intermediary>
							<xsl:element name="sib_number">071371</xsl:element>
							<xsl:element name="company_name">
								<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
							</xsl:element>
							<agency_address>
								<xsl:element name="postcode">KT1 1LF</xsl:element>
							</agency_address>
						</intermediary>
						<xsl:element name="request_scope">
							<xsl:element name="valuation_currency">GBP</xsl:element>
							<!-- <xsl:element name="fund_code_type_required">SEDOL</xsl:element> not need -->
							<xsl:element name="valuation_request">
								<xsl:attribute name="type">Current</xsl:attribute>
							</xsl:element>
							<xsl:element name="valuation_request">
								<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
									<xsl:attribute name="type">Transfer</xsl:attribute>
								</xsl:if>
								<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
									<xsl:attribute name="type">Surrender</xsl:attribute>
								</xsl:if>
							</xsl:element>
							<xsl:element name="fund_breakdown_request">
								<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
							</xsl:element>
						</xsl:element>
						<contract>
							<xsl:element name="contract_reference_number">
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
							</xsl:element>
						</contract>
					</m_content>
				</message>
			</AccountInformationRequest>
		</RequestList>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 22, 'Zurich - Pensions and Bonds v2 - Unipass', '<!--Valuation Request XSL: Zurich - Pensions and Bonds v2 - Unipass-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
				<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd</xsl:attribute>
			</xsl:if>
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
				<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEBondSingleContractRequest.xsd</xsl:attribute>
			</xsl:if>
			<mtg:m_control id="m_control1">
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">Intelliflo Limited</xsl:element>
				<!-- KeyInfo Block - From Intelliflo Company Unipass Certificate -->
				<!-- Just assign the certificate to a user and then run through the BuildRequestMessage method in CValuation -->
				<mtg:KeyInfo id="keyinfo">
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:text>O=Origo Secure Internet Services Ltd, CN=Origo Root CA - G2M</xsl:text>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:text>31779825660990839099896382404422450464</xsl:text>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:text>EMAIL=unipass@intelliflo.com, CN=Intelliflo Plc, OU=BPKT1 2BQ, OU=INTELLIFLO LIMITED, OU=CompanyOID2xx3400010071371KT12BQ, OU=Warning/Terms of Use - www.unipass.co.uk/tou, OU=CPS - www.unipass.co.uk/cps, O=FirmID3400010071371KT12BQ,C=GB</xsl:text>
						</xsl:element>
					</ds:X509Data>
				</mtg:KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content id="m_content1">
				<xsl:element name="ce:b_control">
					<xsl:element name="ce:contract_enquiry_reference">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:intermediary">
					<xsl:element name="ce:sib_number">
						<xsl:choose>
							<xsl:when test="/RequestVariables/RequestVariable/@GroupFSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@GroupFSA"/>
							</xsl:when>
							<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="ce:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="ce:agency_address">
						<xsl:element name="ce:postcode">
							<xsl:value-of select="translate(/RequestVariables/RequestVariable/@CertificatePostCode, &quot;abcdefghijklmnopqrstuvwxyz&quot;, &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:request_scope">
					<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
					<xsl:element name="ce:valuation_currency">GBP</xsl:element>
					<xsl:element name="ce:fund_code_type_required">MEX</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:attribute name="ce:type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
							<xsl:attribute name="ce:type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
							<xsl:attribute name="ce:type">Surrender</xsl:attribute>
						</xsl:if>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:contract">
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>',5 UNION ALL 
        SELECT 23, 'Zurich - Collective Investments v1.2 - Unipass', '<!--Valuation Request XSL: Zurich - Collective Investments v1.2-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message xmlns="http://www.origoservices.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xsi:schemaLocation="http://www.origoservices.com CECIVValuationRequest.xsd">
			<m_control>
				<xsl:element name="control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="retry_number">0</xsl:element>
				<xsl:element name="message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="expected_response_type">synchronous</xsl:element>
				<xsl:element name="initiator_id">Intelliflo Limited</xsl:element>
				<!-- KeyInfo Block - From Intelliflo Company Unipass Certificate -->
				<!-- Just assign the certificate to a user and then run through the BuildRequestMessage method in CValuation -->
				<KeyInfo id="keyinfo">
					<X509Data>
						<X509IssuerSerial>
							<xsl:element name="X509IssuerName">
								<xsl:text>O=Origo Secure Internet Services Ltd, CN=Origo Root CA - G2M</xsl:text>
							</xsl:element>
							<xsl:element name="X509SerialNumber">
								<xsl:text>31779825660990839099896382404422450464</xsl:text>
							</xsl:element>
						</X509IssuerSerial>
						<xsl:element name="X509SubjectName">
							<xsl:text>EMAIL=unipass@intelliflo.com, CN=Intelliflo Plc, OU=BPKT1 2BQ, OU=INTELLIFLO LIMITED, OU=CompanyOID2xx3400010071371KT12BQ, OU=Warning/Terms of Use - www.unipass.co.uk/tou, OU=CPS - www.unipass.co.uk/cps, O=FirmID3400010071371KT12BQ,C=GB</xsl:text>
						</xsl:element>
					</X509Data>
				</KeyInfo>
				<xsl:element name="responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</m_control>
			<m_content id="m_content1">
				<xsl:element name="intermediary">
					<xsl:element name="sib_number">
						<xsl:choose>
							<xsl:when test="/RequestVariables/RequestVariable/@GroupFSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@GroupFSA"/>
							</xsl:when>
							<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="agency_address">
						<xsl:element name="postcode">
							<xsl:value-of select="translate(/RequestVariables/RequestVariable/@CertificatePostCode, &quot;abcdefghijklmnopqrstuvwxyz&quot;, &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="request_scope">
					<xsl:element name="valuation_currency">GBP</xsl:element>
					<xsl:element name="fund_code_type_required">MEX</xsl:element>
					<xsl:element name="valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="fund_breakdown_request">
						<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
					<xsl:element name="transaction_history_request">
						<xsl:element name="summary_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="contract">
					<xsl:element name="contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',5 UNION ALL 
        SELECT 24, 'Scottish Widows -  Bonds v2 - UniPass', '<!--Valuation Request XSL: Scottish Widows - Pensions and Bonds v2 - UniPass-->
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
		<xsl:template match="/">
			<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
				<mtg:m_control>
					<xsl:element name="mtg:control_timestamp">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
					</xsl:element>
					<xsl:element name="mtg:message_id">
						<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
					</xsl:element>
					<xsl:element name="mtg:retry_number">0</xsl:element>
					<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
					<xsl:element name="mtg:message_version">
						<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
					</xsl:element>
					<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
					<xsl:element name="mtg:initiator_id">Intelliflo Ltd</xsl:element>
					<!--KeyInfo Block -->
					<mtg:KeyInfo>
						<ds:X509Data>
							<ds:X509IssuerSerial>
								<xsl:element name="ds:X509IssuerName">
									<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
								</xsl:element>
								<xsl:element name="ds:X509SerialNumber">
									<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
								</xsl:element>
							</ds:X509IssuerSerial>
							<xsl:element name="ds:X509SubjectName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
							</xsl:element>
						</ds:X509Data>
					</mtg:KeyInfo>
					<xsl:element name="mtg:responder_id">
						<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
					</xsl:element>
				</mtg:m_control>
				<ce:m_content id="m_content1">
					<xsl:element name="ce:intermediary">
						<xsl:element name="ce:sib_number">
							<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
						</xsl:element>
						<xsl:element name="ce:company_name">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
						</xsl:element>
						<xsl:element name="ce:agency_address">
							<xsl:element name="ce:postcode">
								<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="ce:request_scope">
						<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
						<xsl:element name="ce:valuation_currency">GBP</xsl:element>
						<xsl:element name="ce:fund_code_type_required">SEDOL</xsl:element>
						<xsl:element name="ce:valuation_request">
							<xsl:attribute name="ce:type">Current</xsl:attribute>
						</xsl:element>
						<xsl:element name="ce:valuation_request">
							<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
								<xsl:attribute name="ce:type">Transfer</xsl:attribute>
							</xsl:if>
							<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
								<xsl:attribute name="ce:type">Surrender</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</xsl:element>
					<xsl:element name="ce:contract">
						<xsl:element name="ce:contract_reference_number">
							<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
						</xsl:element>
					</xsl:element>
				</ce:m_content>
			</mtg:message>
		</xsl:template>
	</xsl:stylesheet>',2 UNION ALL 
        SELECT 25, 'Scottish Widows - Collective Investments v1.2 - Unipass', '<!--Valuation Request XSL: Scottish Widows - Collective Investments v1.2 - Unipass-->
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
		<xsl:template match="/">
			<message xmlns="http://www.origoservices.com" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<mtg:m_control>
					<xsl:element name="mtg:control_timestamp">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
					</xsl:element>
					<xsl:element name="mtg:message_id">
						<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
					</xsl:element>
					<xsl:element name="mtg:retry_number">0</xsl:element>
					<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
					<xsl:element name="mtg:message_version">
						<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
					</xsl:element>
					<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
					<xsl:element name="mtg:initiator_id">Intelliflo Ltd</xsl:element>
					<!--KeyInfo Block -->
					<mtg:KeyInfo>
						<ds:X509Data>
							<ds:X509IssuerSerial>
								<xsl:element name="ds:X509IssuerName">
									<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
								</xsl:element>
								<xsl:element name="ds:X509SerialNumber">
									<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
								</xsl:element>
							</ds:X509IssuerSerial>
							<xsl:element name="ds:X509SubjectName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
							</xsl:element>
						</ds:X509Data>
					</mtg:KeyInfo>
					<xsl:element name="mtg:responder_id">
						<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
					</xsl:element>
				</mtg:m_control>
				<m_content id="m_content1">
					<xsl:element name="intermediary">
						<xsl:element name="sib_number">
							<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
						</xsl:element>
						<xsl:element name="company_name">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
						</xsl:element>
						<xsl:element name="agency_address">
							<xsl:element name="postcode">
								<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="request_scope">
						<xsl:element name="valuation_currency">GBP</xsl:element>
						<xsl:element name="fund_code_type_required">SEDOL</xsl:element>
						<xsl:element name="valuation_request">
							<xsl:attribute name="type">Current</xsl:attribute>
						</xsl:element>
						<xsl:element name="fund_breakdown_request">
							<xsl:element name="detailed_breakdown_ind">Yes</xsl:element>
						</xsl:element>
						<xsl:element name="transaction_history_request">
							<xsl:element name="summary_ind">Yes</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="contract">
						<xsl:element name="contract_reference_number">
							<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
						</xsl:element>
					</xsl:element>
				</m_content>
			</message>
		</xsl:template>
	</xsl:stylesheet>',1 UNION ALL 
        SELECT 26, 'Friends Provident - WOL and Endowments v2 - Unipass', '<!--Valuation Request XSL: Friends Provident - WOL and Endowments v2 - Unipass-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductVersion=&quot;/origo/2.0/CEWOLSingleContractRequest.xsd&quot;">
				<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEWOLSingleContractRequest.xsd</xsl:attribute>
			</xsl:if>
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductVersion=&quot;/origo/2.0/CEEndowmentSingleContractRequest.xsd&quot;">
				<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEEndowmentSingleContractRequest.xsd</xsl:attribute>
			</xsl:if>
			<mtg:m_control id="m_control1">
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">Intelliflo Plc</xsl:element>
				<!--KeyInfo Block -->
				<KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content>
				<ce:b_control>
					<xsl:element name="ce:contract_enquiry_reference">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</ce:b_control>
				<ce:intermediary/>
				<ce:request_scope>
					<ce:contract_details_required_ind>Yes</ce:contract_details_required_ind>
					<ce:fund_code_type_required>SEDOL</ce:fund_code_type_required>
					<ce:valuation_request ce:type="Current"> </ce:valuation_request>
					<ce:valuation_request ce:type="Surrender"> </ce:valuation_request>
				</ce:request_scope>
				<ce:contract>
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</ce:contract>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 27, 'Winterthur-Life - Pensions and Bonds ONLY', '<!--Valuation Request XSL: Winterthur-Life - Pensions and Bonds ONLY-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<RequestList Content_Type="application/x-www-form-urlencoded">
			<ProcessRequestInstructions>
				<xsl:element name="Intelliflo_Portal_UserNameTag">userName</xsl:element>
				<xsl:element name="Intelliflo_Portal_Username"><xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/></xsl:element>
				<xsl:element name="Intelliflo_Portal_PasswordTag">passWord</xsl:element>
				<xsl:element name="Intelliflo_Portal_Password"><xsl:value-of select="/RequestVariables/RequestVariable/@PortalPassword"/></xsl:element>
				<xsl:element name="SubmitAs">namevaluepairwithxml</xsl:element>
			</ProcessRequestInstructions>
			<AccountInformationRequest>
				<xsl:text>xmlData=</xsl:text>
				<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
					<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
						<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd</xsl:attribute>
					</xsl:if>
					<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
						<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEBondSingleContractRequest.xsd</xsl:attribute>
					</xsl:if>
					<mtg:m_control id="m_control1">
						<xsl:element name="mtg:control_timestamp">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
						</xsl:element>
						<xsl:element name="mtg:message_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
						</xsl:element>
						<xsl:element name="mtg:retry_number">0</xsl:element>
						<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
						<xsl:element name="mtg:message_version">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
						</xsl:element>
						<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
						<xsl:element name="mtg:initiator_id">IntelliFlo Limited</xsl:element>
						<xsl:element name="mtg:responder_id">
							<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
						</xsl:element>
					</mtg:m_control>
					<ce:m_content id="m_content1">
						<xsl:element name="ce:b_control">
							<xsl:element name="ce:contract_enquiry_reference">
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
							</xsl:element>
						</xsl:element>
						<xsl:element name="ce:intermediary">
							<xsl:element name="ce:sib_number">
								<xsl:choose>
									<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; ">
										<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:element name="ce:company_name">
								<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
							</xsl:element>
							<xsl:element name="ce:agency_address">
								<xsl:element name="ce:postcode">
									<xsl:value-of select="translate(/RequestVariables/RequestVariable/@Postcode, &quot;abcdefghijklmnopqrstuvwxyz&quot;, &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:element name="ce:request_scope">
							<xsl:element name="ce:contract_details_required_ind">No</xsl:element>
							<xsl:element name="ce:valuation_currency">GBP</xsl:element>
							<xsl:element name="ce:fund_code_type_required">MEX</xsl:element>
							<xsl:element name="ce:valuation_request">
								<xsl:attribute name="ce:type">Current</xsl:attribute>
							</xsl:element>
						</xsl:element>
						<xsl:element name="ce:contract">
							<xsl:element name="ce:contract_reference_number">
								<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
							</xsl:element>
						</xsl:element>
					</ce:m_content>
				</mtg:message>
				<xsl:text/>
			</AccountInformationRequest>
		</RequestList>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 28, 'Merchant Investors - Pensions and Bonds v2', '<!--Valuation Request XSL: Merchant Investors - Pensions and Bonds v2-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:choose>
				<xsl:when test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
					<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEBondSingleContractRequest.xsd</xsl:attribute>	
				</xsl:otherwise>
			</xsl:choose>
			<mtg:m_control id="m_control1">
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">IntelliFlo Limited</xsl:element>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content id="m_content1">
				<xsl:element name="ce:b_control">
					<xsl:element name="ce:contract_enquiry_reference">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:intermediary">
					<xsl:element name="ce:sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="ce:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="ce:agency_address">
						<xsl:element name="ce:postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:request_scope">
					<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
					<xsl:element name="ce:valuation_currency">GBP</xsl:element>
					<xsl:element name="ce:fund_code_type_required">MEX</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:attribute name="ce:type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:choose>
							<xsl:when test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
								<xsl:attribute name="ce:type">Transfer</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="ce:type">Surrender</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:contract">
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>',3 UNION ALL 
        SELECT 29, 'Axa Distribution Services - WRAP', '<!--Valuation Request XSL: Axa Distribution Services - WRAP-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<origo:message xsi:schemaLocation="http://www.origoservices.com CECIVValuationRequest_AXA.XSD" xmlns:origo="http://www.origoservices.com" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<origo:m_control>
				<xsl:element name="origo:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="origo:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="origo:retry_number">0</xsl:element>
				<xsl:element name="origo:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="origo:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="origo:expected_response_type">synchronous</xsl:element>
				<xsl:element name="origo:initiator_id">Intelliflo Ltd</xsl:element>
				<!--	Place holder for later use
				<origo:KeyInfo>
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<ds:X509IssuerName>CN=OSIS Customer CA,O=Origo Secure Internet Services Ltd.</ds:X509IssuerName>
							<ds:X509SerialNumber>28702490996215021326241542053521020772</ds:X509SerialNumber>
						</ds:X509IssuerSerial>
						<ds:X509SubjectName>C=GB, O=FirmID2500010001204162853IV170PS, OU=CPS - www.osis.uk.com/repository/osiscps.pdf, OU=Warning/Terms of Use - www.osis.uk.com/repository/tou.pdf, OU=EmployeeID01400010001204, OU=PORTFOLIO MEMBER SERVICES LTD, OU=BPME14 5EG, CN=Hilary Leek, EMAIL=david.rose@axa-sunlife.co.uk</ds:X509SubjectName>
					</ds:X509Data>
				</origo:KeyInfo> -->
				<xsl:element name="origo:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</origo:m_control>
			<origo:m_content>
				<origo:b_control>
					<origo:contract_enquiry_reference><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/></origo:contract_enquiry_reference>
					<!-- MUST BE A UNIQUIE ID FOR REQUEST RESPONSE PAIR but a GUID is too big!</-->
				</origo:b_control>
				<xsl:element name="origo:intermediary">
					<xsl:element name="origo:sib_number">
						<xsl:choose>
							<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; "><xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="origo:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="origo:agency_number"/>
					<xsl:element name="origo:agency_address">
						<xsl:element name="origo:postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="origo:contact_details">
						<xsl:attribute name="id"><xsl:value-of select="/RequestVariables/RequestVariable/@AdviserFSA"/></xsl:attribute>
						<!-- This id could be the FSA Individual Reference number -->
						<xsl:element name="origo:name">
							<xsl:value-of select="/RequestVariables/RequestVariable/@AdviserName"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			<xsl:element name="origo:request_scope">
					<xsl:element name="origo:valuation_currency">GBP</xsl:element>
					<xsl:element name="origo:fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="origo:valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="origo:fund_breakdown_request">
						<xsl:element name="origo:detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
					<xsl:element name="origo:transaction_history_request">
						<xsl:element name="origo:summary_ind">No</xsl:element>
						<!-- Transaction History functionality will not be implemented for Elevate Phase 1 -->
					</xsl:element>
				</xsl:element>
				<xsl:element name="origo:contract">
					<xsl:element name="origo:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
					<!-- Wrap Account Number -->
				</xsl:element>
			</origo:m_content>
		</origo:message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 30, 'Canada Life - Pensions and Bonds v2 - UniPass', '<!--Valuation Request XSL: Canada Life - Pensions and Bonds v2 - UniPass-->
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
		<xsl:template match="/">
			<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
				<mtg:m_control>
					<xsl:element name="mtg:control_timestamp">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
					</xsl:element>
					<xsl:element name="mtg:message_id">
						<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
					</xsl:element>
					<xsl:element name="mtg:retry_number">0</xsl:element>
					<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
					<xsl:element name="mtg:message_version">
						<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
					</xsl:element>
					<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
					<xsl:element name="mtg:initiator_id">IntelliFlo Ltd</xsl:element>
					<!--KeyInfo Block -->
					<mtg:KeyInfo>
						<ds:X509Data>
							<ds:X509IssuerSerial>
								<xsl:element name="ds:X509IssuerName">
									<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
								</xsl:element>
								<xsl:element name="ds:X509SerialNumber">
									<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
								</xsl:element>
							</ds:X509IssuerSerial>
							<xsl:element name="ds:X509SubjectName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
							</xsl:element>
						</ds:X509Data>
					</mtg:KeyInfo>
					<xsl:element name="mtg:responder_id">
						<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
					</xsl:element>
				</mtg:m_control>
				<ce:m_content id="m_content1">
					<ce:b_control>
						<xsl:element name="ce:contract_enquiry_reference">
							<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
						</xsl:element>
					</ce:b_control>
					<xsl:element name="ce:intermediary">
						<xsl:element name="ce:sib_number">
							<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
						</xsl:element>
						<xsl:element name="ce:company_name">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
						</xsl:element>
						<xsl:element name="ce:agency_address">
							<xsl:element name="ce:postcode">
								<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="ce:request_scope">
						<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
						<xsl:element name="ce:valuation_currency">GBP</xsl:element>
						<xsl:element name="ce:fund_code_type_required">SEDOL</xsl:element>
						<xsl:element name="ce:valuation_request">
							<xsl:attribute name="ce:type">Current</xsl:attribute>
						</xsl:element>
						<xsl:element name="ce:valuation_request">
							<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
								<xsl:attribute name="ce:type">Transfer</xsl:attribute>
							</xsl:if>
							<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
								<xsl:attribute name="ce:type">Surrender</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</xsl:element>
					<xsl:element name="ce:contract">
						<xsl:element name="ce:contract_reference_number">
							<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
						</xsl:element>
					</xsl:element>
				</ce:m_content>
			</mtg:message>
		</xsl:template>
	</xsl:stylesheet>',1 UNION ALL 
        SELECT 31, 'Canada Life - Endowment v2.0 - Unipass', '<!--Valuation Request XSL: Canada Life - Endowment v2.0 - Unipass-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<mtg:m_control>
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">Intelliflo Ltd</xsl:element>
				<!--KeyInfo Block -->
				<mtg:KeyInfo>
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</mtg:KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content>
				<ce:b_control>
					<xsl:element name="ce:contract_enquiry_reference">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</xsl:element>
				</ce:b_control>
				<ce:intermediary/>
				<ce:request_scope>
					<ce:contract_details_required_ind>Yes</ce:contract_details_required_ind>
					<ce:fund_code_type_required>SEDOL</ce:fund_code_type_required>
					<ce:valuation_request ce:type="Current"> </ce:valuation_request>
					<ce:valuation_request ce:type="Surrender"> </ce:valuation_request>
				</ce:request_scope>
				<ce:contract>
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</ce:contract>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 32, 'Scottish Life - Pensions and Bonds ONLY v2 - Unipass', '<!--Valuation Request XSL: Scottish Life - Pensions and Bonds ONLY v2 - Unipass-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd">
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
				<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd</xsl:attribute>
			</xsl:if>
			<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
				<xsl:attribute name="xsi:schemaLocation">http://www.origostandards.com/schema/ce/v2 CEBondSingleContractRequest.xsd</xsl:attribute>
			</xsl:if>
			<mtg:m_control id="m_control1">
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">IntelliFlo Ltd</xsl:element>
				<!--KeyInfo Block -->
				<mtg:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</mtg:KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content>
				<ce:intermediary>
					<xsl:element name="ce:sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="ce:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<ce:agency_address>
						<xsl:element name="ce:postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</ce:agency_address>
				</ce:intermediary>
				<ce:request_scope>
					<ce:contract_details_required_ind>Yes</ce:contract_details_required_ind>
					<ce:valuation_currency>GBP</ce:valuation_currency>
					<ce:fund_code_type_required>SEDOL</ce:fund_code_type_required>
					<ce:valuation_request ce:type="Current"> </ce:valuation_request>
					<xsl:element name="ce:valuation_request">
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
							<xsl:attribute name="ce:type">Transfer</xsl:attribute>
						</xsl:if>
						<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
							<xsl:attribute name="ce:type">Surrender</xsl:attribute>
						</xsl:if>
					</xsl:element>
				</ce:request_scope>
				<ce:contract>
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</ce:contract>
			</ce:m_content>
		</mtg:message>
	</xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 33, 'Skandia Investment Solutions v1.2', '<!--Valuation Request XSL: Skandia Investment Solutions v1.2-->  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">    <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>    <xsl:template match="/">      <message>        <m_control>          <xsl:element name="control_timestamp">            <xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>          </xsl:element>          <xsl:element name="message_id">            <xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>          </xsl:element>          <xsl:element name="retry_number">0</xsl:element>          <xsl:element name="message_type">Contract Enquiry Request</xsl:element>          <xsl:element name="message_version">            <xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>          </xsl:element>          <xsl:element name="expected_response_type">synchronous</xsl:element>          <xsl:element name="initiator_id">Intelliflo Ltd</xsl:element>                  <xsl:element name="responder_id">            <xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>          </xsl:element>        </m_control>        <m_content>          <xsl:element name="intermediary">            <xsl:element name="sib_number">              <xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>            </xsl:element>            <xsl:element name="company_name">              <xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>            </xsl:element>            <xsl:element name="agency_address">              <xsl:element name="postcode">                <xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>              </xsl:element>            </xsl:element>          </xsl:element>          <xsl:element name="request_scope">            <xsl:element name="valuation_currency">GBP</xsl:element>            <xsl:element name="fund_code_type_required">MEX</xsl:element>            <xsl:element name="valuation_request">              <xsl:attribute name="type">Current</xsl:attribute>            </xsl:element>            <xsl:element name="fund_breakdown_request">              <xsl:element name="detailed_breakdown_ind">Yes</xsl:element>            </xsl:element>            <xsl:element name="transaction_history_request">              <xsl:element name="summary_ind">Yes</xsl:element>            </xsl:element>          </xsl:element>          <xsl:element name="contract">            <xsl:element name="contract_reference_number">              <xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>            </xsl:element>          </xsl:element>        </m_content>      </message>    </xsl:template>  </xsl:stylesheet>',1 UNION ALL 
        SELECT 34, 'Skandia Investment Solutions v1.2 - Bonds', '<!--Valuation Request XSL: Skandia Investment Solutions v1.2 - Bonds-->  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">    <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>    <xsl:template match="/">      <message>        <m_control>          <xsl:element name="control_timestamp">            <xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>          </xsl:element>          <xsl:element name="message_id">            <xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>          </xsl:element>          <xsl:element name="retry_number">0</xsl:element>          <xsl:element name="message_type">Contract Enquiry Request</xsl:element>          <xsl:element name="message_version">            <xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>          </xsl:element>          <xsl:element name="expected_response_type">synchronous</xsl:element>          <xsl:element name="initiator_id">Intelliflo Ltd</xsl:element>          <xsl:element name="responder_id">            <xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>          </xsl:element>        </m_control>        <m_content>          <xsl:element name="intermediary">            <xsl:element name="sib_number">              <xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>            </xsl:element>            <xsl:element name="company_name">              <xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>            </xsl:element>            <xsl:element name="agency_address">              <xsl:element name="postcode">                <xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>              </xsl:element>            </xsl:element>          </xsl:element>          <xsl:element name="request_scope">            <xsl:element name="valuation_currency">GBP</xsl:element>            <xsl:element name="fund_code_type_required">MEX</xsl:element>            <xsl:element name="valuation_request">              <xsl:attribute name="type">Current</xsl:attribute>            </xsl:element>            <xsl:element name="fund_breakdown_request">              <xsl:element name="detailed_breakdown_ind">Yes</xsl:element>            </xsl:element>          </xsl:element>          <xsl:element name="contract">            <xsl:element name="contract_reference_number">              <xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>            </xsl:element>          </xsl:element>              </m_content>      </message>    </xsl:template>  </xsl:stylesheet>',1 UNION ALL 
        SELECT 35, 'LV - Pensions ONLY - Unipass', '<!--Valuation Request XSL: LV - Pensions ONLY - Unipass-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
    <xsl:template match="/">
	<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.origostandards.com/schema/ce/v2 CEPensionSingleContractRequest.xsd">
            <mtg:m_control id="m_control">
                <xsl:element name="mtg:control_timestamp"><xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/></xsl:element>
                <xsl:element name="mtg:message_id"><xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/> </xsl:element>
                <xsl:element name="mtg:retry_number">0</xsl:element>
                <xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
                <xsl:element name="mtg:message_version"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/></xsl:element>
                <xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
                <xsl:element name="mtg:initiator_id">Intelliflo Ltd</xsl:element>
                <!--KeyInfo Block -->
                <mtg:KeyInfo Id="keyinfo1">
                    <ds:X509Data>
                        <ds:X509IssuerSerial>
                            <xsl:element name="ds:X509IssuerName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/></xsl:element>
                            <xsl:element name="ds:X509SerialNumber"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/></xsl:element>
                        </ds:X509IssuerSerial>
                        <xsl:element name="ds:X509SubjectName"><xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/></xsl:element>
                    </ds:X509Data>
                </mtg:KeyInfo>              
                <xsl:element name="mtg:responder_id"><xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/></xsl:element>
            </mtg:m_control>
            <ce:m_content id="m_content">
                <ce:b_control>
                    <ce:contract_enquiry_reference><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/></ce:contract_enquiry_reference>
                </ce:b_control>
				<ce:intermediary>
					<xsl:element name="ce:sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="ce:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<ce:agency_address>
						<xsl:element name="ce:postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</ce:agency_address>
				</ce:intermediary>
				<xsl:element name="ce:request_scope">
					<xsl:element name="ce:contract_details_required_ind">No</xsl:element>
						<xsl:element name="ce:valuation_currency">GBP</xsl:element>
						<xsl:element name="ce:fund_code_type_required">SEDOL</xsl:element>
						<xsl:element name="ce:valuation_request">
							<xsl:attribute name="ce:type">Current</xsl:attribute>
						</xsl:element>
	  				<xsl:element name="ce:valuation_request">
					<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
						<xsl:attribute name="ce:type">Transfer</xsl:attribute>
					</xsl:if>
					<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
						<xsl:attribute name="ce:type">Surrender</xsl:attribute>
					</xsl:if>							
					</xsl:element>
                </xsl:element>
                <ce:contract>
                    <xsl:element name="ce:contract_reference_number"><xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/></xsl:element>
                </ce:contract>
            </ce:m_content>
        </mtg:message>
    </xsl:template>
</xsl:stylesheet>',1 UNION ALL 
        SELECT 36, 'Standard Life - WRAP v1.0', '<!--Valuation Request XSL: Standard Life - WRAP v1.0-->
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
			  <xsl:template match="/">
				<mtg:message xmlns:gwreq="http://www.origostandards.com/schema/ProvideContractValuation/v1.0/GetWrapRequest" 
						xmlns:cvtypes="http://www.origostandards.com/schema/ProvideContractValuation/v1.0/Common/ContractValuationTypes"
						xmlns:mtg="http://www.origostandards.com/schema/mtg/v2"
						xmlns:ds="http://www.w3.org/2000/09/xmldsig#" 
						xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
						xsi:schemaLocation="http://www.origostandards.com/schema/ProvideContractValuation/v1.0/GetWrapRequest GetWrapValuationMTGRequest.xsd">
				  <mtg:m_control>
					<xsl:element name="mtg:control_timestamp">
					  <xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
					</xsl:element>
					<xsl:element name="mtg:message_id">
					  <xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
					</xsl:element>
					<xsl:element name="mtg:retry_number">0</xsl:element>
					<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
					<xsl:element name="mtg:message_version">
					  <xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
					</xsl:element>
					<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
					<xsl:element name="mtg:initiator_id">Intelliflo Plc</xsl:element>
					<!--KeyInfo Block -->
					<mtg:KeyInfo>
					  <ds:X509Data>
						<ds:X509IssuerSerial>
						  <xsl:element name="ds:X509IssuerName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
						  </xsl:element>
						  <xsl:element name="ds:X509SerialNumber">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
						  </xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
						  <xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					  </ds:X509Data>
					</mtg:KeyInfo>
					<xsl:element name="mtg:responder_id">
					  <xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
					</xsl:element>
				  </mtg:m_control>

				  <xsl:element name="gwreq:m_content">
					<xsl:element name="gwreq:intermediary">
					  <xsl:element name="cvtypes:FirmFSARef">
						<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
					  </xsl:element>
					</xsl:element>
					<xsl:element name="gwreq:contract_reference_number">
					  <xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
					<xsl:element name="gwreq:request_scope">
					  <xsl:element name="gwreq:valuation_currency">GBP</xsl:element>
					  <xsl:element name="gwreq:fund_code_type_required">CITICODE</xsl:element>
					  <xsl:element name="gwreq:share_code_type_required">SEDOL</xsl:element>
					  <xsl:element name="gwreq:share_price_type_required">Bid</xsl:element>
					</xsl:element>
				  </xsl:element>
				</mtg:message>
			  </xsl:template>
			</xsl:stylesheet>',1 UNION ALL 
        SELECT 37, 'Zurich Wrap', '<!--Valuation Request XSL: Zurich Intermediate Pl - WRAP-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<xsl:variable name="agencyFSA">
			<xsl:choose>
				<xsl:when test="/RequestVariables/RequestVariable/@AdviserFSA != &quot;&quot; ">
					<xsl:value-of select="/RequestVariables/RequestVariable/@AdviserFSA"/>
				</xsl:when>
				<xsl:when test="/RequestVariables/RequestVariable/@GroupFSA != &quot;&quot; ">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GroupFSA"/>
				</xsl:when>
				<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; ">
					<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<origo:message xsi:schemaLocation="http://www.origoservices.com CECIVValuationRequest.XSD" xmlns:origo="http://www.origoservices.com" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<origo:m_control>
				<xsl:element name="origo:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="origo:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="origo:retry_number">0</xsl:element>
				<xsl:element name="origo:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="origo:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="origo:expected_response_type">synchronous</xsl:element>
				<xsl:element name="origo:response_location"/>
				<xsl:element name="origo:initiator_id">Intelliflo Ltd</xsl:element>
				<xsl:element name="origo:user_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/>
				</xsl:element>
				<xsl:element name="origo:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
				<xsl:element name="origo:intermediary_case_reference_number">
					<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
				</xsl:element>
				<xsl:element name="origo:agency_reference">
					<xsl:value-of select="$agencyFSA"/>
				</xsl:element>
				<!-- Place holder for later use      <origo:KeyInfo>       <ds:X509Data>        <ds:X509IssuerSerial>         <ds:X509IssuerName>CN=OSIS Customer CA,O=Origo Secure Internet Services Ltd.</ds:X509IssuerName>         <ds:X509SerialNumber>28702490996215021326241542053521020772</ds:X509SerialNumber>        </ds:X509IssuerSerial>        <ds:X509SubjectName>C=GB, O=FirmID2500010001204162853IV170PS, OU=CPS - www.osis.uk.com/repository/osiscps.pdf, OU=Warning/Terms of Use - www.osis.uk.com/repository/tou.pdf, OU=EmployeeID01400010001204, OU=PORTFOLIO MEMBER SERVICES LTD, OU=BPME14 5EG, CN=Hilary Leek, EMAIL=david.rose@axa-sunlife.co.uk</ds:X509SubjectName>       </ds:X509Data>      </origo:KeyInfo> -->
			</origo:m_control>
			<origo:m_content>
				<origo:b_control>
					<origo:contract_enquiry_reference>
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyBusinessId"/>
					</origo:contract_enquiry_reference>
					<!-- MUST BE A UNIQUIE ID FOR REQUEST RESPONSE PAIR but a GUID is too big!</-->
				</origo:b_control>
				<xsl:element name="origo:intermediary">
					<xsl:element name="origo:sib_number">
						<xsl:choose>
							<xsl:when test="/RequestVariables/RequestVariable/@GroupFSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@GroupFSA"/>
							</xsl:when>
							<xsl:when test="/RequestVariables/RequestVariable/@FSA != &quot;&quot; ">
								<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="origo:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="origo:agency_number"/>
					<xsl:element name="origo:agency_address">
						<xsl:element name="origo:postcode">
							<xsl:value-of select="translate(/RequestVariables/RequestVariable/@Postcode, &quot;abcdefghijklmnopqrstuvwxyz&quot;, &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="origo:contact_details">
						<xsl:attribute name="id"><xsl:value-of select="$agencyFSA"/></xsl:attribute>
						<!-- This id could be the FSA Individual Reference number -->
						<xsl:element name="origo:name">
							<xsl:value-of select="/RequestVariables/RequestVariable/@AdviserName"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="origo:request_scope">
					<xsl:element name="origo:valuation_currency">GBP</xsl:element>
					<xsl:element name="origo:fund_code_type_required">ISIN</xsl:element>
					<xsl:element name="origo:valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="origo:fund_breakdown_request">
						<xsl:element name="origo:detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
					<xsl:element name="origo:transaction_history_request">
						<xsl:element name="origo:summary_ind">No</xsl:element>
						<!-- Transaction History functionality will not be implemented for Elevate Phase 1 -->
					</xsl:element>
				</xsl:element>
				<xsl:element name="origo:contract">
					<xsl:element name="origo:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
					<!-- Wrap Account Number -->
				</xsl:element>
			</origo:m_content>
		</origo:message>
	</xsl:template>
</xsl:stylesheet>',3 UNION ALL 
        SELECT 38, 'Scottish Widows - Pensions v2.2 - UniPass', '	<!--Valuation Request XSL: Scottish Widows - Pensions V2.2 - UniPass-->
				<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
					<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
					<xsl:template match="/">
						<mtg:message xmlns:ce="http://www.origostandards.com/schema/ce/v2.2/CEPensionSingleContractRequest" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origostandards.com/schema/mtg/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<mtg:m_control>
								<xsl:element name="mtg:control_timestamp">
									<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
								</xsl:element>
								<xsl:element name="mtg:message_id">
									<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
								</xsl:element>
								<xsl:element name="mtg:retry_number">0</xsl:element>
								<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
								<xsl:element name="mtg:message_version">
									<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
								</xsl:element>
								<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
								<xsl:element name="mtg:initiator_id">Intelliflo Ltd</xsl:element>
								<!--KeyInfo Block -->
								<mtg:KeyInfo>
									<ds:X509Data>
										<ds:X509IssuerSerial>
											<xsl:element name="ds:X509IssuerName">
												<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
											</xsl:element>
											<xsl:element name="ds:X509SerialNumber">
												<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
											</xsl:element>
										</ds:X509IssuerSerial>
										<xsl:element name="ds:X509SubjectName">
											<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
										</xsl:element>
									</ds:X509Data>
								</mtg:KeyInfo>
								<xsl:element name="mtg:responder_id">
									<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
								</xsl:element>
							</mtg:m_control>
							<ce:m_content id="m_content1">
								<xsl:element name="ce:intermediary">
									<xsl:element name="ce:sib_number">
										<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
									</xsl:element>
									<xsl:element name="ce:company_name">
										<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
									</xsl:element>
									<xsl:element name="ce:agency_address">
										<xsl:element name="ce:postcode">
											<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								<xsl:element name="ce:request_scope">
									<xsl:element name="ce:contract_details_required_ind">Yes</xsl:element>
									<xsl:element name="ce:valuation_currency">GBP</xsl:element>
									<xsl:element name="ce:fund_code_type_required">SEDOL</xsl:element>
									<xsl:element name="ce:valuation_request">
										<xsl:attribute name="ce:type">Current</xsl:attribute>
									</xsl:element>
									<xsl:element name="ce:valuation_request">
										<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Pension&quot;">
											<xsl:attribute name="ce:type">Transfer</xsl:attribute>
										</xsl:if>
										<xsl:if test="/RequestVariables/RequestVariable/@OrigoProductType=&quot;Bond&quot;">
											<xsl:attribute name="ce:type">Surrender</xsl:attribute>
										</xsl:if>
									</xsl:element>
								</xsl:element>
								<xsl:element name="ce:contract">
									<xsl:element name="ce:contract_reference_number">
										<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
									</xsl:element>
								</xsl:element>
							</ce:m_content>
						</mtg:message>
					</xsl:template>
				</xsl:stylesheet>',1 UNION ALL 
        SELECT 41, 'Standard Life - Collective Investments v1.3', '<!--Valuation Request XSL: Standard Life - Collective Investments v1.3-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<message xmlns="http://www.origostandards.com/schema/ce/v1.3/CECIVValuationRequest" xmlns:ce="http://www.origostandards.com/schema/ce/v1.3/CECIVValuationRequestMCONTENT" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:mtg="http://www.origoservices.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.origostandards.com/schema/ce/v1.3/CECIVValuationRequest CECIVValuationRequest.XSD"> 
			<mtg:m_control>
				<xsl:element name="mtg:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="mtg:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="mtg:retry_number">0</xsl:element>
				<xsl:element name="mtg:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="mtg:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="mtg:expected_response_type">synchronous</xsl:element>
				<xsl:element name="mtg:initiator_id">Intelliflo Plc</xsl:element>
				<!--KeyInfo Block -->
				<mtg:KeyInfo>
					<ds:X509Data>
						<ds:X509IssuerSerial>
							<xsl:element name="ds:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="ds:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</ds:X509IssuerSerial>
						<xsl:element name="ds:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</ds:X509Data>
				</mtg:KeyInfo>
				<xsl:element name="mtg:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
			</mtg:m_control>
			<ce:m_content>
				<xsl:element name="ce:intermediary">
					<xsl:element name="ce:sib_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@SIB"/>
					</xsl:element>
					<xsl:element name="ce:company_name">
						<xsl:value-of select="/RequestVariables/RequestVariable/@Identifier"/>
					</xsl:element>
					<xsl:element name="ce:agency_address">
						<xsl:element name="ce:postcode">
							<xsl:value-of select="/RequestVariables/RequestVariable/@Postcode"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:request_scope">
					<xsl:element name="ce:valuation_currency">GBP</xsl:element>
					<xsl:element name="ce:fund_code_type_required">CITICODE</xsl:element>
					<xsl:element name="ce:valuation_request">
						<xsl:attribute name="type">Current</xsl:attribute>
					</xsl:element>
					<xsl:element name="ce:fund_breakdown_request">
						<xsl:element name="ce:detailed_breakdown_ind">Yes</xsl:element>
					</xsl:element>
					<xsl:element name="ce:transaction_history_request">
						<xsl:element name="ce:summary_ind">Yes</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="ce:contract">
					<xsl:element name="ce:contract_reference_number">
						<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
					</xsl:element>
				</xsl:element>
			</ce:m_content>
		</message>
	</xsl:template>
</xsl:stylesheet>',4 UNION ALL 
        SELECT 42, 'James Hay - SIPP and Wrap', '<!--Valuation Request XSL: JamesHay - Wrap and NonWrap - NonUnipass - Form based with Content-Type header = application/x-www-form-urlencoded-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
		<RequestList Content_Type="application/x-www-form-urlencoded">
			<ProcessRequestInstructions>
				<xsl:element name="SubmitAs">namevaluepair</xsl:element>
			</ProcessRequestInstructions>
			<xsl:variable name="UserId">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PortalUserName"/>
			</xsl:variable>
			<xsl:variable name="Password">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PortalPassword"/>
			</xsl:variable>
			<xsl:variable name="Passcode">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PortalPasscode"/>
			</xsl:variable>
			<xsl:variable name="PolicyNumber">
				<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
			</xsl:variable>
			<AccountInformationRequest>userid=<xsl:value-of select="$UserId"/>&amp;password=<xsl:value-of select="$Password"/>&amp;Passcode=<xsl:value-of select="$Passcode"/>&amp;clientno=<xsl:value-of select="$PolicyNumber"/>&amp;thirdparty=2</AccountInformationRequest>
		</RequestList>
	</xsl:template>
</xsl:stylesheet>',2 UNION ALL 
        SELECT 43, 'Aviva Platform - WRAP v1.0', '<!--Valuation Request XSL: Aviva Platform - WRAP v1.0-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no" version="1.0"/>
	<xsl:template match="/">
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cvtypes="http://www.origostandards.com/schema/ProvideContractValuation/v1.0/Common/ContractValuationTypes" xmlns:xd="http://www.w3.org/2000/09/xmldsig#" xmlns:gwreq="http://www.origostandards.com/schema/ProvideContractValuation/v1.0/GetWrapRequest" xmlns:os="http://www.origostandards.com/schema/soap/v1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<soapenv:Header/>
	<soapenv:Body>
		<xsl:element name="gwreq:message">
			<xsl:attribute name="id">
				<xsl:value-of select="''idvalue0''"/>
			</xsl:attribute>
			<xsl:element name="gwreq:m_control">
				<xsl:attribute name="id">
					<xsl:value-of select="''idvalue1''"/>
				</xsl:attribute>
				<xsl:element name="os:control_timestamp">
					<xsl:value-of select="/RequestVariables/RequestVariable/@Timestamp"/>
				</xsl:element>
				<xsl:element name="os:message_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@GUID"/>
				</xsl:element>
				<xsl:element name="os:retry_number">0</xsl:element>
				<xsl:element name="os:message_type">Contract Enquiry Request</xsl:element>
				<xsl:element name="os:message_version">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoProductVersion"/>
				</xsl:element>
				<xsl:element name="os:expected_response_type">synchronous</xsl:element>
				<xsl:element name="os:initiator_id">Intelliflo Ltd</xsl:element>
				<os:KeyInfo>
					<xd:X509Data>
						<xd:X509IssuerSerial>
							<xsl:element name="xd:X509IssuerName">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509IssuerName"/>
							</xsl:element>
							<xsl:element name="xd:X509SerialNumber">
								<xsl:value-of select="/RequestVariables/RequestVariable/@X509SerialNumber"/>
							</xsl:element>
						</xd:X509IssuerSerial>
						<xsl:element name="xd:X509SubjectName">
							<xsl:value-of select="/RequestVariables/RequestVariable/@X509SubjectName"/>
						</xsl:element>
					</xd:X509Data>
				</os:KeyInfo>
				<xsl:element name="os:responder_id">
					<xsl:value-of select="/RequestVariables/RequestVariable/@OrigoResponderId"/>
				</xsl:element>
				<xsl:element name="os:responder_message_id">
					<xsl:value-of select="''123456789012345678901234567890123456''"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="gwreq:m_content">
				<xsl:element name="gwreq:intermediary">
					<xsl:element name="cvtypes:FirmFSARef">
						<xsl:value-of select="/RequestVariables/RequestVariable/@FSA"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="gwreq:contract_reference_number">
					<xsl:value-of select="/RequestVariables/RequestVariable/@PolicyNumber"/>
				</xsl:element>
				<xsl:element name="gwreq:request_scope">
					<xsl:element name="gwreq:valuation_currency">GBP</xsl:element>
					<xsl:element name="gwreq:fund_code_type_required">SEDOL</xsl:element>
					<xsl:element name="gwreq:share_code_type_required">SEDOL</xsl:element>
					<xsl:element name="gwreq:share_price_type_required">Bid</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</soapenv:Body>
</soapenv:Envelope>
</xsl:template>
</xsl:stylesheet>',1 
 
        SET IDENTITY_INSERT TValuationXSL OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A22E7729-E354-4266-8DD8-E54D72D5775A', 
         'Initial load (37 total rows, file 1 of 1) for table TValuationXSL',
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
-- #Rows Exported: 37
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
