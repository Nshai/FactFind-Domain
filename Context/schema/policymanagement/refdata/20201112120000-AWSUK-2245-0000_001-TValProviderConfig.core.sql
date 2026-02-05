 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValProviderConfig
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'BD0CBBDC-649E-4A0F-BD5D-DECDCE6808EE'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValProviderConfig ON; 
 
        INSERT INTO TValProviderConfig([ValProviderConfigId], [RefProdProviderId], [PostURL], [OrigoResponderId], [IsAsynchronous], [HowToXML], [AllowRetry], [RetryDelay], [BulkValuationType], [FileAccessCredentialsRequired], [PasswordEncryption], [ScheduleDelay], [SupportedService], [ConcurrencyId], [ReEncodeResponseTo], [ValuationProviderCode], [AuthenticationType])
        SELECT 1,2611, 'https://secure.reassure.co.uk/contractenquiry/default.asp', 'Skandia Life',0, NULL,0,NULL, NULL,0, NULL,0,15,5, NULL, 'oldmutualwealthlifeassurance',0 UNION ALL 
        SELECT 3,347, 'https://online-ifrcert.standardlife.com/cen/PortalServlet', 'Standard Life Assurance Company',0, 'https://online.standardlife.com/intermediaryfirmaccess/html/firm_registration_index.htm',0,NULL, NULL,0, NULL,0,15,5, 'ISO-8859-1', 'standardlife',1 UNION ALL 
        SELECT 4,567, 'https://www.fidelity.co.uk/gateway/adsservices/account/valuation', 'Intelliflo',0, NULL,0,0, 'file',1, NULL,0,23,5, NULL, 'Fidelityfundsnetwork',0 UNION ALL 
        SELECT 5,558, 'https://s2s.cofunds.co.uk/S2S_Cofunds_Valuation.asp', 'COFUNDS',0, 'https://secure.cofunds.co.uk/content.asp?PN=RegisterStart',0,0, 'file',1, NULL,0,83,6, NULL, 'AegonCofunds',0 UNION ALL 
        SELECT 6,808, 'https://www.life.qs.aviva.co.uk/owl/xml/enquiry/origo_v1p1_oan.asp?swp=intel', 'NU,1790824203,741852',0, NULL,0,0, NULL,0, NULL,0,15,4, NULL, 'aviva',1 UNION ALL 
        SELECT 7,294, 'https://www2x.pruadviser.co.uk/B2BInterface/', 'Prudential',0, NULL,0,0, NULL,0, NULL,1,15,4, NULL, 'prudential',1 UNION ALL 
        SELECT 10,84, 'https://dc.secure.scottishwidows.co.uk/individualbusiness/webservices/contract-enquiry/service', 'Scottish Widows',0, 'http://www.scottishwidows.co.uk/extranet/index',0,0, NULL,0, NULL,0,15,6, NULL, 'clericalmedical',1 UNION ALL 
        SELECT 11,321, 'https://prodext2.scoteq.co.uk/cenq/ContractEnquiryServlet', 'Scottish Equitable plc',0, NULL,0,0, NULL,0, NULL,0,15,7, NULL, 'scottishequitable',1 UNION ALL 
        SELECT 12,576, 'https://user.transact-online.co.uk/Login/TOL_RemoteService.cfm', 'Transact,55YH3P2NNG',0, NULL,0,0, 'file',1, NULL,0,19,6, NULL, 'Transact',0 UNION ALL 
        SELECT 13,941, 'https://intelliflo.7im.co.uk', 'Seven Investment Management,5E690097-8C97-4D92-A469-F101CD5A6B4F',0, NULL,0,0, 'file',0, NULL,0,19,5, NULL, 'Seveninvestmentmanagement',0 UNION ALL 
        SELECT 14,199, 'https://www15.landg.com/DigicertsLoginWeb/ControllerServlet?action=C_S_A_P&targetApp=origoce_origoce_entry', 'Legal & General',0, NULL,0,0, NULL,0, NULL,5,15,4, NULL, 'legalgeneral',1 UNION ALL 
        SELECT 17,395, 'https://certsapp.zurich.co.uk/zurichintermediary/zfsa/b2bce.aspx', 'Zurich Financial Services Ltd',0, NULL,0,0, NULL,0, NULL,0,15,3, NULL, 'zurich',1 UNION ALL 
        SELECT 18,326, 'https://dc.secure.scottishwidows.co.uk/individualbusiness/webservices/contract-enquiry/service', 'Scottish Widows',0, NULL,0,0, NULL,0, NULL,0,15,4, NULL, 'scottishwidows',1 UNION ALL 
        SELECT 19,2245, 'https://tools.phoenixwealth.co.uk/ifavaluations/default.aspx', 'Phoenix Wealth',0, NULL,0,0, NULL,0, NULL,0,15,4, NULL, 'axawealth',0 UNION ALL 
        SELECT 20,2269, 'https://www.sanlam-ip.co.uk/Porthos/Origo/CERequest.aspx', 'Sanlam Investments and Pensions',0, NULL,0,0, NULL,0, NULL,0,15,6, NULL, 'sanlaminvestmentsandpensions',0 UNION ALL 
        SELECT 21,1596, 'https://ece.fnz.co.uk/admin/enquiries/contractenquiryrequest.aspx', 'AXADS',0, NULL,0,0, 'file',1, 'SHA1',0,31,5, NULL, 'Elevate',0 UNION ALL 
        SELECT 22,62, 'https://b2b.canadalife.co.uk/b2b/ClukB2bHttpHandler/ClukB2bHttpHandler', 'Canada Life',0, NULL,0,0, NULL,0, NULL,0,15,3, NULL, 'canadalife',1 UNION ALL 
        SELECT 23,310, 'https://extquotes.royallondon.com/Portals/ContractEnquiry/valuations.asp', 'Scottish Life',0, NULL,0,0, NULL,0, NULL,0,15,5, NULL, 'royallondon',1 UNION ALL 
        SELECT 24,2610, 'https://www.skandiais.co.uk/skandia/ContractEnquiryThirdParty.aspx', 'Skandia Investment Solutions',0, NULL,0,0, 'file',0, NULL,0,31,7, NULL, 'oldmutualwealth',0 UNION ALL 
        SELECT 25,204, 'https://origo.lv.com/servlet/Intelliflo/OrigoCEMessageReceptor', 'LV=RetirementSolutions',0, NULL,0,0, NULL,0, NULL,0,15,4, NULL, 'liverpoolvictoria',1 UNION ALL 
        SELECT 26,1543, 'Bulk Valuation', 'Citi Quilter',0, NULL,0,0, 'file',1, NULL,0,19,2, NULL, 'Citiquilter',0 UNION ALL 
        SELECT 27,1405, 'Bulk Valuation', 'Nucleus Financial Group',0, NULL,0,0, 'file',0, NULL,0,19,4, NULL, 'nucleusfinancialgroup',0 UNION ALL 
        SELECT 28,1555, 'Bulk Valuation', 'Ascentric',0, NULL,0,0, 'file',1, NULL,0,19,2, NULL, 'Ascentric',0 UNION ALL 
        SELECT 29,1814, 'Bulk Valuation', 'Novia',0, NULL,0,0, 'file',1, NULL,0,19,2, NULL, 'Noviafinancial',0 UNION ALL 
        SELECT 31,1019, 'Bulk Valuation', 'Raymond James Investment Services',0, NULL,0,0, 'file',0, NULL,0,35,2, NULL, 'raymondjamesinvestmentservices',0 UNION ALL 
        SELECT 32,878, 'Bulk Valuation', 'Brooks Macdonald Asset Mgt',0, NULL,0,0, 'file',1, NULL,0,19,7, NULL, 'Brooksmacdonaldassetmgt',0 UNION ALL 
        SELECT 33,2334, 'https://rsprpa.zurich.co.uk/openplatform/contractenquiry/intelliflo', 'Zurich Intermediary Platform',0, NULL,0,0, 'file',1, NULL,0,31,12, NULL, 'Zurichintermediaryplatform',0 UNION ALL 
        SELECT 34,1145, 'Bulk Valuation', 'Margetts Fund Management Ltd',0, NULL,0,0, 'file',1, NULL,0,19,72, NULL, 'Margettsfundmanagementltd',0 UNION ALL 
        SELECT 35,1509, 'Bulk Valuation', 'Parmenion Capital Partners LLP',0, NULL,0,0, 'file',1, NULL,0,19,8, NULL, 'Parmenioncapitalpartnersllp',0 UNION ALL 
        SELECT 36,2438, 'https://www.aviva-for-messaging.co.uk/unipass/api/wrap/valuation/v1/ProvideContractValuationService', 'Aviva Platform',0, NULL,0,0, 'file',1, NULL,0,23,13, NULL, 'Avivaplatform',1 UNION ALL 
        SELECT 37,2247, 'Bulk Valuation', 'Wealthtime',0, NULL,0,0, 'file',1, NULL,0,19,6, NULL, 'Wealthtime',0 UNION ALL 
        SELECT 38,302, 'Bulk Valuation', 'Rowan Dartington',0, NULL,0,0, 'file',1, NULL,0,19,6, NULL, 'Rowandartington',0 UNION ALL 
        SELECT 39,2313, 'Bulk Valuation', 'Signature',0, NULL,0,0, 'file',1, NULL,0,19,6, NULL, 'Signature',0 UNION ALL 
        SELECT 40,183, 'https://www.jameshay.co.uk/Portal/FirstDataDownload.aspx', 'James Hay',0, NULL,0,0, 'file',1, NULL,0,23,3, NULL, 'Jameshay',0 UNION ALL 
        SELECT 41,2288, 'Bulk Valuation', 'Investec Wealth & Investment',0, NULL,0,0, 'file',1, NULL,0,19,2, NULL, 'Investecwealthinvestment',0 UNION ALL 
        SELECT 42,1377, 'Bulk Valuation', 'Thesis Asset Management',0, NULL,0,0, 'file',1, NULL,0,19,4, NULL, 'Thesisassetmanagement',0 UNION ALL 
        SELECT 43,2482, 'https://online-ifrcert.standardlife.com/cen/PortalServlet', 'Standard Life Assurance Company',0, 'https://online.standardlife.com/intermediaryfirmaccess/html/firm_registration_index.htm',0,0, NULL,0, NULL,0,15,6, 'ISO-8859-1', 'standardlifefundzone',1 UNION ALL 
        SELECT 44,2215, 'Bulk Valuation', 'Close Asset Management',0, NULL,0,0, 'file',1, NULL,0,19,2, NULL, 'Closeassetmanagement',0 UNION ALL 
        SELECT 45,901, 'Bulk Valuation', 'Redmayne Bentley',0, NULL,0,0, 'file',1, NULL,0,19,8, NULL, 'Redmaynebentley',0 UNION ALL 
        SELECT 46,556, 'Bulk Valuation', 'AJ Bell',0, NULL,0,0, 'file',1, NULL,0,19,4, NULL, 'Ajbell',0 UNION ALL 
        SELECT 47,2572, 'Bulk Valuation', 'Bulk Manual Template',0, NULL,0,0, 'file',0, NULL,0,128,2, NULL, 'bulkmanualtemplate',0 UNION ALL 
        SELECT 48,2625, 'Bulk Valuation', 'AEGON One Retirement',0, NULL,0,NULL, 'file',1, NULL,0,19,2, NULL, 'AegonOneretirement',0 UNION ALL 
        SELECT 49,2432, 'Bulk Valuation', 'AEGON Retirement Choices',0, NULL,0,NULL, 'file',1, NULL,0,19,2, NULL, 'AegonRetirementChoices',0 UNION ALL 
        SELECT 50,2640, 'Bulk Valuation', 'Pershing',0, NULL,0,NULL, 'file',1, NULL,0,19,2, NULL, 'Pershing',0 UNION ALL 
        SELECT 51,2377, 'Bulk Valuation', 'HubwiseSecurities',0, NULL,0,NULL, 'file',1, NULL,0,19,2, NULL, 'HubwiseSecurities',0 UNION ALL 
        SELECT 52,181, 'Bulk Valuation', 'JAMESBREARLEYSONS',0, NULL,0,NULL, 'file',1, NULL,0,19,2, NULL, 'JamesBrearleySons',0 UNION ALL 
        SELECT 53,1984, 'Bulk Valuation', 'PRAEMIUM',0, NULL,0,NULL, 'file',1, NULL,0,19,2, NULL, 'Praemium',0 UNION ALL 
        SELECT 54,1796, 'Bulk Valuation', 'ALLIANCETRUST',0, NULL,0,NULL, 'file',1, NULL,0,19,2, NULL, 'AllianceTrust',0 UNION ALL 
        SELECT 55,2825, 'https://intelliflo-test.etestrpa.zurich.co.uk/openplatform/contractenquiry/intelliflo', 'Zurich Intermediary Platform',0, NULL,0,NULL, 'file',1, NULL,0,19,1, NULL, 'LighthouseZurichPlatform',0 UNION ALL 
        SELECT 56,2604, 'Bulk Valuation', 'Charles Stanley',0, NULL,0,NULL, 'file',1, NULL,0,19,1, NULL, 'Charlesstanley',0 UNION ALL 
        SELECT 57,3070, 'Bulk Valuation', 'Aegon Platform (for NBS)',0, NULL,0,NULL, 'file',1, NULL,0,19,1, NULL, 'AegonNbs',0 
 
        SET IDENTITY_INSERT TValProviderConfig OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'BD0CBBDC-649E-4A0F-BD5D-DECDCE6808EE', 
         'Initial load (51 total rows, file 1 of 1) for table TValProviderConfig',
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
-- #Rows Exported: 51
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
