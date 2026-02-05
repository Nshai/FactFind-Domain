 
-----------------------------------------------------------------------------
-- Table: Administration.TSystem
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F2F613D0-BFE3-487A-8747-D7C2903702F6'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TSystem ON; 
 
        INSERT INTO TSystem([SystemId], [Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], [EntityId], [ConcurrencyId])
        SELECT 323, 'adviserworkplace', 'Adviser Workplace', 'adviserworkplace', '-application',NULL, '/clientmanagement/dashboard.asp',NULL,1 UNION ALL 
        SELECT 324, 'clients', 'Clients', 'adviserworkplace.clients', '-system',323, '/clientmanagement/contacts/managecontacts/contactsearch.asp',NULL,1 UNION ALL 
        SELECT 325, 'details', 'Details', 'adviserworkplace.clients.details', '-function',324, '',NULL,1 UNION ALL 
        SELECT 326, 'summary', 'Summary', 'adviserworkplace.clients.details.summary', '-liogroup',325, '/clientmanagement/contacts/managecontacts/contactsummary.asp',NULL,2 UNION ALL 
        SELECT 327, 'personal', 'Personal', 'adviserworkplace.clients.details.personal', '-liogroup',325, '/clientmanagement/contacts/managecontacts/person.asp',NULL,2 UNION ALL 
        SELECT 328, 'trust', 'Trust', 'adviserworkplace.clients.details.trust', '-liogroup',325, '/clientmanagement/contacts/managecontacts/trust.asp',NULL,2 UNION ALL 
        SELECT 329, 'corporate', 'Company', 'adviserworkplace.clients.details.corporate', '-liogroup',325, '/clientmanagement/contacts/managecontacts/corporate.asp',NULL,2 UNION ALL 
        SELECT 330, 'address', 'Address Details', 'adviserworkplace.clients.details.address', '-liogroup',325, '/clientmanagement/contacts/managecontacts/address.asp',NULL,2 UNION ALL 
        SELECT 331, 'contact', 'Contact Details', 'adviserworkplace.clients.details.contact', '-liogroup',325, '/clientmanagement/contacts/managecontacts/contact.asp',NULL,2 UNION ALL 
        SELECT 332, 'relationships', 'Relationships', 'adviserworkplace.clients.details.relationships', '-liogroup',325, '/clientmanagement/contacts/managecontacts/relationships.asp',NULL,2 UNION ALL 
        SELECT 333, 'relationships', 'Trustees & Beneficiaries', 'adviserworkplace.clients.details.relationships', '-liogroup',325, '/clientmanagement/contacts/managecontacts/relationships.asp',NULL,2 UNION ALL 
        SELECT 334, 'relationships', 'Relationships', 'adviserworkplace.clients.details.relationships', '-liogroup',325, '/clientmanagement/contacts/managecontacts/relationships.asp',NULL,2 UNION ALL 
        SELECT 335, 'splits', 'Client Splits', 'adviserworkplace.clients.details.splits', '-liogroup',325, '/commissionsplits/viewsplittemplate_client.asp',NULL,2 UNION ALL 
        SELECT 336, 'plans', 'Plans', 'adviserworkplace.clients.plans', '-function',324, '',NULL,1 UNION ALL 
        SELECT 337, 'summary', '1. Summary', 'adviserworkplace.clients.plans.summary', '-liogroup',336, '/planmanagement/manageplans/basicdetails.asp',NULL,2 UNION ALL 
        SELECT 338, 'planpurpose', '2. Plan Purpose', 'adviserworkplace.clients.plans.planpurpose', '-liogroup',336, '/planmanagement/manageplans/planpurpose.asp',NULL,2 UNION ALL 
        SELECT 339, 'switchdetails', '3. Switch Details', 'adviserworkplace.clients.plans.switchdetails', '-liogroup',336, '/planmanagement/manageplans/planswitch.asp',NULL,2 UNION ALL 
        SELECT 340, 'splits', '4. Splits', 'adviserworkplace.clients.plans.splits', '-liogroup',336, '/commissionsplits/viewsplits_policy.asp',NULL,2 UNION ALL 
        SELECT 341, 'commissions', '5. Commissions', 'adviserworkplace.clients.plans.commissions', '-liogroup',336, '/planmanagement/manageplans/commission.asp',NULL,2 UNION ALL 
        SELECT 342, 'planhistory', '6. Plan History', 'adviserworkplace.clients.plans.planhistory', '-liogroup',336, '/planmanagement/manageplans/statushistory.asp',NULL,2 UNION ALL 
        SELECT 343, 'withdrawal', '7. Withdrawals', 'adviserworkplace.clients.plans.withdrawal', '-liogroup',336, '/planmanagement/manageplans/withdrawal.asp',NULL,2 UNION ALL 
        SELECT 344, 'contribution', '8. Contributions', 'adviserworkplace.clients.plans.contribution', '-liogroup',336, '/planmanagement/manageplans/contribution.asp',NULL,2 UNION ALL 
        SELECT 345, 'pension', '9. Pensions', 'adviserworkplace.clients.plans.pension', '-liogroup',336, '/planmanagement/manageplans/pension.asp',NULL,2 UNION ALL 
        SELECT 346, 'fund', '10. Funds', 'adviserworkplace.clients.plans.fund', '-liogroup',336, '/planmanagement/manageplans/fund.asp',NULL,2 UNION ALL 
        SELECT 347, 'valuation', '11. Valuations', 'adviserworkplace.clients.plans.valuation', '-liogroup',336, '/planmanagement/manageplans/valuation.asp',NULL,2 UNION ALL 
        SELECT 348, 'benefit', '12. Benefits', 'adviserworkplace.clients.plans.benefit', '-liogroup',336, '/planmanagement/manageplans/benefit.asp',NULL,2 UNION ALL 
        SELECT 349, 'documents', '13. Documents', 'adviserworkplace.clients.plans.documents', '-liogroup',336, '/planmanagement/manageplans/plandocuments.asp',NULL,2 UNION ALL 
        SELECT 350, 'scheme', 'Schemes', 'adviserworkplace.clients.scheme', '-function',324, '',NULL,1 UNION ALL 
        SELECT 351, 'basicDetails', 'Basic Scheme Details', 'adviserworkplace.clients.scheme.basicDetails', '-liogroup',350, '/planmanagement/managecorporateplan/basicdetails.asp',NULL,2 UNION ALL 
        SELECT 352, 'member', 'Scheme Members', 'adviserworkplace.clients.scheme.member', '-liogroup',350, '/planmanagement/managecorporateplan/schememembers.asp',NULL,2 UNION ALL 
        SELECT 353, 'fees', 'Fees', 'adviserworkplace.clients.fees', '-function',324, '',NULL,1 UNION ALL 
        SELECT 354, 'details', 'Fee Details', 'adviserworkplace.clients.fees.details', '-liogroup',353, '/fees/editstandardfee.asp',NULL,2 UNION ALL 
        SELECT 355, 'splits', 'Splits', 'adviserworkplace.clients.fees.splits', '-liogroup',353, '/commissionsplits/viewsplits_fee.asp',NULL,2 UNION ALL 
        SELECT 356, 'documents', 'Documents', 'adviserworkplace.clients.fees.documents', '-liogroup',353, '/fees/feedocuments.asp',NULL,2 UNION ALL 
        SELECT 357, 'details', 'Retainer Details', 'adviserworkplace.clients.fees.details', '-liogroup',353, '/fees/editretainer.asp',NULL,2 UNION ALL 
        SELECT 358, 'splits', 'Splits', 'adviserworkplace.clients.fees.splits', '-liogroup',353, '/commissionsplits/viewsplits_retainer.asp',NULL,2 UNION ALL 
        SELECT 359, 'documents', 'Documents', 'adviserworkplace.clients.fees.documents', '-liogroup',353, '/fees/retainerdocuments.asp',NULL,2 UNION ALL 
        SELECT 360, 'details', 'Credit Note Details', 'adviserworkplace.clients.fees.details', '-liogroup',353, '/fees/editcreditnote.asp',NULL,2 UNION ALL 
        SELECT 361, 'tasks', 'Activities', 'adviserworkplace.clients.tasks', '-function',324, '',NULL,1 UNION ALL 
        SELECT 362, 'todo', 'To Do', 'adviserworkplace.clients.tasks.todo', '-liogroup',361, '/organiser/tasks/contacttasks.asp',NULL,2 UNION ALL 
        SELECT 363, 'documents', 'Documents', 'adviserworkplace.clients.tasks.documents', '-liogroup',361, '/organiser/tasks/taskdocuments.asp',NULL,2 UNION ALL 
        SELECT 364, 'documents', 'Documents', 'adviserworkplace.clients.documents', '-function',324, '',NULL,1 UNION ALL 
        SELECT 365, 'documents', 'documents', 'adviserworkplace.clients.documents.documents', '-liogroup',364, '/documentmanagement/contactdocuments.asp',NULL,2 UNION ALL 
        SELECT 366, 'profile', 'Profile', 'adviserworkplace.clients.documents.profile', '-liogroup',364, '/documentmanagement/versionprofile.asp',NULL,2 UNION ALL 
        SELECT 367, 'documenthistory', 'Document History', 'adviserworkplace.clients.documents.documenthistory', '-liogroup',364, '/documentmanagement/history.asp',NULL,2 UNION ALL 
        SELECT 368, 'addclient', 'Add Client', 'adviserworkplace.clients.addclient', '-action',324, 'dialog:/render/wizard.asp?wzName=addContact&wzAppdir=ClientManagement/contacts/managecontacts/AddContact&Parameters=',NULL,1 UNION ALL 
        SELECT 369, 'addclientandplan', 'Add Client And Plan', 'adviserworkplace.clients.addclientandplan', '-action',324, 'dialog:/render/wizard.asp?wzName=addContactsAndPlan&wzAppdir=ClientManagement/Contacts/ManageContacts/AddContactsAndPlan',NULL,1 UNION ALL 
        SELECT 371, 'search', 'Client Quick Search', 'adviserworkplace.clients.search', '-action',324, '',NULL,1 UNION ALL 
        SELECT 372, 'sales', 'Sales', 'adviserworkplace.sales', '-system',323, '/clientmanagement/sales/search.asp',NULL,1 UNION ALL 
        SELECT 373, 'incomeearned', 'Fees & Commission', 'adviserworkplace.sales.incomeearned', '-function',372, '',NULL,1 UNION ALL 
        SELECT 374, 'selectincomeearned', 'Income Earned', 'adviserworkplace.sales.incomeearned.selectincomeearned', '-liogroup',373, '/workplace/sales/fci.asp',NULL,2 UNION ALL 
        SELECT 375, 'splittemplate', 'Split Template', 'adviserworkplace.sales.incomeearned.splittemplate', '-liogroup',373, '/commissionsplits/viewsplittemplate_practitioner.asp',NULL,2 UNION ALL 
        SELECT 376, 'proposals', 'Pre-File Checks', 'adviserworkplace.sales.proposals', '-function',372, '',NULL,1 UNION ALL 
        SELECT 377, 'proposals', 'proposals', 'adviserworkplace.sales.proposals.proposals', '-liogroup',376, '/workplace/proposals/outstandingbusiness.asp',NULL,2 UNION ALL 
        SELECT 378, 'advisersearch', 'Adviser Search', 'adviserworkplace.sales.advisersearch', '-action',372, '/clientmanagement/sales/search.asp',NULL,1 UNION ALL 
        SELECT 379, 'search', 'Adviser Quick Search', 'adviserworkplace.sales.search', '-action',372, '',NULL,1 UNION ALL 
        SELECT 380, 'commissions', 'Income', 'commissions', '-application',NULL, '/commissions/provstates/providerstatements.asp',NULL,1 UNION ALL 
        SELECT 381, 'providerstatements', 'Provider Statements', 'commissions.providerstatements', '-system',380, '/commissions/provstates/providerstatements.asp',NULL,1 UNION ALL 
        SELECT 382, 'statement', 'Statement', 'commissions.providerstatements.statement', '-function',381, '',NULL,1 UNION ALL 
        SELECT 383, 'list', 'List', 'commissions.providerstatements.statement.list', '-liogroup',382, '/commissions/provstates/providerstatements.asp',NULL,2 UNION ALL 
        SELECT 384, 'breakdownitems', 'Breakdown Items', 'commissions.providerstatements.statement.breakdownitems', '-liogroup',382, '/commissions/provstates/provbreak.asp',NULL,2 UNION ALL 
        SELECT 385, 'electronicimports', 'Electronic Imports', 'commissions.providerstatements.electronicimports', '-function',381, '',NULL,1 UNION ALL 
        SELECT 386, 'list', 'List', 'commissions.providerstatements.electronicimports.list', '-liogroup',385, '/commissions/provstates/electronicimports/provideredistatements.asp',NULL,2 UNION ALL 
        SELECT 387, 'breakdown', 'Breakdown', 'commissions.providerstatements.electronicimports.breakdown', '-liogroup',385, '/commissions/provstates/electronicimports/provbreak.asp',NULL,2 UNION ALL 
        SELECT 388, 'importedi', 'Import EDI', 'commissions.providerstatements.electronicimports.importedi', '-action',381, 'dialog_status:/gatewayservices/gatewayservices.asp?fid=2',NULL,1 UNION ALL 
        SELECT 389, 'importocr', 'Import OCR', 'commissions.providerstatements.electronicimports.importocr', '-action',381, 'dialog_status:/gatewayservices/gatewayservices.asp?fid=10',NULL,1 UNION ALL 
        SELECT 390, 'importcompletediotemplate', 'Import Completed IO Template', 'commissions.providerstatements.electronicimports.importcompletediotemplate', '-action',381, 'dialog_status:/gatewayservices/gatewayservices.asp?fid=7',NULL,1 UNION ALL 
        SELECT 391, 'downloadblankiotemplate', 'Download Blank IO Template', 'commissions.providerstatements.electronicimports.downloadblankiotemplate', '-action',381, 'javascript:OpenStatement();',NULL,1 UNION ALL 
        SELECT 392, 'automatching', 'Auto-Matching', 'commissions.providerstatements.automatching', '-function',381, '',NULL,1 UNION ALL 
        SELECT 393, 'potential', 'Potential Matches', 'commissions.providerstatements.automatching.potential', '-liogroup',392, '/commissions/provstates/automatching/potentialbreakmatches.asp',NULL,2 UNION ALL 
        SELECT 394, 'lookups', 'Lookups', 'commissions.providerstatements.automatching.lookups', '-liogroup',392, '/commissions/provstates/automatching/luprovbreaks.asp',NULL,2 UNION ALL 
        SELECT 395, 'acceptonetoonematches', 'Accept One-to-One Matches', 'commissions.providerstatements.automatching.acceptonetoonematches', '-action',381, 'dialog_status:/commissions/provstates/automatching/one2onematches.asp',NULL,1 UNION ALL 
        SELECT 396, 'statementsearch', 'Statement Search', 'commissions.providerstatements.statementsearch', '-action',381, '/commissions/provstates/providerstatements.asp',NULL,1 UNION ALL 
        SELECT 397, 'cashreceipts', 'Cash Receipts', 'commissions.cashreceipts', '-system',380, '/commissions/cashreceipts/cashreceipts.asp',NULL,1 UNION ALL 
        SELECT 398, 'receipt', 'Receipt', 'commissions.cashreceipts.receipt', '-function',397, '',NULL,1 UNION ALL 
        SELECT 399, 'list', 'List', 'commissions.cashreceipts.receipt.list', '-liogroup',398, '/commissions/cashreceipts/cashreceipts.asp',NULL,2 UNION ALL 
        SELECT 400, 'cashitems', 'Cash Items', 'commissions.cashreceipts.receipt.cashitems', '-liogroup',398, '/commissions/cashreceipts/cashreceiptextendeditems.asp',NULL,2 UNION ALL 
        SELECT 401, 'automatching', 'Auto-Matching', 'commissions.cashreceipts.automatching', '-function',397, '',NULL,1 UNION ALL 
        SELECT 402, 'lookups', 'Lookups', 'commissions.cashreceipts.automatching.lookups', '-liogroup',401, '/commissions/cashreceipts/automatching/lucashreceipts.asp',NULL,2 UNION ALL 
        SELECT 403, 'acceptonetoonematches', 'Accept One-to-One Matches', 'commissions.cashreceipts.automatching.acceptonetoonematches', '-action',397, 'dialog_status:/commissions/cashreceipts/automatching/one2onematches.asp',NULL,1 UNION ALL 
        SELECT 404, 'receiptsearch', 'Receipt Search', 'commissions.cashreceipts.receiptsearch', '-action',397, '/commissions/cashreceipts/cashreceipts.asp',NULL,1 UNION ALL 
        SELECT 405, 'importelectroncbankstatement', 'Import Electronic Bank Statement', 'commissions.cashreceipts.importelectroncbankstatement', '-action',397, 'dialog_status:/gatewayservices/gatewayservices.asp?fid=6',NULL,1 UNION ALL 
        SELECT 406, 'importcompletediotemplate', 'Import Completed IO Template', 'commissions.cashreceipts.importcompletediotemplate', '-action',397, 'dialog_status:/gatewayservices/gatewayservices.asp?fid=8',NULL,1 UNION ALL 
        SELECT 407, 'downloadblankiotemplate', 'Download Blank IO Template', 'commissions.cashreceipts.downloadblankiotemplate', '-action',397, 'javascript:openTemplate();',NULL,1 UNION ALL 
        SELECT 408, 'introducers', 'Introducers', 'commissions.introducers', '-system',380, '/commissions/introducer/searchintroducer.asp',NULL,1 UNION ALL 
        SELECT 409, 'details', 'Details', 'commissions.introducers.details', '-function',408, '',NULL,1 UNION ALL 
        SELECT 410, 'viewdetails', 'Introducer Details', 'commissions.introducers.details.viewdetails', '-liogroup',409, '/commissions/introducer/viewdetails.asp',NULL,2 UNION ALL 
        SELECT 411, 'bankdetails', 'Bank Details', 'commissions.introducers.details.bankdetails', '-liogroup',409, '/commissions/introducer/bankdetails.asp',NULL,2 UNION ALL 
        SELECT 412, 'address', 'Address Details', 'commissions.introducers.details.address', '-liogroup',409, '/commissions/introducer/address.asp',NULL,2 UNION ALL 
        SELECT 413, 'adjustments', 'Payment Adjustments', 'commissions.introducers.details.adjustments', '-liogroup',409, '/commissions/introducer/adjustments.asp',NULL,2 UNION ALL 
        SELECT 414, 'addintroducer', 'Add Introducer', 'commissions.introducers.addintroducer', '-action',408, 'dialog_status:/commissions/introducer/selectcontacttype.asp?iaction=Add',NULL,1 UNION ALL 
        SELECT 415, 'introducersearch', 'Introducer Search', 'commissions.introducers.introducersearch', '-action',408, '/commissions/introducer/searchintroducer.asp',NULL,1 UNION ALL 
        SELECT 416, 'users', 'Users', 'commissions.users', '-system',380, '/commissions/adjustments/users/searchusers.asp',NULL,1 UNION ALL 
        SELECT 417, 'details', 'Details', 'commissions.users.details', '-function',416, '',NULL,1 UNION ALL 
        SELECT 418, 'adjustments', 'Payment Adjustments', 'commissions.users.details.adjustments', '-liogroup',417, '/commissions/adjustments/users/adjustments.asp',NULL,2 UNION ALL 
        SELECT 419, 'usersearch', 'User Search', 'commissions.users.usersearch', '-action',416, '/commissions/adjustments/users/searchusers.asp',NULL,1 UNION ALL 
        SELECT 420, 'clients', 'Clients', 'commissions.clients', '-system',380, '/commissions/adjustments/clients/searchclients.asp',NULL,1 UNION ALL 
        SELECT 421, 'details', 'Details', 'commissions.clients.details', '-function',420, '',NULL,1 UNION ALL 
        SELECT 422, 'adjustments', 'Payment Adjustments', 'commissions.clients.details.adjustments', '-liogroup',421, '/commissions/adjustments/clients/adjustments.asp',NULL,2 UNION ALL 
        SELECT 423, 'clientsearch', 'Client Search', 'commissions.clients.clientsearch', '-action',420, '/commissions/adjustments/clients/searchclients.asp',NULL,1 UNION ALL 
        SELECT 424, 'advisers', 'Advisers', 'commissions.advisers', '-system',380, '/commissions/advisers/advisersearch.asp',NULL,1 UNION ALL 
        SELECT 425, 'details', 'Details', 'commissions.advisers.details', '-function',424, '',NULL,1 UNION ALL 
        SELECT 426, 'banding', 'Banding', 'commissions.advisers.details.banding', '-liogroup',425, '/commissions/advisers/bandings.asp',NULL,2 UNION ALL 
        SELECT 427, 'bankdetails', 'Bank Details', 'commissions.advisers.details.bankdetails', '-liogroup',425, '/commissions/advisers/bankdetails.asp',NULL,2 UNION ALL 
        SELECT 428, 'adjustments', 'Adjustments', 'commissions.advisers.details.adjustments', '-liogroup',425, '/commissions/advisers/adjustments.asp',NULL,2 UNION ALL 
        SELECT 429, 'selectincomeearned', 'Income Earned', 'commissions.advisers.details.selectincomeearned', '-liogroup',425, '/commissions/advisers/fci.asp',NULL,2 UNION ALL 
        SELECT 430, 'advisersearch', 'Adviser Search', 'commissions.advisers.advisersearch', '-action',424, '/commissions/advisers/advisersearch.asp',NULL,1 UNION ALL 
        SELECT 431, 'administration', 'Administration', 'commissions.administration', '-system',380, '/commissions/administration/paymentruns/paymenthistory.asp',NULL,1 UNION ALL 
        SELECT 432, 'paymentruns', 'Payment Runs', 'commissions.administration.paymentruns', '-function',431, '',NULL,1 UNION ALL 
        SELECT 433, 'paymenthistory', 'Payment History', 'commissions.administration.paymentruns.paymenthistory', '-liogroup',432, '/commissions/administration/paymentruns/paymenthistory.asp',NULL,2 UNION ALL 
        SELECT 434, 'periodendhistory', 'Period End History', 'commissions.administration.paymentruns.periodendhistory', '-liogroup',432, '/commissions/administration/paymentruns/periodendhistory.asp',NULL,2 UNION ALL 
        SELECT 435, 'generatepaymentrun', 'Generate Payment Run', 'commissions.administration.paymentruns.generatepaymentrun', '-action',431, 'dialog_status:/commissions/administration/paymentruns/payments.asp?PRType=1',NULL,1 UNION ALL 
        SELECT 436, 'closemonthend', 'Close Month End', 'commissions.administration.paymentruns.closemonthend', '-action',431, 'dialog_status:/commissions/administration/paymentruns/payments.asp?PRType=2',NULL,1 UNION ALL 
        SELECT 437, 'providers', 'Providers', 'commissions.administration.providers', '-function',431, '',NULL,1 UNION ALL 
        SELECT 438, 'linked', 'Linked', 'commissions.administration.providers.linked', '-liogroup',437, '/commissions/administration/providers/linkproviders.asp',NULL,2 UNION ALL 
        SELECT 439, 'payeeconfiguration', 'Payee Configuration', 'commissions.administration.payeeconfiguration', '-function',431, '',NULL,1 UNION ALL 
        SELECT 440, 'paymententities', 'Payment Entities', 'commissions.administration.payeeconfiguration.paymententities', '-liogroup',439, '/commissionrules/viewpaymententities.asp',NULL,2 UNION ALL 
        SELECT 441, 'paymentrules', 'Payment Rules', 'commissions.administration.payeeconfiguration.paymentrules', '-liogroup',439, '/commissionrules/viewpaymentrules.asp',NULL,2 UNION ALL 
        SELECT 442, 'addpaymententity', 'Add Payment Entity', 'commissions.administration.payeeconfiguration.addpaymententity', '-action',431, 'dialog:/commissionrules/addeditpaymententity.asp',NULL,1 UNION ALL 
        SELECT 443, 'addpaymentrule', 'Add Payment Rule', 'commissions.administration.payeeconfiguration.addpaymentrule', '-action',431, 'dialog:/commissionrules/addeditpaymentrule.asp',NULL,1 UNION ALL 
        SELECT 445, 'compliance', 'Compliance', 'compliance', '-application',NULL, '/compliance/filecheckmini/filechecksearch.asp',NULL,1 UNION ALL 
        SELECT 446, 'filechecking', 'File Checking', 'compliance.filechecking', '-system',445, '/compliance/filecheckmini/filechecksearch.asp',NULL,1 UNION ALL 
        SELECT 447, 'postsalesearch', 'Post Search', 'compliance.filechecking.postsalesearch', '-function',446, '',NULL,1 UNION ALL 
        SELECT 448, 'details', 'Details', 'compliance.filechecking.file.details', '-liogroup',447, '/compliance/filecheckmini/filecheckdetails.asp',NULL,2 UNION ALL 
        SELECT 449, 'advisers', 'Advisers', 'compliance.advisers', '-system',445, '/compliance/adviser/advisersearch.asp',NULL,1 UNION ALL 
        SELECT 450, 'manage', 'Details', 'compliance.advisers.manage', '-function',449, '',NULL,1 UNION ALL 
        SELECT 451, 'adviser', 'Adviser Summary', 'compliance.advisers.manage.adviser', '-liogroup',450, '/compliance/adviser/advisersummary.asp',NULL,2 UNION ALL 
        SELECT 452, 'adviserdetails', 'Personal', 'compliance.advisers.manage.adviserdetails', '-liogroup',450, '/compliance/adviser/adviserdetails.asp',NULL,2 UNION ALL 
        SELECT 453, 'address', 'Address Details', 'compliance.advisers.manage.address', '-liogroup',450, '/compliance/adviser/address.asp',NULL,2 UNION ALL 
        SELECT 454, 'contact', 'Contact Details', 'compliance.advisers.manage.contact', '-liogroup',450, '/compliance/adviser/contact.asp',NULL,2 UNION ALL 
        SELECT 455, 'gating', 'Gating', 'compliance.advisers.manage.gating', '-liogroup',450, '/compliance/adviser/gating.asp',NULL,2 UNION ALL 
        SELECT 456, 'tccoach', 'T&C Coach', 'compliance.advisers.manage.tccoach', '-liogroup',450, '/compliance/adviser/tnccoach.asp',NULL,2 UNION ALL 
        SELECT 457, 'addadviser', 'Add Adviser', 'compliance.advisers.addadviser', '-action',449, 'dialog:/compliance/adviser/newadviser.asp',NULL,1 UNION ALL 
        SELECT 458, 'tccoaches', 'T&C Coaches', 'compliance.tccoaches', '-system',445, '/compliance/tnccoach/tnccoachsearch.asp',NULL,1 UNION ALL 
        SELECT 459, 'manage', 'Details', 'compliance.tccoaches.manage', '-function',458, '',NULL,1 UNION ALL 
        SELECT 460, 'summary', 'T&C Coach Summary', 'compliance.tccoaches.manage.summary', '-liogroup',459, '/compliance/tnccoach/tnccoachsummary.asp',NULL,2 UNION ALL 
        SELECT 461, 'tnccoachdetails', 'Personal', 'compliance.tccoaches.manage.tnccoachdetails', '-liogroup',459, '/compliance/tnccoach/tnccoachdetails.asp',NULL,2 UNION ALL 
        SELECT 462, 'address', 'Address Details', 'compliance.tccoaches.manage.address', '-liogroup',459, '/compliance/tnccoach/address.asp',NULL,2 UNION ALL 
        SELECT 463, 'contact', 'Contact Details', 'compliance.tccoaches.manage.contact', '-liogroup',459, '/compliance/tnccoach/contact.asp',NULL,2 UNION ALL 
        SELECT 464, 'addtccoach', 'Add T&C Coach', 'compliance.tccoaches.addtccoach', '-action',458, 'dialog:/compliance/tnccoach/newtnccoach.asp',NULL,1 UNION ALL 
        SELECT 465, 'author', 'Author', 'compliance.author', '-system',445, '/author/admin/templates.asp',NULL,1 UNION ALL 
        SELECT 466, 'templates', 'Templates', 'compliance.author.templates', '-function',465, '',NULL,1 UNION ALL 
        SELECT 467, 'templates', 'List', 'compliance.author.templates.templates', '-liogroup',466, '/author/admin/templates.asp',NULL,2 UNION ALL 
        SELECT 468, 'versions', 'Version History', 'compliance.author.templates.versions', '-liogroup',466, '/author/admin/templateversions.asp',NULL,2 UNION ALL 
        SELECT 469, 'headings', 'Headings', 'compliance.author.headings', '-function',465, '',NULL,1 UNION ALL 
        SELECT 470, 'list', 'List', 'compliance.author.headings.list', '-liogroup',469, '/author/admin/headings.asp',NULL,2 UNION ALL 
        SELECT 471, 'paragraphs', 'Paragraphs', 'compliance.author.paragraphs', '-function',465, '',NULL,1 UNION ALL 
        SELECT 472, 'details', 'Details', 'compliance.author.paragraphs.details', '-liogroup',471, '/author/admin/paragraphs.asp',NULL,2 UNION ALL 
        SELECT 473, 'versionhistory', 'Version History', 'compliance.author.paragraphs.versionhistory', '-liogroup',471, '/author/admin/paragraphversions.asp',NULL,2 UNION ALL 
        SELECT 474, 'types', 'Template Types', 'compliance.author.types', '-function',465, '',NULL,1 UNION ALL 
        SELECT 475, 'types', 'Template Types', 'compliance.author.types.types', '-liogroup',474, '/author/admin/doctypes.asp',NULL,2 UNION ALL 
        SELECT 476, 'styles', 'Document Style', 'compliance.author.styles', '-function',465, '',NULL,1 UNION ALL 
        SELECT 477, 'styles', 'Styles', 'compliance.author.styles.styles', '-liogroup',476, '/author/admin/documentstyles.asp',NULL,2 UNION ALL 
        SELECT 478, 'administration', 'Administration', 'compliance.administration', '-system',445, '/compliance/filecheckmini/filechecksetup.asp',NULL,1 UNION ALL 
        SELECT 479, 'filechecking', 'File Checking', 'compliance.administration.filechecking', '-function',478, '',NULL,1 UNION ALL 
        SELECT 480, 'standard', 'Standard', 'compliance.administration.filechecking.standard', '-liogroup',479, '/compliance/filecheckmini/filechecksetup.asp',NULL,2 UNION ALL 
        SELECT 481, 'advisers', 'Advisers', 'compliance.administration.advisers', '-function',478, '',NULL,1 UNION ALL 
        SELECT 482, 'standard', 'Standard', 'compliance.administration.advisers.standard', '-liogroup',481, '/compliance/adviser/advisersetup.asp',NULL,2 UNION ALL 
        SELECT 483, 'setup', 'Set-Up', 'compliance.administration.setup', '-function',478, '',NULL,1 UNION ALL 
        SELECT 484, 'standard', 'Standard', 'compliance.administration.tccoaches.standard', '-liogroup',483, '/compliance/tnccoach/tnccoachsetup.asp',NULL,2 UNION ALL 
        SELECT 485, 'registers', 'Registers', 'compliance.administration.registers', '-function',478, '',NULL,1 UNION ALL 
        SELECT 486, 'providers', 'Providers', 'compliance.administration.registers.providers', '-liogroup',485, '/compliance/register/providers.asp',NULL,2 UNION ALL 
        SELECT 487, 'products', 'Products', 'compliance.administration.registers.products', '-liogroup',485, '/compliance/register/products.asp',NULL,2 UNION ALL 
        SELECT 488, 'proposals', 'Proposals', 'compliance.proposals', '-system',445, '/compliance/proposals/plansignoff.asp',NULL,1 UNION ALL 
        SELECT 489, 'Detail', 'Detail', 'compliance.proposals.Detail', '-function',488, '',NULL,1 UNION ALL 
        SELECT 490, 'plansignoff', 'Plans Sign-Off', 'compliance.proposals.Detail.plansignoff', '-liogroup',489, '/compliance/proposals/plansignoff.asp',NULL,2 UNION ALL 
        SELECT 491, 'plansignoffrecent', 'Recent Signed-Off Plans', 'compliance.proposals.Detail.plansignoffrecent', '-liogroup',489, '/compliance/proposals/recentplansignoff.asp',NULL,2 UNION ALL 
        SELECT 492, 'feeretainersignoff', 'Fees and Retainers Sign-Off', 'compliance.proposals.Detail.feeretainersignoff', '-liogroup',489, '/compliance/proposals/feeretainersignoff.asp',NULL,2 UNION ALL 
        SELECT 493, 'feeretainersignoffrecent', 'Recent Fees and Retainers Sign-Off', 'compliance.proposals.Detail.feeretainersignoffrecent', '-liogroup',489, '/compliance/proposals/recentfeeretainersignoff.asp',NULL,2 UNION ALL 
        SELECT 494, 'administration', 'Administration', 'administration', '-application',NULL, '/administration/organisation/searchusers.asp',NULL,1 UNION ALL 
        SELECT 495, 'manage', 'Manage Users', 'administration.manage', '-system',494, '/administration/organisation/searchusers.asp',NULL,1 UNION ALL 
        SELECT 496, 'users', 'Users', 'administration.manage.users', '-function',495, '',NULL,1 UNION ALL 
        SELECT 497, 'details', 'Details', 'administration.manage.users.details', '-liogroup',496, '/administration/organisation/users/detail.asp',NULL,2 UNION ALL 
        SELECT 498, 'roles', 'Role Membership', 'administration.manage.users.roles', '-liogroup',496, '/administration/organisation/users/roles.asp',NULL,2 UNION ALL 
        SELECT 499, 'delegates', 'Delegates', 'administration.manage.users.delegates', '-liogroup',496, '/administration/organisation/users/delegates.asp',NULL,2 UNION ALL 
        SELECT 500, 'activity', 'Activity', 'administration.manage.users.activity', '-liogroup',496, '/administration/organisation/users/activity.asp',NULL,2 UNION ALL 
        SELECT 501, 'roles', 'Roles', 'administration.manage.roles', '-function',495, '',NULL,1 UNION ALL 
        SELECT 502, 'details', 'Details', 'administration.manage.roles.details', '-liogroup',501, '/administration/organisation/roles/detail.asp',NULL,2 UNION ALL 
        SELECT 503, 'usermembership', 'Membership', 'administration.manage.roles.usermembership', '-liogroup',501, '/administration/organisation/roles/users.asp',NULL,2 UNION ALL 
        SELECT 504, 'addnewuser', 'Add New User', 'administration.manage.addnewuser', '-action',495, 'dialog:/administration/organisation/users/add.asp',NULL,1 UNION ALL 
        SELECT 505, 'addnewrole', 'Add New Role', 'administration.manage.addnewrole', '-action',495, 'dialog:/administration/organisation/roles/add.asp',NULL,1 UNION ALL 
        SELECT 508, 'organisation', 'Organisation', 'administration.organisation', '-system',494, '/administration/organisation/searchgroups.asp',NULL,1 UNION ALL 
        SELECT 509, 'groups', 'Groups', 'administration.organisation.groups', '-function',508, '',NULL,1 UNION ALL 
        SELECT 510, 'details', 'Details', 'administration.organisation.groups.details', '-liogroup',509, '/administration/organisation/groups/detail.asp',NULL,2 UNION ALL 
        SELECT 511, 'roles', 'Associated Roles', 'administration.organisation.groups.roles', '-liogroup',509, '/administration/organisation/groups/roles.asp',NULL,2 UNION ALL 
        SELECT 512, 'users', 'Membership', 'administration.organisation.groups.users', '-liogroup',509, '/administration/organisation/groups/users.asp',NULL,2 UNION ALL 
        SELECT 513, 'structure', 'Structure', 'administration.organisation.structure', '-function',508, '',NULL,1 UNION ALL 
        SELECT 514, 'addnewgroup', 'Add New Group', 'administration.organisation.addnewgroup', '-action',508, 'dialog:/administration/organisation/groups/add.asp',NULL,1 UNION ALL 
        SELECT 515, 'addnewgrouptype', 'Add New Group Type', 'administration.organisation.addnewgrouptype', '-action',508, 'dialog:/administration/organisation/hierarchy/add.asp',NULL,1 UNION ALL 
        SELECT 516, 'security', 'Security', 'administration.security', '-system',494, '/administration/security/entity/policy.asp',NULL,1 UNION ALL 
        SELECT 517, 'bydataentity', 'By Data Entity', 'administration.security.bydataentity', '-function',516, '',NULL,1 UNION ALL 
        SELECT 518, 'standard', 'Standard', 'administration.security.bydataentity.standard', '-liogroup',517, '/administration/security/entity/rights2.asp',NULL,2 UNION ALL 
        SELECT 519, 'advanced', 'Advanced', 'administration.security.bydataentity.advanced', '-liogroup',517, '/administration/security/entity/advanced2.asp',NULL,2 UNION ALL 
        SELECT 522, 'byfunctionalarea', 'By Functional Area', 'administration.security.byfunctionalarea', '-function',516, '',NULL,1 UNION ALL 
        SELECT 523, 'systems', 'Systems', 'administration.security.byfunctionalarea.systems', '-liogroup',522, '/administration/security/system/systems.asp',NULL,2 UNION ALL 
        SELECT 524, 'actions', 'Actions', 'administration.security.byfunctionalarea.actions', '-liogroup',522, '/administration/security/system/actions.asp',NULL,2 UNION ALL 
        SELECT 525, 'reports', 'Reports', 'administration.security.byfunctionalarea.reports', '-liogroup',522, '/administration/security/reports/reports.asp',NULL,2 UNION ALL 
        SELECT 526, 'settings', 'Settings', 'administration.settings', '-system',494, '/administration/settings/basic.asp',NULL,1 UNION ALL 
        SELECT 527, 'organisation', 'Organisation', 'administration.settings.organisation', '-function',526, '',NULL,1 UNION ALL 
        SELECT 528, 'basicdetails', 'Basic Details', 'administration.settings.organisation.basicdetails', '-liogroup',527, '/administration/settings/basic.asp',NULL,2 UNION ALL 
        SELECT 529, 'address', 'Address Details', 'administration.settings.organisation.address', '-liogroup',527, '/administration/settings/address.asp',NULL,2 UNION ALL 
        SELECT 530, 'support', 'Support Details', 'administration.settings.organisation.support', '-liogroup',527, '/administration/settings/support.asp',NULL,2 UNION ALL 
        SELECT 531, 'business', 'Business Type', 'administration.settings.organisation.business', '-liogroup',527, '/administration/settings/business.asp',NULL,2 UNION ALL 
        SELECT 532, 'licence', 'Licence Details', 'administration.settings.organisation.licence', '-liogroup',527, '/administration/settings/licence.asp',NULL,2 UNION ALL 
        SELECT 533, 'companystorage', 'Company Storage', 'administration.settings.organisation.companystorage', '-liogroup',527, '/documentmanagement/companystorage.asp',NULL,2 UNION ALL 
        SELECT 534, 'userstorage', 'User Storage', 'administration.settings.organisation.userstorage', '-liogroup',527, '/documentmanagement/userstorage.asp',NULL,2 UNION ALL 
        SELECT 535, 'usernamespasswords', 'User Names & Passwords', 'administration.settings.usernamespasswords', '-function',526, '',NULL,1 UNION ALL 
        SELECT 536, 'policy', 'Policy', 'administration.settings.usernamespasswords.policy', '-liogroup',535, '/administration/settings/policy.asp',NULL,2 UNION ALL 
        SELECT 537, 'synchronisation', 'Domain Synchronisation', 'administration.settings.usernamespasswords.synchronisation', '-liogroup',535, '/administration/settings/synchronisation.asp',NULL,2 UNION ALL 
        SELECT 538, 'expireallpasswords', 'Expire All Passwords', 'administration.settings.usernamespasswords.expireallpasswords', '-action',526, 'dialog:/administration/settings/expireallpasswords.asp',NULL,1 UNION ALL 
        SELECT 539, 'utilities', 'Tools and Utilities', 'administration.utilities', '-system',494, '/administration/toolsandutilities/dataimport/importsearch.asp',NULL,1 UNION ALL 
        SELECT 540, 'dataimport', 'Data Import', 'administration.utilities.dataimport', '-function',539, '',NULL,1 UNION ALL 
        SELECT 541, 'summary', 'Summary', 'administration.utilities.dataimport.summary', '-liogroup',540, '/administration/toolsandutilities/dataimport/importsummary.asp',NULL,2 UNION ALL 
        SELECT 542, 'statushistory', 'Status History', 'administration.utilities.dataimport.statushistory', '-liogroup',540, '/administration/toolsandutilities/dataimport/statushistory.asp',NULL,2 UNION ALL 
        SELECT 543, 'productsetup', 'Product Setup', 'administration.productsetup', '-system',494, '/reporter/admin.asp',NULL,1 UNION ALL 
        SELECT 544, 'reports', 'Reports', 'administration.productsetup.reports', '-function',543, '',NULL,1 UNION ALL 
        SELECT 545, 'queries', 'Queries', 'administration.productsetup.reports.queries', '-liogroup',544, '/reporter/admin.asp',NULL,2 UNION ALL 
        SELECT 546, 'reports', 'Reports', 'administration.productsetup.reports.reports', '-liogroup',544, '/reporter/admin.asp',NULL,2 UNION ALL 
        SELECT 547, 'refresh', 'Refresh', 'administration.productsetup.reports.refresh', '-liogroup',544, '/reporter/admin.asp',NULL,2 UNION ALL 
        SELECT 548, 'style', 'Style', 'administration.productsetup.reports.style', '-liogroup',544, '/reporter/admin.asp',NULL,2 UNION ALL 
        SELECT 549, 'addreport', 'Add Report', 'administration.productsetup.reports.addreport', '-action',543, 'javascript:AddEditReport();',NULL,1 UNION ALL 
        SELECT 550, 'addquery', 'Add Query', 'administration.productsetup.reports.addquery', '-action',543, 'javascript:AddEditQuery();',NULL,1 UNION ALL 
        SELECT 551, 'servers', 'Servers', 'administration.productsetup.servers', '-function',543, '',NULL,1 UNION ALL 
        SELECT 552, 'importsystemdata', 'Import System Data', 'administration.productsetup.importsystemdata', '-action',543, 'popup:/administration/security/system/import.asp',NULL,1 UNION ALL 
        SELECT 553, 'applicationsupport', 'Application Support', 'administration.applicationsupport', '-system',494, '/administration/applicationsupport/organisations.asp',NULL,1 UNION ALL 
        SELECT 554, 'organisationmanagment', 'Organisation Management', 'administration.applicationsupport.organisationmanagement', '-function',553, '',NULL,1 UNION ALL 
        SELECT 555, 'summary', 'Company Summary', 'administration.applicationsupport.organisationmanagement.summary', '-liogroup',554, '/administration/applicationsupport/companysummary.asp',NULL,2 UNION ALL 
        SELECT 556, 'servicelevels', 'Service Levels', 'administration.applicationsupport.organisationmanagement.servicelevels', '-liogroup',554, '/administration/applicationsupport/servicelevels.asp',NULL,2 UNION ALL 
        SELECT 557, 'usersummary', 'User Summary', 'administration.applicationsupport.organisationmanagement.usersummary', '-liogroup',554, '/administration/applicationsupport/usersummary.asp',NULL,2 UNION ALL 
        SELECT 558, 'style', 'Style', 'administration.applicationsupport.organisationmanagement.style', '-liogroup',554, '/administration/applicationsupport/style.asp',NULL,2 UNION ALL 
        SELECT 559, 'statushistory', 'Status History', 'administration.applicationsupport.organisationmanagement.statushistory', '-liogroup',554, '/administration/applicationsupport/statushistory.asp',NULL,2 UNION ALL 
        SELECT 560, 'activity', 'Activity', 'administration.applicationsupport.organisationmanagement.activity', '-liogroup',554, '/administration/applicationsupport/activity.asp',NULL,2 UNION ALL 
        SELECT 561, 'storage', 'Storage', 'administration.applicationsupport.organisationmanagement.storage', '-liogroup',554, '/documentmanagement/updatestorage.asp',NULL,2 UNION ALL 
        SELECT 562, 'addneworganisation', 'Add New Organisation', 'administration.applicationsupport.organisationmanagement.addneworganisation', '-action',553, 'dialog:/render/wizard.asp?wzName=AddOrganisation&wzAppDir=administration/applicationsupport/addorganisation',NULL,1 UNION ALL 
        SELECT 563, 'customersupport', 'Customer Support', 'administration.applicationsupport.customersupport', '-function',553, '',NULL,1 UNION ALL 
        SELECT 564, 'searchorganisation', 'Search for Organisation', 'administration.applicationsupport.customersupport.searchorganisation', '-action',553, '',NULL,1 UNION ALL 
        SELECT 565, 'dataimport', 'Data Import', 'administration.applicationsupport.dataimport', '-function',553, '',NULL,1 UNION ALL 
        SELECT 566, 'summary', 'Summary', 'administration.applicationsupport.dataimport.summary', '-liogroup',565, '/administration/applicationsupport/dataimport/importsummary.asp',NULL,2 UNION ALL 
        SELECT 567, 'mappings', 'Mappings', 'administration.applicationsupport.dataimport.mappings', '-liogroup',565, '/administration/applicationsupport/dataimport/mappings.asp',NULL,2 UNION ALL 
        SELECT 568, 'statushistory', 'Status History', 'administration.applicationsupport.dataimport.statushistory', '-liogroup',565, '/administration/applicationsupport/dataimport/statushistory.asp',NULL,2 UNION ALL 
        SELECT 569, 'addnewimport', 'Add New Import', 'administration.applicationsupport.dataimport.addnewimport', '-action',553, 'dialog:/administration/applicationsupport/dataimport/addimport.asp',NULL,1 UNION ALL 
        SELECT 574, 'client', 'Client', 'client', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 575, 'add', 'Actions:', 'client.add', '+action',574, '',NULL,1 UNION ALL 
        SELECT 576, 'addplan', 'Add Plan', 'client.add.addplan', '+subaction',575, 'dialog:/PlanManagement/ManagePlans/AddPlan/addPlan.asp',NULL,1 UNION ALL 
        SELECT 577, 'addscheme', 'Add Scheme', 'client.add.addscheme', '+subaction',575, 'dialog:/PlanManagement/ManageCorporatePlan/AddScheme/AddScheme.asp',NULL,1 UNION ALL 
        SELECT 578, 'addtopup', 'Add Top Up', 'plan.actions.addtopup', '+subaction',601, 'dialog:/PlanManagement/ManagePlans/AddTopUp/addtopup.asp',NULL,1 UNION ALL 
        SELECT 579, 'addfee', 'Add Fee', 'client.add.addfee', '+subaction',575, 'dialog:/render/wizard.asp?wzName=addFee&wzAppdir=Fees/AddFee',NULL,1 UNION ALL 
        SELECT 580, 'addretainer', 'Add Retainer', 'client.add.addretainer', '+subaction',575, 'dialog:/fees/addretainer.asp',NULL,1 UNION ALL 
        SELECT 581, 'adddocument', 'Upload Document', 'client.add.adddocument', '+subaction',575, 'dialog:/documentmanagement/new.asp',NULL,1 UNION ALL 
        SELECT 582, 'addaddress', 'Add Address', 'client.add.addaddress', '+subaction',575, 'dialog:/clientmanagement/contacts/managecontacts/newaddress.asp',NULL,1 UNION ALL 
        SELECT 583, 'addcontact', 'Add Contact', 'client.add.addcontact', '+subaction',575, 'dialog:/clientmanagement/contacts/managecontacts/AddContact.asp',NULL,1 UNION ALL 
        SELECT 584, 'addrelationship', 'Add Relationship', 'client.add.addrelationship', '+subaction',575, 'dialog:/render/wizard.asp?wzName=addRelationship&wzAppdir=ClientManagement/Contacts/ManageContacts/AddRelationship',NULL,1 UNION ALL 
        SELECT 585, 'addsplit', 'Add Client Payment Split', 'client.add.addsplit', '+subaction',575, 'dialog_status:/CommissionSplits/SelectEntityType.asp?SplitType=Template',NULL,1 UNION ALL 
        SELECT 586, 'addtask', 'Add Task', 'client.add.addtask', '+subaction',575, 'dialog_status:/organiser/tasks/addedittask.asp?TaskForClient=1',NULL,1 UNION ALL 
        SELECT 587, 'generate', 'Generate a:', 'client.generate', '+action',574, '',NULL,1 UNION ALL 
        SELECT 588, 'fee', 'Fee', 'fee', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 589, 'actions', 'Actions:', 'fee.actions', '+action',588, '',NULL,1 UNION ALL 
        SELECT 590, 'relatetoplan', 'Relate to Plan', 'fee.actions.relatetoplan', '+subaction',589, 'dialog:/fees/RelatedPlans.asp',NULL,1 UNION ALL 
        SELECT 591, 'changestatus', 'Chg. Status', 'fee.actions.changestatus', '+subaction',589, 'dialog:/fees/UpdateFeeStatus.asp',NULL,1 UNION ALL 
        SELECT 592, 'allocatepayments', 'Expected Payments', 'fee.actions.allocatepayments', '+subaction',589, 'dialog_status:/commissionsplits/viewpaymentallocation.asp?sourcetypeid=2',NULL,1 UNION ALL 
        SELECT 593, 'adddocument', 'Upload Document', 'fee.actions.adddocument', '+subaction',589, 'dialog:/documentmanagement/new.asp?EntityType=3',NULL,1 UNION ALL 
        SELECT 594, 'retainer', 'Retainer', 'retainer', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 595, 'actions', 'Actions:', 'retainer.actions', '+action',594, '',NULL,1 UNION ALL 
        SELECT 596, 'changestatus', 'Change Status', 'retainer.actions.changestatus', '+subaction',595, 'dialog:/fees/UpdateRetainerStatus.asp',NULL,1 UNION ALL 
        SELECT 597, 'allocatepayments', 'Expected Payments', 'retainer.actions.allocatepayments', '+subaction',595, 'dialog_status:/commissionsplits/viewpaymentallocation.asp?sourcetypeid=3',NULL,1 UNION ALL 
        SELECT 598, 'adddocument', 'Upload Document', 'retainer.actions.adddocument', '+subaction',595, 'dialog:/documentmanagement/new.asp?EntityType=4',NULL,1 UNION ALL 
        SELECT 599, 'creditnote', 'Credit Note', 'creditnote', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 600, 'plan', 'Plan', 'plan', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 601, 'actions', 'Actions:', 'plan.actions', '+action',600, '',NULL,1 UNION ALL 
        SELECT 602, 'changestatus', 'Change Status', 'plan.actions.changestatus', '+subaction',601, 'dialog:/PlanManagement/ManagePlans/AddStatus/addStatus.asp',NULL,1 UNION ALL 
        SELECT 603, 'allocatepayments', 'Expected Payments Calculator', 'plan.actions.allocatepayments', '+subaction',601, 'dialog_status:/commissionsplits/viewpaymentallocation.asp?sourcetypeid=4',NULL,1 UNION ALL 
        SELECT 604, 'bussub', 'View Business Submission Sheet', 'plan.actions.bussub', '+subaction',601, 'print:/planmanagement/manageplans/businesssubmission/businesssubmissionsheet.asp?portrait=true',NULL,1 UNION ALL 
        SELECT 605, 'addtask', 'Add Task', 'plan.actions.addtask', '+subaction',601, 'dialog_status:/organiser/tasks/addedittask.asp?TaskForPlan=1',NULL,1 UNION ALL 
        SELECT 606, 'adddocument', 'Upload Document', 'plan.actions.adddocument', '+subaction',601, 'dialog:/documentmanagement/new.asp?EntityType=2',NULL,1 UNION ALL 
        SELECT 607, 'task', 'Task', 'task', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 608, 'actions', 'Actions:', 'task.actions', '+action',607, '',NULL,1 UNION ALL 
        SELECT 609, 'adddocument', 'Upload Document', 'task.actions.adddocument', '+subaction',608, 'dialog:/documentmanagement/new.asp?EntityType=5',NULL,1 UNION ALL 
        SELECT 611, 'document', 'Document', 'document', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 612, 'proposal', 'Proposal', 'proposal', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 613, 'actions', 'Actions:', 'proposal.actions', '+action',612, '',NULL,1 UNION ALL 
        SELECT 614, 'changestatus', 'Change Status', 'proposal.actions.changestatus', '+subaction',613, '???',NULL,1 UNION ALL 
        SELECT 615, 'reassigntccoach', 'Reassign T&C Coach', 'proposal.actions.reassigntccoach', '+subaction',613, '???',NULL,1 UNION ALL 
        SELECT 616, 'breakdownsummary', 'Provider Statement', 'breakdownsummary', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 617, 'actions', 'Actions:', 'breakdownsummary.actions', '+action',616, '',NULL,1 UNION ALL 
        SELECT 618, 'breakdownsummary', 'View Breakdown Summary', 'breakdownsummary.actions.breakdownsummary', '+subaction',617, 'javascript:showProvBreakSummary();',NULL,1 UNION ALL 
        SELECT 619, 'importedbreakdownsummary', 'Provider Statement', 'importedbreakdownsummary', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 620, 'importedproviderstatement', 'Imported Provider Statement', 'importedproviderstatement', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 621, 'actions', 'Actions:', 'importedproviderstatement.actions', '+action',620, '',NULL,1 UNION ALL 
        SELECT 622, 'makelive', 'Make Live', 'importedproviderstatement.actions.makelive', '+subaction',621, '????',NULL,1 UNION ALL 
        SELECT 623, 'introducer', 'Introducer', 'introducer', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 624, 'actions', 'Actions:', 'introducer.actions', '+action',623, '',NULL,1 UNION ALL 
        SELECT 625, 'addaddress', 'Add Address', 'introducer.actions.addaddress', '+subaction',624, 'dialog:/clientmanagement/contacts/managecontacts/newaddress.asp',NULL,1 UNION ALL 
        SELECT 626, 'breakdownmatch', 'Breakdown Item', 'breakdownmatch', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 627, 'policypaymenthistory', 'Policy History', 'policypaymenthistory', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 628, 'cashreceipt', 'Cash Receipt', 'cashreceipt', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 629, 'cashreceiptexp', 'Cash Receipt', 'cashreceiptexp', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 631, 'paragraph', 'Paragraph', 'paragraph', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 632, 'casefile', 'Case File', 'casefile', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 633, 'tnccoach', 'Tnc Coach', 'tnccoach', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 634, 'adviser', 'Adviser', 'adviser', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 635, 'user', 'User', 'user', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 636, 'actions', 'Actions:', 'user.actions', '+action',635, '',NULL,1 UNION ALL 
        SELECT 637, 'edit', 'Edit Details', 'user.actions.edit', '+subaction',636, 'dialog:/administration/organisation/users/edit.asp',NULL,1 UNION ALL 
        SELECT 638, 'move', 'Move User', 'user.actions.move', '+subaction',636, 'dialog:/administration/organisation/users/move.asp',NULL,1 UNION ALL 
        SELECT 639, 'assignrole', 'Assign Role', 'user.actions.assignrole', '+subaction',636, 'dialog:/administration/organisation/users/associate.asp',NULL,1 UNION ALL 
        SELECT 640, 'adddelegate', 'Add Delegate', 'user.actions.adddelegate', '+subaction',636, 'dialog:/administration/organisation/users/delegate.asp',NULL,1 UNION ALL 
        SELECT 641, 'setupdelegators', 'Setup Delegators', 'user.actions.setupdelegators', '+subaction',636, 'dialog:/administration/organisation/users/delegators.asp',NULL,1 UNION ALL 
        SELECT 642, 'changestatus', 'Change Status', 'user.actions.changestatus', '+subaction',636, 'dialog:/administration/organisation/users/updatestatus.asp',NULL,1 UNION ALL 
        SELECT 644, 'group', 'Group', 'group', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 645, 'actions', 'Actions:', 'group.actions', '+action',644, '',NULL,1 UNION ALL 
        SELECT 646, 'edit', 'Edit Details', 'group.actions.edit', '+subaction',645, 'dialog:/administration/organisation/groups/edit.asp',NULL,1 UNION ALL 
        SELECT 647, 'role', 'Role', 'role', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 648, 'grouping', 'Group Type', 'grouping', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 649, 'organisation', 'Organisation', 'organisation', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 650, 'actions', 'Actions:', 'organisation.actions', '+action',649, '',NULL,1 UNION ALL 
        SELECT 651, 'changestatus', 'Change Status', 'organisation.actions.changestatus', '+subaction',650, 'dialog:/administration/applicationsupport/changestatus.asp',NULL,1 UNION ALL 
        SELECT 652, 'modifyStyle', 'Edit Stylesheet', 'organisation.actions.modifyStyle', '+subaction',650, 'dialog:/administration/settings/style.asp',NULL,1 UNION ALL 
        SELECT 653, 'report', 'Report', 'report', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 655, 'scheme', 'Scheme', 'scheme', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 656, 'folders', 'Current Folder', 'folders', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 657, 'add', 'Actions:', 'folders.add', '+action',656, '',NULL,1 UNION ALL 
        SELECT 658, 'adddoc', 'Add Document', 'folders.add.adddoc', '+subaction',657, 'dialog:/documentmanagement/new.asp',NULL,1 UNION ALL 
        SELECT 659, 'editfolder', 'Edit Folder', 'folders.add.editfolder', '+subaction',657, 'dialog:/documentmanagement/addfolder.asp?mode=edit',NULL,1 UNION ALL 
        SELECT 660, 'restrictprocessing', 'Restrict Processing', 'client.add.restrictprocessing', '+subaction',575, 'dialog_status:/clientmanagement/contacts/managecontacts/deletecontact.asp',NULL,1 UNION ALL 
        SELECT 661, 'tools', 'Tools', 'adviserworkplace.clients.tools', '-function',324, '',NULL,1 UNION ALL 
        SELECT 662, 'clientresearch', 'Client Research', 'adviserworkplace.clients.research.clientresearch', '-liogroup',661, '/researchtools/listclientresearch.asp',NULL,2 UNION ALL 
        SELECT 663, 'clientresearch', 'Client Research', 'adviserworkplace.clients.research.clientresearch', '-liogroup',662, '/researchtools/listclientresearch.asp',NULL,2 UNION ALL 
        SELECT 664, 'addresearch', 'Launch Calculators', 'client.add.addresearch', '+subaction',575, 'popup:/render/wizard.asp?wzName=addResearch&wzAppdir=ResearchTools',NULL,1 UNION ALL 
        SELECT 665, 'leads', 'Leads', 'adviserworkplace.leads', '-system',323, '/clientmanagement/contacts/managecontacts/leadsearch.asp',NULL,1 UNION ALL 
        SELECT 666, 'details', 'Details', 'adviserworkplace.leads.details', '-function',665, '',NULL,1 UNION ALL 
        SELECT 667, 'add', 'Actions:', 'lead.add', '+action',761, '',NULL,1 UNION ALL 
        SELECT 668, 'addaddress', 'Add Address', 'lead.add.addaddress', '+subaction',667, 'dialog:/clientmanagement/contacts/managecontacts/newaddress.asp',NULL,1 UNION ALL 
        SELECT 669, 'addcontact', 'Add Contact', 'lead.add.addcontact', '+subaction',667, 'dialog:/clientmanagement/contacts/managecontacts/AddContact.asp',NULL,1 UNION ALL 
        SELECT 670, 'addrelationship', 'Add Relationship', 'lead.add.addrelationship', '+subaction',667, 'dialog:/render/wizard.asp?wzName=addRelationship&wzAppdir=ClientManagement/Contacts/ManageContacts/AddRelationship',NULL,1 UNION ALL 
        SELECT 671, 'changestatus', 'Change Status', 'lead.add.changestatus', '+subaction',667, 'dialog:/clientmanagement/contacts/managecontacts/ChangeLeadStatus.asp',NULL,1 UNION ALL 
        SELECT 672, 'adddocument', 'Upload Document', 'lead.add.adddocument', '+subaction',667, 'dialog:/documentmanagement/leadnew.asp',NULL,1 UNION ALL 
        SELECT 673, 'addtask', 'Add Task', 'lead.add.addtask', '+subaction',667, 'dialog_status:/organiser/tasks/addedittask.asp?TaskForClient=1',NULL,1 UNION ALL 
        SELECT 674, 'summary', 'Summary', 'adviserworkplace.leads.details.summary', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadsummary.asp',NULL,2 UNION ALL 
        SELECT 675, 'personal', 'Personal', 'adviserworkplace.leads.details.personal', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadperson.asp',NULL,2 UNION ALL 
        SELECT 676, 'trust', 'Trust', 'adviserworkplace.leads.details.trust', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadtrust.asp',NULL,2 UNION ALL 
        SELECT 677, 'corporate', 'Company', 'adviserworkplace.leads.details.corporate', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadcorporate.asp',NULL,2 UNION ALL 
        SELECT 678, 'address', 'Address Details', 'adviserworkplace.leads.details.address', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadaddress.asp',NULL,2 UNION ALL 
        SELECT 679, 'contact', 'Contact Details', 'adviserworkplace.leads.details.contact', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadcontact.asp',NULL,2 UNION ALL 
        SELECT 680, 'relationships', 'Relationships', 'adviserworkplace.leads.details.relationships', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadrelationships.asp',NULL,2 UNION ALL 
        SELECT 681, 'relationships', 'Trustees & Beneficiaries', 'adviserworkplace.leads.details.relationships', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadrelationships.asp',NULL,2 UNION ALL 
        SELECT 682, 'relationships', 'Relationships', 'adviserworkplace.leads.details.relationships', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadrelationships.asp',NULL,2 UNION ALL 
        SELECT 683, 'leadstatushistory', 'Status History', 'adviserworkplace.leads.details.leadstatushistory', '-liogroup',666, '/clientmanagement/contacts/managecontacts/leadstatushistory.asp',NULL,2 UNION ALL 
        SELECT 684, 'tasks', 'Tasks', 'adviserworkplace.leads.tasks', '-function',665, '',NULL,1 UNION ALL 
        SELECT 685, 'todo', 'To Do', 'adviserworkplace.leads.tasks.todo', '-liogroup',684, '/organiser/tasks/leadcontacttasks.asp',NULL,2 UNION ALL 
        SELECT 686, 'documents', 'Documents', 'adviserworkplace.leads.tasks.documents', '-liogroup',684, '/organiser/tasks/leadtaskdocuments.asp',NULL,2 UNION ALL 
        SELECT 687, 'documents', 'Documents', 'adviserworkplace.leads.documents', '-function',665, '',NULL,1 UNION ALL 
        SELECT 688, 'documents', 'documents', 'adviserworkplace.leads.documents.documents', '-liogroup',687, '/documentmanagement/leadcontactdocuments.asp',NULL,2 UNION ALL 
        SELECT 689, 'profile', 'Profile', 'adviserworkplace.leads.documents.profile', '-liogroup',687, '/documentmanagement/leadversionprofile.asp',NULL,2 UNION ALL 
        SELECT 690, 'documenthistory', 'Document History', 'adviserworkplace.leads.documents.documenthistory', '-liogroup',687, '/documentmanagement/leadhistory.asp',NULL,2 UNION ALL 
        SELECT 691, 'leadadmin', 'Administration', 'adviserworkplace.leads.leadadmin', '-function',665, '',NULL,1 UNION ALL 
        SELECT 692, 'addlead', 'Add Lead', 'adviserworkplace.leads.addlead', '-action',665, 'dialog:/render/wizard.asp?wzName=addLead&wzAppdir=ClientManagement/contacts/managecontacts/addContact&Parameters=',NULL,1 UNION ALL 
        SELECT 694, 'mortgage', '14. Mortgage', 'adviserworkplace.clients.plans.mortgage', '-liogroup',336, '/planmanagement/manageplans/mortgagedetails.asp',NULL,2 UNION ALL 
        SELECT 695, 'openfactfind', 'Fact Find', 'client.add.openfactfind', '+subaction',575, 'dialog:/FactFind/home.aspx',NULL,1 UNION ALL 
        SELECT 697, 'adminimportfile', 'Import File', 'adminimportfile', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 699, 'referencedata', 'Reference Data', 'administration.organisation.referencedata', '-function',508, NULL,NULL,1 UNION ALL 
        SELECT 700, 'activities', 'Activity Types', 'administration.organisation.referencedata.activities', '-group',NULL, '/administration/organisation/referencedata/activities.asp',NULL,1 UNION ALL 
        SELECT 701, 'activitycategoryparents', 'Activity Categories', 'administration.organisation.referencedata.activitycategoryparents', '-group',NULL, '/administration/organisation/referencedata/activitycategoryparent.asp',NULL,1 UNION ALL 
        SELECT 704, 'queuecontact', 'Contacts', 'administration.services.definequeues.queuecontact', '-group',NULL, '/messenger/definecontact.asp',NULL,1 UNION ALL 
        SELECT 705, 'queueforms', 'Request Types', 'administration.services.definequeues.queueforms', '-group',NULL, '/messenger/defineforms.asp',NULL,1 UNION ALL 
        SELECT 706, 'queuehandlerrole', 'Handler Roles', 'administration.services.definequeues.queuehandlerrole', '-group',NULL, '/messenger/definehandlerroles.asp',NULL,1 UNION ALL 
        SELECT 707, 'queuemanagerrole', 'Manager Roles', 'administration.services.definequeues.queuemanagerrole', '-group',NULL, '/messenger/definemanagerroles.asp',NULL,1 UNION ALL 
        SELECT 708, 'queuestatus', 'Statuses', 'administration.services.definequeues.queuestatus', '-group',NULL, '/messenger/definestatus.asp',NULL,1 UNION ALL 
        SELECT 709, 'queuesubmitrole', 'Submitter Roles', 'administration.services.definequeues.queuesubmitrole', '-group',NULL, '/messenger/definesubmitroles.asp',NULL,1 UNION ALL 
        SELECT 710, 'services', 'Summary', 'administration.services.definequeues.services', '-group',NULL, '/messenger/definequeue.asp',NULL,1 UNION ALL 
        SELECT 711, 'addnote', 'Add Note', 'adviser.actions.addnote', '+subaction',832, 'dialog:/notes/addnotes.asp?EntityType=adviser&EntityId=pid',NULL,1 UNION ALL 
        SELECT 712, 'addqualification', 'Add Qualification', 'adviser.actions.addqualification', '+subaction',832, 'dialog:/compliance/training/addqualification.asp',NULL,1 UNION ALL 
        SELECT 713, 'inheritagencynumbers', 'Inherit Agency Numbers', 'adviser.actions.inheritagencynumbers', '+subaction',832, 'dialog:/commissions/advisers/InheritAgencyNumbers.asp',NULL,1 UNION ALL 
        SELECT 714, 'notes', 'Notes', 'adviserworkplace.clients.details.notes', '-liogroup',325, '/notes/viewnotes.asp',NULL,2 UNION ALL 
        SELECT 715, 'notes', '8. Notes', 'adviserworkplace.clients.plans.notes', '-liogroup',336, '/notes/viewnotes.asp',NULL,2 UNION ALL 
        SELECT 716, 'plantaskview', '6. Tasks', 'adviserworkplace.clients.plans.plantaskview', '-liogroup',336, '/planmanagement/manageplans/plantasks.asp',NULL,2 UNION ALL 
        SELECT 717, 'filechecks', 'Post-File Checks', 'adviserworkplace.sales.filechecks', '-function',372, NULL,NULL,1 UNION ALL 
        SELECT 718, 'review', 'File Review', 'adviserworkplace.sales.filechecks.review', '-group',NULL, '/workplace/filecheck/filereview.asp',NULL,1 UNION ALL 
        SELECT 719, 'completecheck', 'Complete Check', 'casefile.actions.completecheck', '+subaction',793, 'dialog:/compliance/filecheckmini/completecheck.asp',NULL,1 UNION ALL 
        SELECT 720, 'updateremedial', 'Update Remedial', 'casefile.actions.updateremedial', '+subaction',793, 'dialog:/compliance/filecheckmini/updateremedial.asp',NULL,1 UNION ALL 
        SELECT 721, 'addeventlist', 'Add Event List', 'client.add.addeventlist', '+subaction',575, 'dialog:/render/wizard.asp?wzname=addeventlist&wzappdir=eventlists/addevent&RelatedTo=client',NULL,1 UNION ALL 
        SELECT 722, 'addnote', 'Add Note', 'client.add.addnote', '+subaction',575, 'dialog:/notes/addnotes.asp?EntityType=crmcontact&EntityId=cid',NULL,1 UNION ALL 
        SELECT 724, 'agencynumbers', 'Agency Numbers', 'commissions.advisers.details.agencynumbers', '-liogroup',425, '/commissions/advisers/agencynumbers.asp',NULL,2 UNION ALL 
        SELECT 725, 'unallocated', 'Unallocated', 'commissions.providerstatements.automatching.unallocated', '-liogroup',392, '/commissions/provstates/automatching/unallocated.asp',NULL,2 UNION ALL 
        SELECT 726, 'complaint', 'Complaint', 'complaint', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 727, 'feeretainer', 'Fees & Retainers', 'compliance.administration.feeretainer', '-function',478, NULL,NULL,1 UNION ALL 
        SELECT 728, 'lifecycle', 'Life Cycle', 'compliance.administration.lifecycle', '-function',478, NULL,NULL,1 UNION ALL 
        SELECT 729, 'lifecycleplantype', 'Plan Type Life Cycle', 'compliance.administration.lifecycle.lifecycleplantype', '-group',NULL, '/planmanagement/manageplans/lifecycle.asp',NULL,1 UNION ALL 
        SELECT 730, 'training', 'Training', 'compliance.administration.training', '-function',478, NULL,NULL,1 UNION ALL 
        SELECT 731, 'addcourse', 'Add Course', 'compliance.administration.training.addcourse', '-action',478, 'dialog:/compliance/training/addcourse.asp',NULL,1 UNION ALL 
        SELECT 732, 'cpd', 'CPD', 'compliance.advisers.cpd', '-function',449, NULL,NULL,1 UNION ALL 
        SELECT 733, 'qualification', 'Qualifications', 'compliance.advisers.cpd.qualification', '-group',NULL, '/compliance/adviser/qualification.asp',NULL,1 UNION ALL 
        SELECT 734, 'training', 'Training', 'compliance.advisers.cpd.training', '-group',NULL, '/compliance/adviser/training.asp',NULL,1 UNION ALL 
        SELECT 735, 'notes', 'Notes', 'compliance.advisers.manage.notes', '-liogroup',450, '/notes/viewnotes.asp',NULL,2 UNION ALL 
        SELECT 736, 'tnc', 'T&C', 'compliance.advisers.tnc', '-function',449, NULL,NULL,1 UNION ALL 
        SELECT 737, 'complaints', 'Complaints', 'compliance.advisers.tnc.complaints', '-group',NULL, '/compliance/adviser/complaints.asp',NULL,1 UNION ALL 
        SELECT 738, 'review', 'File Review', 'compliance.advisers.tnc.review', '-group',NULL, '/compliance/adviser/filereview.asp',NULL,1 UNION ALL 
        SELECT 739, 'status', 'Risk & Competency', 'compliance.advisers.tnc.status', '-group',NULL, '/compliance/adviser/adviserstatus.asp',NULL,1 UNION ALL 
        SELECT 740, 'headerfooter', 'Headers & Footers', 'compliance.author.headerfooter', '-function',465, NULL,NULL,1 UNION ALL 
        SELECT 741, 'headerfooter', 'List', 'compliance.author.headerfooter.headerfooter', '-group',NULL, '/author/admin/headersfooters.asp',NULL,1 UNION ALL 
        SELECT 742, 'headersfootersversions', 'Version History', 'compliance.author.headerfooter.headersfootersversions', '-group',NULL, '/author/admin/headerfooterversions.asp',NULL,1 UNION ALL 
        SELECT 743, 'complaints', 'Complaints', 'compliance.complaints', '-system',445, '/compliance/complaints/complaintssearch.asp',NULL,1 UNION ALL 
        SELECT 744, 'addcompliant', 'Add Complaint', 'compliance.complaints.addcompliant', '-action',743, 'dialog:/compliance/complaints/newcomplaint.asp',NULL,1 UNION ALL 
        SELECT 745, 'compliantsqueue', 'Compliants Queue', 'compliance.complaints.compliantsqueue', '-function',743, NULL,NULL,1 UNION ALL 
        SELECT 746, 'compliantsqueue', 'Unassigned Complaints', 'compliance.complaints.compliantsqueue.compliantsqueue', '-group',NULL, '/compliance/complaints/complaintsqueue.asp',NULL,1 UNION ALL 
        SELECT 747, 'complaintdetail', 'Complaint Details', 'compliance.complaints.manage.complaintdetail', '-group',NULL, '/compliance/complaints/complaintdetails.asp',NULL,1 UNION ALL 
        SELECT 748, 'setup', 'Set Up', 'compliance.complaints.setup', '-function',743, NULL,NULL,1 UNION ALL 
        SELECT 749, 'complaintsetup', 'Complaint Setup', 'compliance.complaints.setup.complaintsetup', '-group',NULL, '/compliance/complaints/complaintsetup.asp',NULL,1 UNION ALL 
        SELECT 750, 'eventlists', 'Event Lists', 'compliance.eventlists', '-system',445, '/eventlists/admin/templates.asp',NULL,1 UNION ALL 
        SELECT 751, 'checklist', 'Checklist', 'compliance.filechecking.file.checklist', '-liogroup',447, '/compliance/filecheckmini/filecheckchecklist.asp',NULL,2 UNION ALL 
        SELECT 752, 'filesummary', 'Summary', 'compliance.filechecking.file.filesummary', '-liogroup',447, '/compliance/filecheckmini/filechecksummary.asp',NULL,2 UNION ALL 
        SELECT 753, 'queue', 'File Queue', 'compliance.filechecking.queue', '-function',446, NULL,NULL,1 UNION ALL 
        SELECT 754, 'fileCheckQueue', 'Unassigned File Checks', 'compliance.filechecking.queue.fileCheckQueue', '-group',NULL, '/compliance/filecheck/filecheckqueue.asp',NULL,1 UNION ALL 
        SELECT 755, 'setup', 'Set Up', 'compliance.filechecking.setup', '-function',446, NULL,NULL,1 UNION ALL 
        SELECT 756, 'adviserrisksetup', 'Adviser Risk Setup', 'compliance.filechecking.setup.adviserrisksetup', '-group',NULL, '/compliance/filecheck/practitionerrisksetup.asp',NULL,1 UNION ALL 
        SELECT 757, 'lifecycle', 'Life Cycle Setup', 'compliance.filechecking.setup.lifecycle', '-group',NULL, '/compliance/filecheck/lifecyclesetup.asp',NULL,1 UNION ALL 
        SELECT 758, 'productrisksetup', 'Product Risk Setup', 'compliance.filechecking.setup.productrisksetup', '-group',NULL, '/compliance/filecheck/productrisksetup.asp',NULL,1 UNION ALL 
        SELECT 759, 'header/Footer', 'Header/Footer', 'header/Footer', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 760, 'importfile', 'Import File', 'importfile', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 761, 'lead', 'Lead', 'lead', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 762, 'personaldocument', 'Document', 'personaldocument', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 763, 'addeventlist', 'Add Event List', 'plan.actions.addeventlist', '+subaction',601, 'dialog:/render/wizard.asp?wzname=addeventlist&wzappdir=eventlists/addevent&RelatedTo=plan',NULL,1 UNION ALL 
        SELECT 764, 'addnote', 'Add Note', 'plan.actions.addnote', '+subaction',601, 'dialog:/notes/addnotes.asp?EntityType=plan&EntityId=pbid',NULL,1 UNION ALL 
        SELECT 765, 'fciexception', 'Ignore in FCI Chasing', 'plan.actions.fciexception', '+subaction',601, 'dialog:/reporter/reportmanagement/fciexception.asp',NULL,1 UNION ALL 
        SELECT 766, 'qualification', 'Qualification', 'qualification', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 772, 'service', 'Service', 'service', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 773, 'services', 'Services', 'services', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 774, 'newrequest', 'New Request', 'services.actions.newrequest', '+subaction',834, 'dialog:/render/wizard.asp?wzName=newMessage&wzAppdir=messenger',NULL,1 UNION ALL 
        SELECT 775, 'edituserbilling', 'Edit Billing Details', 'user.actions.edituserbilling', '+subaction',636, 'dialog:/administration/organisation/users/billing.asp',NULL,1 UNION ALL 
        SELECT 781, 'binder', 'Binder', 'binder', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 782, 'actions', 'Actions:', 'binder.actions', '+action',781, '',NULL,1 UNION ALL 
        SELECT 783, 'changestatus', 'Change Status', 'binder.actions.changestatus', '+subaction',782, 'dialog:/DocumentManagement/binders/ChangeStatus.asp',NULL,1 UNION ALL 
        SELECT 784, 'addnote', 'Add Note', 'binder.actions.addnote', '+subaction',782, 'dialog:/notes/addnotes.asp?EntityType=binder&amp;EntityId=bndr',NULL,1 UNION ALL 
        SELECT 785, 'notes', 'Notes', 'adviserworkplace.leads.details.notes', '-liogroup',666, '/notes/viewnotes.asp',NULL,2 UNION ALL 
        SELECT 786, 'addnote', 'Add Note', 'lead.add.addnote', '+subaction',667, 'dialog:/notes/addnotes.asp?EntityType=crmcontact&amp;EntityId=cid',NULL,1 UNION ALL 
        SELECT 787, 'addvaluation', 'Add Valuation', 'plan.actions.addvaluation', '+subaction',601, 'dialog_status:/valuation/addvaluation.asp',NULL,1 UNION ALL 
        SELECT 788, 'mysetup', 'My Setup', 'home.mysetup', '-system',1209, '',NULL,1 UNION ALL 
        SELECT 789, 'account', 'Account', 'mysetup.account', '-system',788, '/administration/organisation/users/setup.asp',NULL,1 UNION ALL 
        SELECT 790, 'portals', 'Portals', 'mysetup.portals', '-system',788, '/valuation/portals.asp',NULL,1 UNION ALL 
        SELECT 791, 'admin', 'Admin', 'mysetup.account.admin', '-function',789, 'administration/organisation/users/setup.asp',NULL,1 UNION ALL 
        SELECT 793, 'actions', 'Actions:', 'casefile.actions', '+action',632, NULL,NULL,1 UNION ALL 
        SELECT 794, 'email', 'Email Setup', 'mysetup.email', '-system',788, '/administration/email/setup.asp',NULL,1 UNION ALL 
        SELECT 795, 'emaildetails', 'Details', 'mysetup.email.emaildetails', '-function',794, '/administration/email/setup.asp',NULL,1 UNION ALL 
        SELECT 796, 'signatures', 'Signatures', 'mysetup.email.signatures', '-function',794, '/administration/email/signatures.asp',NULL,1 UNION ALL 
        SELECT 797, 'emailtemplates', 'Templates', 'mysetup.email.emailtemplates', '-function',794, '/administration/email/templates.asp',NULL,1 UNION ALL 
        SELECT 798, 'outbox', 'Bulk Email Outbox', 'mysetup.email.outbox', '-function',794, '/administration/email/outbox.asp',NULL,1 UNION ALL 
        SELECT 799, 'mailinglist', 'Mailing Lists', 'mysetup.email.mailinglist', '-function',794, '/administration/email/mailinglists.asp',NULL,1 UNION ALL 
        SELECT 808, 'sendemail', 'Send Email', 'adviserworkplace.clients.sendemail', '-action',324, 'dialog_status:/administration/email/sendemail.asp',NULL,1 UNION ALL 
        SELECT 809, 'campaigns', 'Campaigns', 'administration.organisation.campaigns', '-function',508, '/administration/organisation/referencedata/campaigntypes.asp',NULL,1 UNION ALL 
        SELECT 810, 'campaigntypes', 'Campaign Types', 'administration.organisation.campaigns.campaigntypes', '-liogroup',809, '/administration/organisation/referencedata/campaigntypes.asp',NULL,2 UNION ALL 
        SELECT 811, 'organisationalcampaigns', 'Organisational Campaigns', 'administration.organisation.campaigns.organisationalcampaigns', '-liogroup',809, '/administration/organisation/referencedata/organisationalcampaigns.asp',NULL,2 UNION ALL 
        SELECT 812, 'groupcampaigns', 'Group Campaigns', 'administration.organisation.campaigns.groupcampaigns', '-liogroup',809, '/administration/organisation/referencedata/groupcampaigns.asp',NULL,2 UNION ALL 
        SELECT 814, 'fundmaintenance', 'Fund Maintenance', 'administration.organisation.fundmaintenance', '-function',508, '/planmanagement/manageplans/fundSearchAdmin.asp',NULL,1 UNION ALL 
        SELECT 815, 'multitie', 'Multi-Tie', 'compliance.administration.registers.multitie', '-liogroup',485, '/compliance/register/setupmultitie.asp',NULL,2 UNION ALL 
        SELECT 816, 'switchmultitie', 'Change Multi-Tie', 'adviser.actions.switchmultietie', '+subaction',832, 'dialog:/compliance/adviser/changemultitie.asp',NULL,1 UNION ALL 
        SELECT 817, 'addopportunity', 'Add Opportunity', 'client.add.addopportunity', '+subaction',575, 'dialog:/clientmanagement/contacts/opportunitymanagement/addopportunity.asp',NULL,1 UNION ALL 
        SELECT 818, 'opportunity', 'Opportunity', 'opportunity', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 819, 'add', 'Actions:', 'opportunity.add', '+action',818, NULL,NULL,1 UNION ALL 
        SELECT 820, 'addnote', 'Add Note', 'opportunity.add.addnote', '+subaction',819, 'dialog:/notes/addnotes.asp?EntityType=opportunity&amp;EntityId=opportunityid',NULL,1 UNION ALL 
        SELECT 821, 'linkplans', 'Link Plans', 'opportunity.add.linkplans', '+subaction',819, 'dialog:/clientmanagement/contacts/opportunitymanagement/linkplans.asp',NULL,1 UNION ALL 
        SELECT 822, 'opportunities', 'Opportunities', 'administration.organisation.opportunities', '-funtion',508, '/clientmanagement/contacts/opportunitymanagement/opportunitytypes.asp',NULL,1 UNION ALL 
        SELECT 823, 'opportunitytypes', 'Opportunity Types', 'administration.organisation.opportunities.opportunitytypes', '-liogroup',822, '/clientmanagement/contacts/opportunitymanagement/opportunitytypes.asp',NULL,2 UNION ALL 
        SELECT 824, 'opportunitystatuses', 'Opportunity Statuses', 'administration.organisation.opportunities.opportunitystatuses', '-liogroup',822, '/clientmanagement/contacts/opportunitymanagement/opportunitystatuses.asp',NULL,2 UNION ALL 
        SELECT 825, 'getnewquote', 'Get New Quote', 'client.add.getnewquote', '+subaction',575, 'dialog_status:/quotes/getnewExWebquote.asp',NULL,1 UNION ALL 
        SELECT 826, 'opportunities', 'Opportunities', 'adviserworkplace.clients.opportunities', '-function',324, '/clientmanagement/contacts/opportunitymanagement/opportunities.asp',NULL,1 UNION ALL 
        SELECT 830, 'addtask', 'Add Task', 'opportunity.add.addtask', '+subaction',819, 'dialog_status:/organiser/tasks/addedittask.asp?TaskForOpportunity=1',NULL,1 UNION ALL 
        SELECT 832, 'actions', 'Actions:', 'adviser.actions', '+action',634, NULL,NULL,1 UNION ALL 
        SELECT 834, 'actions', 'Actions:', 'services.actions', '+action',773, NULL,NULL,1 UNION ALL 
        SELECT 835, 'legalentity', 'Make Legal Entity', 'group.actions.legalentity', '+subaction',645, 'dialog:/administration/organisation/groups/legalentity.asp',NULL,1 UNION ALL 
        SELECT 836, 'opencorporatefactfind', 'Corporate Fact Find', 'client.add.opencorporatefactfind', '+subaction',575, 'dialog:/FactFind/home.aspx',NULL,1 UNION ALL 
        SELECT 837, 'editclientref', 'Change Client Ref', 'client.add.editReference', '+subaction',575, 'dialog:/clientmanagement/contacts/managecontacts/EditReference.asp',NULL,1 UNION ALL 
        SELECT 840, 'editMigrationReference', 'Change Migration Ref', 'client.add.editMigrationReference', '+subaction',575, 'dialog:/clientmanagement/contacts/managecontacts/EditMigrationRef.asp',NULL,1 UNION ALL 
        SELECT 841, 'discountreasons', 'Discount Reasons', 'commissions.administration.discountreasons', '-function',431, '/commissions/administration/discountreasons.asp',NULL,1 UNION ALL 
        SELECT 843, 'reallocate', 'Reallocate', 'client.function.reallocate', '+subaction',575, '/clientmanagement/contacts/managecontacts/reallocate.asp',NULL,1 UNION ALL 
        SELECT 844, 'clientdashboard', 'Dashboard', 'adviserworkplace.clients.clientdashboard', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 845, 'paymenthistory', 'Payment History', 'plan.actions.paymenthistory', '+subaction',601, 'popup:/clientmanagement/contacts/managecontacts/fcipaymentreport.asp',NULL,1 UNION ALL 
        SELECT 846, 'editleadinterest', 'Edit Interest', 'lead.add.editinterest', '+subaction',667, 'dialog:/clientmanagement/contacts/managecontacts/EditLeadInterest.asp',NULL,1 UNION ALL 
        SELECT 847, 'registration', 'Registration', 'mysetup.portals.registration', '-function',790, '/valuation/portals.asp',NULL,1 UNION ALL 
        SELECT 848, 'editCommissionRate', 'Change Adviser Banding', 'plan.actions.editCommissionRate', '+subaction',601, 'dialog:/PlanManagement/ManagePlans/EditCommissionRate.asp',NULL,2 UNION ALL 
        SELECT 849, 'modifyadjustmentsubtypes', 'Modify Adjustment Sub-Types', 'commissions.administration.modifyadjustmentsubtypes', '-function',431, NULL,NULL,1 UNION ALL 
        SELECT 850, 'editidentifier', 'Edit Identifier', 'opportunity.add.editidentifier', '+subaction',819, 'dialog:/clientmanagement/contacts/opportunitymanagement/editidentifier.asp',NULL,1 UNION ALL 
        SELECT 851, 'advisertypes', 'Adviser Types', 'compliance.administration.advisertypes', '-function',478, NULL,NULL,1 UNION ALL 
        SELECT 852, 'modifyplantype', 'Change Plan Type', 'plan.actions.changeplantype', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 853, 'policynumberformat', 'Policy Number Format', 'commissions.administration.policynumberformat', '-function',431, '/Commissions/Administration/PolicyNoFormating/PolicyNoFormating.asp',NULL,1 UNION ALL 
        SELECT 854, 'submittofilechecking', 'Submit To File Checking', 'plan.actions.submittofilechecking', '+subaction',601, 'dialog:/PlanManagement/ManagePlans/AddStatus/submitToFileChecking.asp',NULL,1 UNION ALL 
        SELECT 855, 'unallocatedcommissions', 'Unallocated Commissions', 'commissions.providerstatements.unallocatedcommissions', '-function',381, '/commissions/provstates/unallocatedcommissions/unallocatedcommissions.asp',NULL,1 UNION ALL 
        SELECT 857, 'addasset', 'Add Asset', 'client.add.addasset', '+subaction',575, 'dialog:/planmanagement/manageplans/addasset/addasset.asp',NULL,1 UNION ALL 
        SELECT 858, 'download', 'Download Bulk Upload Template', 'commissions.advisers.download', '-action',424, '/commissions/advisers/selecttemplate.asp',NULL,1 UNION ALL 
        SELECT 859, 'import', 'Import Completed Bulk Upload Template', 'commissions.advisers.import', '-action',424, '/commissions/advisers/adviserimport.asp',NULL,1 UNION ALL 
        SELECT 860, 'history', 'Import History', 'commissions.advisers.history', '-action',424, '/commissions/advisers/importhistory.asp',NULL,1 UNION ALL 
        SELECT 861, 'quotesandapps', 'Quotes & Apps', 'adviserworkplace.clients.quotesandapps', '-function',324, '/qvtnet/quotes/clientquotes.aspx',NULL,1 UNION ALL 
        SELECT 862, 'clientquotedetail', 'Client Quote Detail', 'clientquotedetail', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 863, 'actions', 'Actions', 'clientquotedetail.actions', '+action',862, '',NULL,1 UNION ALL 
        SELECT 864, 'fullquotationanalysis', 'Full Quotation Analysis', 'clientquotedetail.actions.fullquotationanalysis', '+subaction',863, '',NULL,1 UNION ALL 
        SELECT 865, 'uploadquotationdocument', 'Upload Document', 'clientquotedetail.actions.uploadquotationdocument', '+subaction',863, '',NULL,1 UNION ALL 
        SELECT 868, 'importhistory', 'Import History', 'adviserworkplace.leads.importhistory', '-action',665, NULL,NULL,1 UNION ALL 
        SELECT 869, 'changeprovider', 'Change Provider', 'plan.actions.changeprovider', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 870, 'breaches', 'Breaches', 'compliance.breaches', '-system',445, '/compliance/breach/breachsearch.asp',NULL,1 UNION ALL 
        SELECT 871, 'search', 'Search', 'compliance.breaches.search', '-function',870, '/compliance/breach/breachsearch.asp',NULL,1 UNION ALL 
        SELECT 872, 'manage', 'Details', 'compliance.breaches.details', '-function',870, '/compliance/breach/breachsearch.asp',NULL,1 UNION ALL 
        SELECT 873, 'addbreach', 'Add Breach', 'compliance.breaches.addbreach', '-action',870, 'dialog:/compliance/breach/addbreach.asp',NULL,1 UNION ALL 
        SELECT 874, 'breachsummary', 'Adviser', 'breachsummary', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 875, 'actions', 'Actions:', 'breachsummary.actions', '+action',874, '',NULL,1 UNION ALL 
        SELECT 876, 'addnotegeneral', 'Add Note', 'breachsummary.actions.addnotegeneral', '+subaction',875, 'dialog:/compliance/breach/addnotegeneral.asp',NULL,1 UNION ALL 
        SELECT 877, 'addnoteaction', 'Add Action Taken', 'breachsummary.actions.addnoteaction', '+subaction',875, 'dialog:/compliance/breach/addnoteaction.asp',NULL,1 UNION ALL 
        SELECT 878, 'deletebreach', 'Delete Breach', 'breachsummary.actions.deletebreach', '+subaction',875, 'dialog:/compliance/breach/delete.asp',NULL,1 UNION ALL 
        SELECT 884, 'breaches', 'Breaches', 'compliance.administration.breaches', '-function',478, '',NULL,1 UNION ALL 
        SELECT 885, 'natureofbreach', 'Nature of Breach', 'compliance.administration.breaches.natureofbreach', '-liogroup',884, '/compliance/breach/administration/natureofbreach.asp',NULL,2 UNION ALL 
        SELECT 886, 'natureofresolution', 'Nature of Resolution', 'compliance.administration.breaches.natureofresolution', '-liogroup',884, '/compliance/breach/administration/natureofresolution.asp',NULL,2 UNION ALL 
        SELECT 887, 'managelinkeddocs', 'Manage Linked Documents', 'administration.organisation.managelinkeddocs', '-action',508, 'dialog:/factfindoffline/managelinkeddocuments.aspx',NULL,1 UNION ALL 
        SELECT 888, 'riskandmodels', 'Risk & Models', 'administration.organisation.riskandmodels', '-function',508, '/administration/atr/riskprofiles.asp',NULL,1 UNION ALL 
        SELECT 889, 'changeriskrating', 'Change Risk Rating', 'adviser.actions.changeriskrating', '+subaction',832, 'dialog:/Compliance/Adviser/ChangeStatus.asp?TypeId=2',NULL,1 UNION ALL 
        SELECT 890, 'viewriskratinghistory', 'View Risk Rating History', 'adviser.actions.viewriskratinghistory', '+subaction',832, 'dialog:/Compliance/Adviser/RiskRatingHistory.asp',NULL,1 UNION ALL 
        SELECT 891, 'toplevelnavigation', 'Top Level Navigation', 'toplevelnavigation', '-application',NULL, NULL,NULL,1 UNION ALL 
        SELECT 892, 'myrecentitems', 'My Recent Items', 'home.recentitems', '-system',1209, '',NULL,1 UNION ALL 
        SELECT 894, 'library', 'Library', 'home.library', '-system',1209, '',NULL,1 UNION ALL 
        SELECT 896, 'contactsupport', 'Contact Support', 'toplevelnavigation.support', '-action',891, 'openWindow(''/administration/applicationsupport/helpdesk.asp'', ''support'', 200, 500, false, false, false, false);',NULL,1 UNION ALL 
        SELECT 897, 'userguide', 'User Guide', 'toplevelnavigation.help', '-action',891, 'openWindow(''/documents/help/new/default.htm'',''help'',600,900,true,true,true,false);',NULL,1 UNION ALL 
        SELECT 898, 'logoff', 'Logoff', 'toplevelnavigation.logoff', '-action',891, 'window.parent.close()',NULL,1 UNION ALL 
        SELECT 899, 'paymenthistory', 'Payment History', 'fee.actions.paymenthistory', '+subaction',589, 'dialog:/fees/RelatedPlans.asp',NULL,1 UNION ALL 
        SELECT 900, 'reportaddressconfiguration', 'Report Address Configuration', 'administration.organisation.reportaddressconfig', '-action',508, '/Administration/Organisation/AddressConfig.asp',NULL,2 UNION ALL 
        SELECT 901, 'automation', 'Automation', 'administration.automation', '-system',494, '/valuation/scheduleddownloads.asp',NULL,1 UNION ALL 
        SELECT 902, 'actions', 'Actions:', 'document.actions', '+action',611, NULL,NULL,1 UNION ALL 
        SELECT 903, 'changestatus', 'Change Status', 'document.actions.changestatus', '+subaction',902, 'dialog:/documentmanagement/changestatus.asp',NULL,1 UNION ALL 
        SELECT 904, 'addclientbankaccount', 'Add Bank Account', 'client.add.addclientbankaccount', '+subaction',575, 'dialog:/clientmanagement/contacts/managecontacts/addclientbankaccount.asp',NULL,1 UNION ALL 
        SELECT 905, 'documents', 'Documents', 'administration.documents', '-system',494, '/administration/organisation/documents/statusorder.asp',NULL,1 UNION ALL 
        SELECT 906, 'addsplit', 'Setup Lead Split', 'lead.add.addsplit', '+subaction',667, 'dialog_status:/CommissionSplits/SelectEntityType.asp?SplitType=Template&amp;TemplateType=Lead',NULL,1 UNION ALL 
        SELECT 907, 'tasks', 'Activities', 'compliance.advisers.tasks', '-function',449, '/Compliance/Adviser/AdviserTasks.asp',NULL,1 UNION ALL 
        SELECT 908, 'addtask', 'Add Task', 'adviser.actions.addtask', '+subaction',832, 'dialog_status:/organiser/tasks/addedittask.asp?TaskForAdviser=1',NULL,1 UNION ALL 
        SELECT 909, 'addeventlist', 'Add Event List', 'adviser.actions.addeventlist', '+subaction',832, 'dialog:/render/wizard.asp?wzname=addeventlist&amp;wzappdir=eventlists/addevent&amp;RelatedTo=adviser',NULL,1 UNION ALL 
        SELECT 910, 'adddocument', 'Upload Document', 'adviser.actions.adddocument', '+subaction',832, 'dialog:/documentmanagement/xupload/add.asp?ForAdviser=1',NULL,1 UNION ALL 
        SELECT 911, 'documents', 'Documents', 'compliance.advisers.documents', '-function',449, '/documentmanagement/adviserdocuments.asp',NULL,1 UNION ALL 
        SELECT 912, 'binders', 'Binders', 'compliance.advisers.binders', '-function',449, '/documentmanagement/binders/binders.asp',NULL,1 UNION ALL 
        SELECT 913, 'actions', 'Actions:', 'complaint.actions', '+action',726, '',NULL,1 UNION ALL 
        SELECT 914, 'changestatus', 'Change Status', 'complaint.actions.changestatus', '+subaction',913, 'dialog:/compliance/complaints/changestatus.asp',NULL,1 UNION ALL 
        SELECT 915, 'adddocument', 'Add Document', 'complaint.actions.adddocument', '+subaction',913, 'dialog:/documentmanagement/xupload/add.asp?EntityType=12',NULL,1 UNION ALL 
        SELECT 916, 'manage', 'Details', 'compliance.complaints.manage', '-function',743, '',NULL,1 UNION ALL 
        SELECT 917, 'sourcemortgage', 'Source Mortgage', 'opportunity.add.sourcemortgage', '+subaction',819, '/nio/MortgageSourcing/${sysId}/SourceMortgage',NULL,1 UNION ALL 
        SELECT 919, 'addtowrapper', 'Add To Wrap', 'plan.actions.addtowrapper', '+subaction',601, 'dialog_status:/planmanagement/manageplans/addplan/addplantowrapper.asp',NULL,1 UNION ALL 
        SELECT 920, 'addaddress', 'Add Address', 'adviser.actions.addaddress', '+subaction',832, 'dialog:/clientmanagement/contacts/managecontacts/newaddress.asp',NULL,1 UNION ALL 
        SELECT 921, 'modifyintroducertypes', 'Modify Introducer Types', 'commissions.administration.payeeconfiguration.modifyintroducertypes', '-action',439, 'dialog_status:/commissions/introducer/introducertypes.asp',NULL,1 UNION ALL 
        SELECT 922, 'conductIdVerification', 'Verify ID', 'client.add.conductIdVerification', '+subaction',575, 'dialog_status:/clientmanagementnet/contacts/managecontacts/IDVerification/IDVerification.aspx',NULL,1 UNION ALL 
        SELECT 923, 'editcommissionrate', 'Edit Commission Rate', 'fee.actions.editcommissionrate', '+subaction',589, 'dialog:/fees/editcommissionrate.asp',NULL,1 UNION ALL 
        SELECT 924, 'editcommissionrate', 'Edit Commission Rate', 'retainer.actions.editcommissionrate', '+subaction',595, 'dialog:/fees/editcommissionrate.asp',NULL,1 UNION ALL 
        SELECT 925, 'advicecase', 'Service Case', 'advicecase', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 926, 'add', 'Actions:', 'advicecase.add', '+action',925, NULL,NULL,1 UNION ALL 
        SELECT 927, 'changestatus', 'Change Status', 'advicecase.add.changestatus', '+subaction',926, 'dialog:/clientmanagement/contacts/advicecases/changestatus.asp',NULL,1 UNION ALL 
        SELECT 928, 'linkplans', 'Link Plans', 'advicecase.add.linkplans', '+subaction',926, 'dialog:/clientmanagement/contacts/advicecases/linkplans.asp',NULL,1 UNION ALL 
        SELECT 929, 'addadvice', 'Add Service', 'client.add.addadvice', '+subaction',575, 'dialog:/clientmanagement/contacts/advicecases/addadvicecase.asp',NULL,1 UNION ALL 
        SELECT 930, 'word', 'Open In Word', 'client.generate.word', '+subaction',587, '',NULL,1 UNION ALL 
        SELECT 931, 'rtf', 'Open As RTF', 'client.generate.rtf', '+subaction',587, '',NULL,1 UNION ALL 
        SELECT 933, 'merge', 'Insert Merge Field', 'client.generate.merge', '+subaction',587, '',NULL,1 UNION ALL 
        SELECT 934, 'bylegalentity', 'By Legal Entity', 'administration.security.bylegalentity', '-function',516, '/Administration/Security/System/LegalEntities.asp',NULL,1 UNION ALL 
        SELECT 935, 'duplicateclientconfig', 'Duplicate Client Settings', 'administration.organisation.duplicateclientconfig', '-action',508, '/Administration/Organisation/dupclientconfig.asp',NULL,1 UNION ALL 
        SELECT 936, 'templates', 'Templates', 'administration.templates', '-system',494, '',NULL,1 UNION ALL 
        SELECT 937, 'settings', 'Settings', 'administration.templates.settings', '-function',936, '',NULL,1 UNION ALL 
        SELECT 938, 'portfolioreport', 'Portfolio Report', 'administration.templates.portfolioreport', '-function',936, '',NULL,1 UNION ALL 
        SELECT 940, 'addobjective', 'Add Goal', 'client.add.addobjective', '+subaction',575, 'dialog_status:/clientmanagement/contacts/opportunitymanagement/addobjective.asp',NULL,1 UNION ALL 
        SELECT 941, 'linkfees', 'Link Fees', 'opportunity.add.linkfees', '+subaction',819, 'dialog:/clientmanagement/contacts/opportunitymanagement/linkfees.asp',NULL,1 UNION ALL 
        SELECT 942, 'linkobjectives', 'Link Goals', 'opportunity.add.linkobjectives', '+subaction',819, 'dialog:/clientmanagement/contacts/opportunitymanagement/linkobjectives.asp',NULL,1 UNION ALL 
        SELECT 943, 'linkadvicecase', 'Link/Unlink Service Case', 'opportunity.add.linkadvicecase', '+subaction',819, 'dialog:/clientmanagement/contacts/opportunitymanagement/linkadvicecase.asp',NULL,1 UNION ALL 
        SELECT 944, 'opportunities', 'Opportunities', 'adviserworkplace.opportunities', '-system',323, '/clientmanagement/contacts/opportunitymanagement/opportunitysearch.asp',NULL,1 UNION ALL 
        SELECT 945, 'opportunities', 'Opportunities', 'adviserworkplace.opportunities.opportunities', '-function',944, '',NULL,1 UNION ALL 
        SELECT 946, 'opportunities', 'Opportunities', 'adviserworkplace.opportunities.opportunities.opportunitysearch', '-liogroup',945, '/clientmanagement/contacts/opportunitymanagement/opportunitysearch.asp',NULL,2 UNION ALL 
        SELECT 947, 'objectives', 'Goals', 'adviserworkplace.opportunities.objectives', '-function',944, '',NULL,1 UNION ALL 
        SELECT 948, 'objectives', 'Objectives', 'adviserworkplace.opportunities.objectives.objectivesearch', '-liogroup',947, '/clientmanagement/contacts/opportunitymanagement/objectivesearch.asp',NULL,2 UNION ALL 
        SELECT 949, 'addplan', 'Add Sub Plan', 'plan.actions.addplan', '+subaction',601, 'dialog_status:/planmanagement/manageplans/addplan/addplan.asp',NULL,1 UNION ALL 
        SELECT 950, 'addtaxwrapper', 'Add Tax Wrapper', 'plan.actions.addtaxwrapper', '+subaction',601, 'dialog_status:/planmanagement/manageplans/addplan/addplan.asp',NULL,1 UNION ALL 
        SELECT 951, 'integration', 'Integration', 'administration.organisation.integration', '-function',508, '',NULL,1 UNION ALL 
        SELECT 953, 'adddocument', 'Upload Document', 'advicecase.add.adddocument', '+subaction',926, 'dialog:/documentmanagement/xupload/add.asp?EntityType=19',NULL,1 UNION ALL 
        SELECT 954, 'editcase', 'Edit Service Case', 'advicecase.add.editcase', '+subaction',926, 'dialog:/clientmanagement/contacts/advicecases/editadvicecase.asp',NULL,1 UNION ALL 
        SELECT 955, 'deletecase', 'Delete Service Case', 'advicecase.add.deletecase', '+subaction',926, 'dialog:/clientmanagement/contacts/advicecases/deleteadvicecase.asp',NULL,1 UNION ALL 
        SELECT 956, 'adddocument', 'Upload Document', 'opportunity.add.adddocument', '+subaction',819, 'dialog:/documentmanagement/xupload/add.asp?EntityType=18',NULL,1 UNION ALL 
        SELECT 957, 'addsplittemplategroup', 'Copy Split Template Group', 'client.add.addsplittemplategroup', '+subaction',575, 'dialog_status:/CommissionSplits/SelectSplitTemplateGroup.asp?GroupType=Client',NULL,1 UNION ALL 
        SELECT 958, 'addfeesplit', 'Add Fee Payment Split', 'fee.actions.addfeesplit', '+subaction',589, 'javascript:AddSplit();',NULL,1 UNION ALL 
        SELECT 959, 'addrestainersplit', 'Setup Split', 'retainer.actions.addretainersplit', '+subaction',595, 'javascript:AddSplit();',NULL,1 UNION ALL 
        SELECT 960, 'addplansplit', 'Add Plan Payment Split', 'plan.actions.addplansplit', '+subaction',601, 'javascript:AddSplit();',NULL,1 UNION ALL 
        SELECT 961, 'addsplit', 'Setup Adviser Split', 'adviser.actions.addsplit', '+subaction',832, 'dialog_status:/CommissionSplits/SelectEntityType.asp?SplitType=Template&amp;TemplateType=Practitioner',NULL,1 UNION ALL 
        SELECT 962, 'splitroleconfig', 'Split Role Setup', 'commissions.administration.payeeconfiguration.splitroleconfig', '-liogroup',439, '/commissions/administration/splitroleconfig.asp',NULL,2 UNION ALL 
        SELECT 963, 'groupsplitsetup', 'Group Split Setup', 'commissions.administration.payeeconfiguration.groupsplitsetup', '-liogroup',439, '/commissions/administration/groupsplitsetup.asp',NULL,2 UNION ALL 
        SELECT 964, 'addfund', 'Add Fund', 'plan.actions.addfund', '+subaction',601, 'javascript:doAddFund(''Fund'');',NULL,1 UNION ALL 
        SELECT 965, 'addequity', 'Add Equity', 'plan.actions.addequity', '+subaction',601, 'javascript:doAddFund(''Equity'');',NULL,1 UNION ALL 
        SELECT 966, 'addasset', 'Add Asset', 'plan.actions.addasset', '+subaction',601, 'javascript:doAddAsset()',NULL,1 UNION ALL 
        SELECT 967, 'addcontact', 'Add Contact', 'adviser.actions.addcontact', '+subaction',832, 'dialog:/clientmanagement/contacts/managecontacts/AddContact.asp',NULL,1 UNION ALL 
        SELECT 968, 'scheduledownloads', 'Schedule Downloads', 'administration.automation.scheduledownloads', '-function',901, '',NULL,1 UNION ALL 
        SELECT 969, 'taskconfig', 'Tasks', 'administration.automation.taskconfig', '-function',901, '',NULL,1 UNION ALL 
        SELECT 970, 'organiser', 'Organiser', 'organiser', '-application',NULL, '',NULL,1 UNION ALL 
        SELECT 972, 'tasks', 'Tasks', 'organiser.tasks', '-system',970, '/organiser/tasks/usertasks.asp',NULL,1 UNION ALL 
        SELECT 973, 'addnewtask', 'Add New Task', 'organiser.tasks.addnewtask', '-action',972, 'dialog:/organiser/tasks/addedittask.asp?TaskForUser=1',NULL,1 UNION ALL 
        SELECT 974, 'mytask', 'My Tasks', 'organiser.tasks.mytask', '-function',972, '/organiser/tasks/usertasks.asp',NULL,1 UNION ALL 
        SELECT 975, 'queuetasks', 'Queue Tasks', 'organiser.tasks.queuetasks', '-function',972, '/organiser/tasks/queuedtasks.asp',NULL,1 UNION ALL 
        SELECT 976, 'activitysearch', 'Activity Search', 'organiser.tasks.activitysearch', '-function',972, '/organiser/activitysearch',NULL,1 UNION ALL 
        SELECT 977, 'diary', 'Diary', 'organiser.diary', '-system',970, '/organiser/diary/appointments.asp',NULL,1 UNION ALL 
        SELECT 978, 'adddocument', 'Add Document', 'adviserworkplace.clients.adddocument', '-action',324, 'dialog:/render/wizard.asp?wzname=addDocument&amp;wzappdir=documentmanagement/xupload&amp;selectclient=true',NULL,1 UNION ALL 
        SELECT 979, 'takeownership', 'Take Ownership', 'task.actions.takeownership', '+subaction',608, 'dialog:/organiser/tasks/takeownership.asp',NULL,1 UNION ALL 
        SELECT 980, 'returntoqueue', 'Return to Queue', 'task.actions.returntoqueue', '+subaction',608, 'dialog:/organiser/tasks/returntoqueue.asp',NULL,1 UNION ALL 
        SELECT 981, 'assigntask', 'Assign Task', 'task.actions.assigntask', '+subaction',608, 'dialog:/organiser/tasks/assigntask.asp',NULL,1 UNION ALL 
        SELECT 982, 'advicecases', 'Service Cases', 'adviserworkplace.clients.advicecases', '-function',324, '/clientmanagement/contacts/advicecases/advicecases.asp',NULL,1 UNION ALL 
        SELECT 983, 'categories', 'Categories', 'compliance.administration.filechecking.categories', '-liogroup',479, 'nio',NULL,2 UNION ALL 
        SELECT 984, 'checklistcategoryquestions', 'Check List Category Questions', 'compliance.administration.filechecking.checklistcategoryquestions', '-liogroup',479, 'nio',NULL,2 UNION ALL 
        SELECT 985, 'filecheckcasestatuses', 'File Check Case Statuses', 'compliance.administration.filechecking.filecheckcasestatuses', '-liogroup',479, 'nio',NULL,2 UNION ALL 
        SELECT 986, 'statusmapping', 'Status Mapping', 'compliance.administration.filechecking.statusmapping', '-liogroup',479, 'nio',NULL,2 UNION ALL 
        SELECT 987, 'advicecasestatuses', 'Service Case Statuses', 'compliance.administration.filechecking.advicecasestatuses', '-liogroup',479, 'nio',NULL,2 UNION ALL 
        SELECT 988, 'advicecasestatustransition', 'Service Case Status Transition', 'compliance.administration.filechecking.advicecasestatustransition', '-liogroup',479, 'nio',NULL,2 UNION ALL 
        SELECT 989, 'linkfee', 'Link Fees', 'advicecase.add.linkfees', '+subaction',926, 'dialog:/clientmanagement/contacts/advicecases/linkfees.asp',NULL,1 UNION ALL 
        SELECT 990, 'linktocompliance', 'Link to Compliance Case', 'advicecase.add.linktocompliance', '+subaction',926, 'dialog:/clientmanagement/contacts/advicecases/editlinktoadvice.asp',NULL,1 UNION ALL 
        SELECT 991, 'linktodms', 'Link to DMS', 'client.add.linktodms', '+subaction',575, 'dialog:/clientmanagement/contacts/invu/invu.asp?type=Client',NULL,1 UNION ALL 
        SELECT 992, 'linktodms', 'Link to DMS', 'plan.actions.linktodms', '+subaction',601, 'dialog:/clientmanagement/contacts/invu.asp?type=Plan',NULL,1 UNION ALL 
        SELECT 993, 'linktodms', 'Link to DMS', 'task.actions.linktodms', '+subaction',608, 'dialog:/clientmanagement/contacts/invu.asp?type=Task',NULL,1 UNION ALL 
        SELECT 994, 'modifyvaluation', 'Change Valuation Schedule', 'plan.actions.modifyvaluation', '+subaction',601, 'dialog_status:/valuation/ModifyValuation.asp',NULL,1 UNION ALL 
        SELECT 996, 'casesnapshot', 'Business Monitoring Report', 'casefile.actions.casesnapshot', '+subaction',793, 'dialog:/clientmanagementnet/filecheck/casesnapshot.aspx',NULL,1 UNION ALL 
        SELECT 997, 'deletecasefile', 'Delete Case File', 'casefile.actions.deletecasefile', '+subaction',793, NULL,NULL,1 UNION ALL 
        SELECT 998, 'categories', 'Categories', 'compliance.author.categories', '-function',465, NULL,NULL,1 UNION ALL 
        SELECT 999, 'categories', 'Categories', 'compliance.author.categories.categories', '-liogroup',998, '/author/admin/categories.asp',NULL,2 UNION ALL 
        SELECT 1000, 'revisetopups', 'Revise Top Ups', 'plan.actions.revisetopups', '+subaction',601, 'dialog_status:/planmanagement/manageplans/revisetopups.asp',NULL,1 UNION ALL 
        SELECT 1001, 'setup', 'Setup', 'administration.documents.setup', '-function',905, '',NULL,1 UNION ALL 
        SELECT 1002, 'storage', 'storage', 'administration.documents.storage', '-function',905, '/documentmanagement/companystorage.asp',NULL,1 UNION ALL 
        SELECT 1003, 'referencedata', 'Reference Data', 'administration.documents.referencedata', '-function',905, '/documentmanagement/administration/category.asp',NULL,1 UNION ALL 
        SELECT 1004, 'scannersettings', 'Scanner Settings', 'administration.documents.scannersettings', '-function',905, '/documentmanagement/administration/scannersettings.asp',NULL,1 UNION ALL 
        SELECT 1005, 'planpurposeplantypes', 'Compliance Registers', 'planpurposeplantypes', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1006, 'actions', 'Actions', 'planpurposeplantypes.actions', '+action',1005, NULL,NULL,1 UNION ALL 
        SELECT 1007, 'addplanpurpose', 'Add Plan Purpose', 'planpurposeplantypes.actions.addplanpurpose', '+subaction',1006, NULL,NULL,1 UNION ALL 
        SELECT 1008, 'allocateStatement', 'Allocate statement to lookups', 'breakdownsummary.actions.allocateStatement', '+subaction',617, 'javascript:AllocateStatement();',NULL,1 UNION ALL 
        SELECT 1009, 'allocateStatement', 'Deallocate whole statement', 'breakdownsummary.actions.deallocateStatement', '+subaction',617, 'javascript:DeAllocateStatement();',NULL,1 UNION ALL 
        SELECT 1010, 'clientmerge', 'Merge Client', 'client.add.clientmerge', '+subaction',575, 'dialog:/clientmanagement/contacts/managecontacts/clientmerge.asp',NULL,1 UNION ALL 
        SELECT 1011, 'vatconfig', 'VAT Configuration', 'group.actions.vatconfig', '+subaction',645, 'dialog:/administration/organisation/groups/vat.asp',NULL,1 UNION ALL 
        SELECT 1012, 'uploadgrouplogo', 'Upload Group Logo', 'group.actions.uploadgrouplogo', '+subaction',645, 'dialog:/administration/organisation/groups/groupLogo.asp',NULL,1 UNION ALL 
        SELECT 1013, 'paymenthistory', 'Payment History', 'retainer.actions.paymenthistory', '+subaction',595, '',NULL,1 UNION ALL 
        SELECT 1014, 'addcontact', 'Add Contact', 'group.actions.addcontact', '+subaction',645, 'dialog:/clientmanagement/contacts/managecontacts/AddContact.asp',NULL,1 UNION ALL 
        SELECT 1015, 'amendsellingadviser', 'Change Selling Adviser', 'plan.actions.amendsellingadviser', '+subaction',601, 'dialog_status:/planmanagement/manageplans/amendsellingadviser.asp',NULL,1 UNION ALL 
        SELECT 1016, 'assignmanager', 'Assign Manager', 'adviser.actions.assignmanager', '+subaction',832, '',NULL,1 UNION ALL 
        SELECT 1017, 'switchoffpanel', 'Switch Off Panel', 'adviser.actions.switchoffpanel', '+subaction',832, '',NULL,1 UNION ALL 
        SELECT 1018, 'pricemaintenance', 'Price Maintenance', 'administration.organisation.pricemaintenance', '-function',508, '',NULL,1 UNION ALL 
        SELECT 1019, 'addeventlist', 'Add Event List', 'lead.add.addeventlist', '+subaction',667, '',NULL,1 UNION ALL 
        SELECT 1149, 'search', 'Search', 'compliance.advisers.search', '-function',449, '/compliance/adviser/advisersearch.asp',NULL,1 UNION ALL 
        SELECT 1150, 'fundanalysis', 'Fund Analysis', 'adviserworkplace.fundanalysis', '-system',323, NULL,NULL,1 UNION ALL 
        SELECT 1151, 'search', 'Search', 'adviserworkplace.fundanalysis.search', '-system',1150, NULL,NULL,1 UNION ALL 
        SELECT 1152, 'legalentity', 'Legal Entity', 'commissions.administration.legalentity', '-function',431, NULL,NULL,1 UNION ALL 
        SELECT 1153, 'addfundanalysis', 'Start Fund Analysis', 'adviserworkplace.fundanalysis.actions.addfundanalysis', '+subaction',575, NULL,NULL,2 UNION ALL 
        SELECT 1154, 'addportfolio', 'Add Custom Portfolio', 'adviserworkplace.fundanalysis.actions.addportfolio', '+subaction',575, NULL,NULL,2 UNION ALL 
        SELECT 1155, 'deleteemail', 'Delete Email', 'email.actions.delete', '+subaction',1530, NULL,NULL,1 UNION ALL 
        SELECT 1156, 'addemaillink', 'Add Link', 'email.actions.addlink', '+subaction',1530, NULL,NULL,1 UNION ALL 
        SELECT 1157, 'fundanalysis', 'Fund Analysis', 'fundanalysis', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1158, 'actions', 'Actions:', 'fundanalysis.actions', '+action',1157, NULL,NULL,1 UNION ALL 
        SELECT 1159, 'delete', 'Delete Analysis', 'fundanalysis.actions.delete', '+subaction',1158, NULL,NULL,1 UNION ALL 
        SELECT 1160, 'clone', 'Clone Analysis', 'fundanalysis.actions.clone', '+subaction',1158, NULL,NULL,1 UNION ALL 
        SELECT 1161, 'report', 'View Report', 'fundanalysis.actions.report', '+subaction',1158, NULL,NULL,1 UNION ALL 
        SELECT 1162, 'portfolio', 'Portfolio', 'portfolio', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1163, 'actions', 'Actions:', 'portfolio.actions', '+action',1162, NULL,NULL,1 UNION ALL 
        SELECT 1164, 'delete', 'Delete Portfolio', 'portfolio.actions.delete', '+subaction',1163, NULL,NULL,1 UNION ALL 
        SELECT 1165, 'relate', 'Relate Plan', 'portfolio.actions.relate', '+subaction',1163, NULL,NULL,1 UNION ALL 
        SELECT 1166, 'rebalance', 'Rebalance', 'portfolio.actions.rebalance', '+subaction',1163, NULL,NULL,1 UNION ALL 
        SELECT 1167, 'actions', 'Actions:', 'scheme.actions', '+action',655, NULL,NULL,1 UNION ALL 
        SELECT 1168, 'changestatus', 'Change Status', 'scheme.actions.changestatus', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1169, 'changeplantype', 'Change Plan Type', 'scheme.actions.changeplantype', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1170, 'changeprovider', 'Change Provider', 'scheme.actions.changeprovider', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1171, 'addcategory', 'Add Category', 'scheme.actions.addcategory', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1172, 'memberimportwizard', 'Member Import Wizard', 'scheme.actions.memberimportwizard', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1173, 'memberimporthistory', 'Member Import History', 'scheme.actions.memberimporthistory', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1174, 'memberexport', 'Member Export', 'scheme.actions.memberexport', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1175, 'updatedataimport', 'Update Data Import', 'scheme.actions.updatedataimport', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1176, 'addtask', 'Add Task', 'scheme.actions.addtask', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1177, 'addnote', 'Add Note', 'scheme.actions.addnote', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1178, 'mi', 'MI Reports', 'mi', '-application',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1179, 'reportlist', 'Report List', 'mi.reportlist', '-system',1178, NULL,NULL,1 UNION ALL 
        SELECT 1180, 'account', 'Account', 'account', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1181, 'accounts', 'Accounts', 'adviserworkplace.accounts', '-system',323, '',NULL,1 UNION ALL 
        SELECT 1182, 'details', 'Details', 'adviserworkplace.accounts.details', '-function',1181, '',NULL,1 UNION ALL 
        SELECT 1183, 'summary', 'Summary', 'adviserworkplace.accounts.details.summary', '-liogroup',1182, '',NULL,2 UNION ALL 
        SELECT 1184, 'address', 'Address Detail', 'adviserworkplace.accounts.details.address', '-liogroup',1182, '',NULL,2 UNION ALL 
        SELECT 1185, 'contact', 'Contact Detail', 'adviserworkplace.accounts.details.contact', '-liogroup',1182, '',NULL,2 UNION ALL 
        SELECT 1186, 'relationships', 'Relationships', 'adviserworkplace.accounts.details.relationships', '-liogroup',1182, '',NULL,2 UNION ALL 
        SELECT 1187, 'notes', 'Notes', 'adviserworkplace.accounts.details.notes', '-liogroup',1182, '',NULL,2 UNION ALL 
        SELECT 1188, 'add', 'Actions', 'account.add', '+action',1180, '',NULL,1 UNION ALL 
        SELECT 1189, 'addaddress', 'Add Address', 'account.add.addaddress', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1190, 'addcontact', 'Add Contact', 'account.add.addcontact', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1191, 'addrelationship', 'Add Relationship', 'account.add.addrelationship', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1192, 'addnote', 'Add Note', 'account.add.addnote', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1193, 'adddocument', 'Upload Document', 'account.add.adddocument', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1194, 'addtask', 'Add Task', 'account.add.addtask', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1195, 'editaccountref', 'Edit Account Ref', 'account.add.editreference', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1196, 'addeventlist', 'Add Event List', 'account.add.addeventlist', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1197, 'deleteaccount', 'Delete Account', 'account.add.deleteaccount', '+subaction',1188, '',NULL,1 UNION ALL 
        SELECT 1198, 'activities', 'Activities', 'adviserworkplace.accounts.activities', '-function',1181, '',NULL,1 UNION ALL 
        SELECT 1199, 'documents', 'Documents', 'adviserworkplace.accounts.documents', '-function',1181, '',NULL,1 UNION ALL 
        SELECT 1200, 'binders', 'Binders', 'adviserworkplace.accounts.binders', '-function',1181, '',NULL,1 UNION ALL 
        SELECT 1201, 'accounttypes', 'Account Types', 'administration.organisation.referencedata.accounttypes', '-group',NULL, '',NULL,1 UNION ALL 
        SELECT 1202, 'template', 'Template', 'template', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1203, 'actions', 'Actions:', 'template.actions', '+action',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1204, 'uploadversion', 'Upload New Version:', 'template.actions.uploadversion', '+subaction',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1205, 'mailmerge', 'Mail Merge', 'adviserworkplace.communication.mailmerge', '-function',1435, NULL,NULL,1 UNION ALL 
        SELECT 1206, 'licencemanagement', 'License Management', 'administration.applicationsupport.licencemanagement', '-function',553, NULL,NULL,1 UNION ALL 
        SELECT 1207, 'addaccount', 'Add Account', 'adviserworkplace.accounts.addaccount', '-action',1181, NULL,NULL,1 UNION ALL 
        SELECT 1208, 'linkretainers', 'Link Retainers', 'advicecase.add.linkretainers', '+subaction',926, 'dialog:/clientmanagement/contacts/advicecases/linkretainers.asp',NULL,1 UNION ALL 
        SELECT 1209, 'home', 'Home', 'home', '-application',NULL, '',NULL,1 UNION ALL 
        SELECT 1210, 'dashboard', 'Dashboard', 'home.dashboard', '-system',1209, '',NULL,1 UNION ALL 
        SELECT 1211, 'user dashboard', 'User Dashboard', 'home.dashboard.userdashboard', '-function',1210, '',NULL,1 UNION ALL 
        SELECT 1213, 'glossary', 'Glossary', 'administration.templates.glossary', '-function',936, NULL,NULL,1 UNION ALL 
        SELECT 1214, 'financialplanning', 'Financial Planning', 'administration.templates.financialplanning', '-function',936, NULL,NULL,1 UNION ALL 
        SELECT 1215, 'fundanalysis', 'Fund Analysis', 'administration.templates.fundanalysis', '-function',936, NULL,NULL,1 UNION ALL 
        SELECT 1216, 'addappointment', 'Add Appointment', 'organiser.diary.addappointment', '-action',977, NULL,NULL,1 UNION ALL 
        SELECT 1217, 'uploads', 'Uploads', 'home.uploads', '-system',1209, NULL,NULL,1 UNION ALL 
        SELECT 1218, 'valuationbulkupload', 'Upload File', 'home.uploads.valuationbulkupload', '-action',1217, NULL,NULL,2 UNION ALL 
        SELECT 1219, 'valuationbulksummary', 'Valuation', 'home.uploads.valuationbulksummary', '-function',1217, NULL,NULL,1 UNION ALL 
        SELECT 1220, 'changeplanowner', 'Change Plan Owner', 'plan.actions.changeplanowner', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1221, 'linktoscheme', 'Link To Scheme', 'plan.actions.linktoscheme', '+subaction',601, '/nio/clientscheme/{Id}/linkplantoscheme',NULL,1 UNION ALL 
        SELECT 1222, 'addfundpanel', 'Create Fund Panel', 'adviserworkplace.fundanalysis.addfundpanel', '+subaction',1158, NULL,NULL,2 UNION ALL 
        SELECT 1223, 'opportunities', 'Opportunities', 'adviserworkplace.leads.opportunity', '-function',665, NULL,NULL,1 UNION ALL 
        SELECT 1224, 'relatetoclient', 'Relate To Client', 'fundanalysis.actions.relatetoclient', '+subaction',1158, NULL,NULL,1 UNION ALL 
        SELECT 1225, 'download', 'Download Template', 'adviserworkplace.opportunities.download', '-action',944, NULL,NULL,1 UNION ALL 
        SELECT 1226, 'import', 'Import', 'adviserworkplace.opportunities.import', '-action',944, NULL,NULL,1 UNION ALL 
        SELECT 1227, 'importhistory', 'Import History', 'adviserworkplace.opportunities.importhistory', '-action',944, NULL,NULL,1 UNION ALL 
        SELECT 1228, 'addopportunity', 'Add Opportunity', 'lead.add.addopportunity', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1229, 'auditreport', 'Audit Report', 'mi.auditreport', '-function',1178, NULL,NULL,1 UNION ALL 
        SELECT 1230, 'relatetoportfolio', 'Link to Model Portfolio', 'client.actions.relatetoportfolio', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1231, 'sourcemortgage', 'Source Mortgage', 'client.add.sourcemortgage', '+subaction',575, '/nio/MortgageSourcing/${sysId}/SourceMortgage',NULL,1 UNION ALL 
        SELECT 1232, 'addintroducerlead', 'Introducer Add Lead', 'adviserworkplace.leads.addintroducerlead', '-action',665, NULL,NULL,1 UNION ALL 
        SELECT 1233, 'canfilterbybranch', 'Can Filter By Branch', 'adviserworkplace.leads.canfilterbybranch', '-action',665, NULL,NULL,1 UNION ALL 
        SELECT 1234, 'canfilterbyintroducer', 'Can Filter By Introducer', 'adviserworkplace.leads.canfilterbyintroducer', '-action',665, NULL,NULL,1 UNION ALL 
        SELECT 1235, 'locateadviser', 'Locate Adviser', 'lead.add.locateadviser', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1237, 'factfind', 'Fact Find', 'administration.organisation.factfind', '-function',508, NULL,NULL,1 UNION ALL 
        SELECT 1238, 'activityhistory', '15. Activity History', 'adviserworkplace.clients.plans.activityhistory', '-liogroup',336, NULL,NULL,2 UNION ALL 
        SELECT 1239, 'addtasknotes', 'Add a Task Note', 'task.actions.addtasknotes', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1240, 'relatetoentity', 'Relate To Entity', 'task.actions.relatetoentity', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1249, 'messages', 'Messages', 'toplevelnavigation.messages', '-action',891, NULL,NULL,1 UNION ALL 
        SELECT 1250, 'submitapplication', 'Submit Application', 'plan.actions.submitapplication', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1251, 'docstoremanagement', 'Document Store', 'administration.applicationsupport.docstore', '-function',553, '',NULL,1 UNION ALL 
        SELECT 1254, 'switchrequest', 'Switch Request', 'plan.actions.switchrequest', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1256, 'createsecuremessage', 'Create Secure Message', 'client.add.createsecuremessage', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1257, 'securemessage', 'Secure Messaging', 'adviserworkplace.communication.securemessage', '-function',1435, NULL,NULL,1 UNION ALL 
        SELECT 1261, 'fundproposal', 'Add/Edit Fund Proposal', 'plan.actions.fundproposal', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1262, 'advisercharging', 'Adviser Charging', 'administration.organisation.advisercharging', '-function',508, NULL,NULL,1 UNION ALL 
        SELECT 1263, 'addfeenotes', 'Add Fee Note', 'fee.actions.addfeenotes', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1264, 'relatetofee', 'Link To Fee', 'plan.actions.relatetofee', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1265, 'securityoptions', 'Security Options', 'template.actions.securityoptions', '+subaction',1203, NULL,NULL,1 UNION ALL 
        SELECT 1266, 'addtask', 'Add Task', 'advicecase.add.addtask', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1267, 'factfindpreference', 'Fact Find Preference', 'mysetup.factfindpreference', '-system',788, NULL,NULL,1 UNION ALL 
        SELECT 1268, 'factfindsettings', 'Fact Find Settings', 'group.actions.factfindsettings', '+subaction',645, NULL,NULL,1 UNION ALL 
        SELECT 1269, 'createfeetemplate', 'Create Fee Template', 'administration.organisation.advisercharging.feetemplate', '+subaction',650, NULL,NULL,1 UNION ALL 
        SELECT 1270, 'retainertemplate', 'Retainer Template', 'administration.organisation.advisercharging.retainertemplate', '+subaction',650, NULL,NULL,1 UNION ALL 
        SELECT 1271, 'addfee', 'Add Fee', 'advicecase.add.addfee', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1272, 'scheduler', 'Scheduler', 'administration.applicationsupport.scheduler', '-liogroup',553, NULL,NULL,2 UNION ALL 
        SELECT 1273, 'navigatetothirdpartyportal', 'Navigate to Third Party Portal', 'plan.actions.navigatetothirdpartyportal', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1274, 'download', 'Download Template', 'organiser.diary.download', '-action',977, NULL,NULL,1 UNION ALL 
        SELECT 1275, 'import', 'Import', 'organiser.diary.import', '-action',977, NULL,NULL,1 UNION ALL 
        SELECT 1276, 'importhistory', 'Import History', 'organiser.diary.importhistory', '-action',977, NULL,NULL,1 UNION ALL 
        SELECT 1277, 'targetperiods', 'Targets', 'commissions.advisers.targetperiods', '-action',424, NULL,NULL,1 UNION ALL 
        SELECT 1278, 'groupreferencedata', 'Group Reference Data', 'administration.groupreferencedata.grouptasks', '-system',494, NULL,NULL,1 UNION ALL 
        SELECT 1279, 'grouptasks', 'Group Tasks', 'administration.groupreferencedata.grouptasks', '-function',1278, NULL,NULL,1 UNION ALL 
        SELECT 1280, 'groupcharging', 'Group Charging', 'administration.groupreferencedata.groupcharging', '-function',1278, NULL,NULL,1 UNION ALL 
        SELECT 1281, 'leads', 'Leads', 'administration.organisation.leadadmin', '-function',508, NULL,NULL,1 UNION ALL 
        SELECT 1282, 'groupsecurity', 'Security', 'administration.groupreferencedata.groupsecurity', '-function',1278, NULL,NULL,1 UNION ALL 
        SELECT 1283, 'addeventlist', 'Add Event List', 'advicecase.add.addeventlist', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1284, 'groupreferencedataactions', 'Group Reference Data', 'groupreferencedata', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1285, 'actions', 'Actions:', 'groupreferencedata.actions', '+action',1284, NULL,NULL,1 UNION ALL 
        SELECT 1286, 'groupchargingcreatefeetemplate', 'Create Fee Template', 'administration.groupreferencedata.groupcharging.feetemplate', '+subaction',1285, NULL,NULL,1 UNION ALL 
        SELECT 1287, 'addmanualexpectation', 'Add Manual Expectation', 'plan.actions.addmanualexpectation', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1288, 'addfeetoplan', 'Add Fee', 'plan.actions.addfee', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1293, 'defereditems', 'Deferred Items', 'commissions.cashreceipts.deferreditems', '-action',397, NULL,NULL,1 UNION ALL 
        SELECT 1294, 'deletelead', 'Delete Lead', 'lead.add.deletelead', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1295, 'fileimportsearch', 'File Import Search', 'home.uploads.fileimportsearch', '-function',1217, NULL,NULL,1 UNION ALL 
        SELECT 1296, 'byipwhitelist', 'By IP Address', 'administration.security.byipwhitelist', '-function',516, '',NULL,1 UNION ALL 
        SELECT 1297, 'shareclient', 'Share Client', 'client.add.shareclient', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1298, 'addfeetotask', 'Add Fee', 'task.actions.addfee', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1299, 'linkbinders', 'Link Binders', 'opportunity.add.linkbinders', '+subaction',819, NULL,NULL,1 UNION ALL 
        SELECT 1300, 'startactivation', 'Start Activation', 'user.actions.startactivation', '+subaction',636, NULL,NULL,1 UNION ALL 
        SELECT 1301, 'presalesearch', 'Pre Search', 'compliance.filechecking.presalesearch', '-function',446, NULL,NULL,1 UNION ALL 
        SELECT 1302, 'planlinktasks', 'Link Tasks', 'plan.actions.linktasks', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1303, 'linktasks', 'Link Tasks', 'advicecase.add.linktasks', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1305, 'startnewfpsession', 'Start New Financial Planning Session', 'client.actions.startnewfpsession', '+subaction',575, NULL,NULL,2 UNION ALL 
        SELECT 1306, 'addeditlifeassured', 'Add/Edit Life Assured', 'plan.actions.addeditlifeassured', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1307, 'datauploader', 'Data Uploader', 'home.uploads.datauploader', '-function',1217, NULL,NULL,1 UNION ALL 
        SELECT 1308, 'downloadtemplate', 'Download Template', 'home.uploads.datauploader.downloadtemplate', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1309, 'importcompletedtemplate', 'Import Completed Template', 'home.uploads.datauploader.importcompletedtemplate', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1310, 'clientservicestatus', 'Client Service Status', 'home.uploads.datauploader.clientservicestatus', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1311, 'adviserbanding', 'Adviser Banding', 'home.uploads.datauploader.adviserbanding', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1312, 'adviserparaplannercharge', 'Adviser Paraplanner Charge', 'home.uploads.datauploader.adviserparaplannercharge', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1313, 'adviseragencynumbers', 'Adviser Agency Numbers', 'home.uploads.datauploader.adviseragencynumbers', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1314, 'changeplanstatusupload', 'Change Plan Status', 'home.uploads.datauploader.changeplanstatusupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1315, 'clientfeefromfeemodelupload', 'Insert Client Fee from Fee Model', 'home.uploads.datauploader.clientfeefromfeemodelupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1316, 'planexpectedcommissionupload', 'Insert Plan Expected Commission', 'home.uploads.datauploader.planexpectedcommissionupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1317, 'planpremiumdetailsupload', 'Insert Plan Premiums / Contributions', 'home.uploads.datauploader.planpremiumdetailsupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1318, 'clientdetailsupload', 'Update Client Details', 'home.uploads.datauploader.clientdetailsupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1319, 'groupschemememberdetailsupload', 'Update Group Scheme Member Plan Details', 'home.uploads.datauploader.groupschemememberdetailsupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1320, 'updateplandetailsupload', 'Update Plan Details', 'home.uploads.datauploader.updateplandetailsupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1321, 'importgroupschememember', 'Import Group Scheme Member', 'home.uploads.datauploader.importgroupschememember', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1322, 'outstandingbusiness', 'Outstanding Business', 'adviserworkplace.sales.outstandingbusiness', '-function',372, '',NULL,1 UNION ALL 
        SELECT 1323, 'deletefolder', 'Delete Folder', 'folders.add.deletefolder', '+subaction',657, '',NULL,1 UNION ALL 
        SELECT 1324, 'reviewotherservicecase', 'Review Other Service Case', 'advicecase.add.reviewotherservicecase', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1325, 'importtask', 'Import Task', 'home.uploads.datauploader.importtask', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1326, 'clienteditthirdpartyref', 'Change 3rd Party Ref', 'client.actions.editthirdpartyref', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1327, 'leadeditthirdpartyref', 'Edit 3rd Party Ref', 'lead.actions.editthirdpartyref', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1328, 'updatehistoricfees', 'Update Historic Fees', 'home.uploads.datauploader.updatehistoricfees', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1333, 'quotes', 'Quotes', 'adviserworkplace.leads.quotes', '-function',665, NULL,NULL,1 UNION ALL 
        SELECT 1334, 'getnewquote', 'Get New Quote', 'lead.add.getnewquote', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1335, 'leadquotedetail', 'Lead Quote Detail', 'leadquotedetail', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1336, 'actions', 'Actions', 'leadquotedetail.actions', '+action',1335, NULL,NULL,1 UNION ALL 
        SELECT 1337, 'fullquotationanalysis', 'Full Quotation Analysis', 'leadquotedetail.actions.fullquotationanalysis', '+subaction',1336, NULL,NULL,1 UNION ALL 
        SELECT 1338, 'uploadquotationdocument', 'Upload Document', 'leadquotedetail.actions.uploadquotationdocument', '+subaction',1336, NULL,NULL,1 UNION ALL 
        SELECT 1339, 'addleadsimport', 'Import Leads', 'home.uploads.datauploader.addleadsimport', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1340, 'addsplittemplategroup', 'Add Split Template Group', 'fee.actions.addsplittemplategroup', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1341, 'multitieadviserbulkupload', 'Multi Tie Adviser Bulk Upload', 'home.uploads.datauploader.multitieadviserbulkupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1342, 'clientfactfind', 'Fact Find', 'adviserworkplace.clients.factfind', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 1343, 'exportclientdata', 'Export Client Data', 'client.add.exportclientdata', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1344, 'addeditsolicitor', 'Add/Edit Solicitor', 'plan.actions.addeditsolicitor', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1345, 'dashboardsconfigure', 'Configure', 'home.dashboard.configure', '-function',1210, NULL,NULL,1 UNION ALL 
        SELECT 1346, 'action', 'Action', 'creditnote.actions', '+action',599, NULL,NULL,1 UNION ALL 
        SELECT 1347, 'deletecreditnote', 'Delete Credit Note', 'creditnote.actions.deletecreditnote', '+subaction',1346, NULL,NULL,1 UNION ALL 
        SELECT 1348, 'reinstate', 'Reinstate', 'fee.actions.reinstate', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1350, 'addappointment', 'Add Appointment', 'client.add.addappointment', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1351, 'addappointment', 'Add Appointment', 'lead.add.addappointment', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1352, 'valuationdownloadtemplate', 'Download Template', 'home.uploads.valuationdownloadtemplate', '-action',1217, NULL,NULL,1 UNION ALL 
        SELECT 1353, 'incomematchingconfiguration', 'Income Matching Configuration', 'commissions.administration.incomematchingconfiguration', '-function',431, NULL,NULL,1 UNION ALL 
        SELECT 1354, 'automatchingconfiguration', 'Auto-Matching Configuration', 'commissions.administration.incomematchingconfiguration.automatchingconfiguration', '-liogroup',1353, NULL,NULL,1 UNION ALL 
        SELECT 1355, 'planallocationandfeelinkingconfiguration', 'Plan Allocation & Fee Linking Configuration', 'commissions.administration.incomematchingconfiguration.planallocationandfeelinkingconfiguration', '-liogroup',1353, NULL,NULL,1 UNION ALL 
        SELECT 1356, 'feetoleranceconfiguration', 'Fee Tolerance Configuration', 'commissions.administration.incomematchingconfiguration.feetoleranceconfiguration', '-liogroup',1353, NULL,NULL,1 UNION ALL 
        SELECT 1357, 'updatefeestatus', 'Update Fee Status', 'home.uploads.datauploader.updatefeestatus', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1358, 'ignoreinreports', 'Ignore In Reports', 'fee.actions.ignoreinreports', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1359, 'linkopportunities', 'Link Opportunity', 'advicecase.add.linkopportunities', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1360, 'linkclientdocuments', 'Link Client Documents', 'advicecase.add.linkclientdocuments', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1361, 'planning', 'Advice', 'adviserworkplace.clients.planning', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 1362, 'researchtools', 'Research Tools', 'adviserworkplace.clients.planning.researchtools', '-function',1361, NULL,NULL,1 UNION ALL 
        SELECT 1363, 'riskprofiler', 'Risk Profiler', 'adviserworkplace.clients.planning.researchtools.riskprofiler', '-widget',1362, NULL,NULL,1 UNION ALL 
        SELECT 1364, 'quicktools', 'Quick Tools (Investment & Retirement Planner)', 'adviserworkplace.clients.planning.researchtools.quicktools', '-widget',1362, NULL,NULL,1 UNION ALL 
        SELECT 1365, 'portfolioanalyser', 'Portfolio Analyser', 'adviserworkplace.clients.planning.researchtools.portfolioanalyser', '-widget',1362, NULL,NULL,1 UNION ALL 
        SELECT 1366, 'lifetimeplanner', 'Lifetime Planner', 'adviserworkplace.clients.planning.researchtools.lifetimeplanner', '-widget',1362, NULL,NULL,1 UNION ALL 
        SELECT 1367, 'recommendations', 'Recommendations', 'adviserworkplace.clients.planning.recommendations', '-function',1361, NULL,NULL,1 UNION ALL 
        SELECT 1368, 'summary', 'Summary', 'adviserworkplace.clients.planning.summary', '-function',1361, NULL,NULL,1 UNION ALL 
        SELECT 1369, 'changefeesellingadviser', 'Change Selling Adviser', 'fee.actions.amendfeesellingadviser', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1370, 'documentdesigner', 'Document Designer', 'administration.documentdesigner', '-system',494, NULL,NULL,1 UNION ALL 
        SELECT 1371, 'templates', 'Templates', 'administration.documentdesigner.templates', '-function',1370, NULL,NULL,1 UNION ALL 
        SELECT 1372, 'templates', 'Templates', 'administration.documentdesigner.templates.templates', '-liogroup',1371, NULL,NULL,1 UNION ALL 
        SELECT 1373, 'templatecategory', 'Template Category', 'administration.documentdesigner.templates.templatecategories', '-liogroup',1371, NULL,NULL,1 UNION ALL 
        SELECT 1374, 'snippets', 'Snippets', 'administration.documentdesigner.subtemplates', '-function',1370, NULL,NULL,2 UNION ALL 
        SELECT 1375, 'snippets', 'Snippets', 'administration.documentdesigner.subtemplates.templates', '-liogroup',1374, NULL,NULL,2 UNION ALL 
        SELECT 1376, 'subtemplatecategory', 'Template Category', 'administration.documentdesigner.subtemplates.templatecategories', '-liogroup',1374, NULL,NULL,1 UNION ALL 
        SELECT 1377, 'recommendationactions', 'Recommendations', 'recommendationactions', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1378, 'add', 'Actions:', 'recommendationactions.add', '+action',1377, NULL,NULL,1 UNION ALL 
        SELECT 1379, 'addmanualrecommendations', 'Add Manual Recommendation', 'recommendationactions.add.addmanualrecommendations', '+subaction',1378, NULL,NULL,1 UNION ALL 
        SELECT 1380, 'updaterecommendationstatus', 'Update Recommendation Status', 'recommendationactions.add.updaterecommendationstatus', '+subaction',1378, NULL,NULL,1 UNION ALL 
        SELECT 1381, 'search', 'Search:', 'client.search', '+action',574, NULL,NULL,1 UNION ALL 
        SELECT 1382, 'exportcsv', 'Export CSV', 'client.search.exportcsv', '+subaction',1381, NULL,NULL,1 UNION ALL 
        SELECT 1383, 'exportpdf', 'Export PDF', 'client.search.exportpdf', '+subaction',1381, NULL,NULL,1 UNION ALL 
        SELECT 1384, 'mailmerge', 'Mail Merge', 'client.search.mailmerge', '+subaction',1381, NULL,NULL,1 UNION ALL 
        SELECT 1385, 'search', 'Search:', 'lead.search', '+action',761, NULL,NULL,1 UNION ALL 
        SELECT 1386, 'exportcsv', 'Export CSV', 'lead.search.exportcsv', '+subaction',1385, NULL,NULL,1 UNION ALL 
        SELECT 1387, 'exportpdf', 'Export PDF', 'lead.search.exportpdf', '+subaction',1385, NULL,NULL,1 UNION ALL 
        SELECT 1388, 'mailmerge', 'Mail Merge', 'lead.search.mailmerge', '+subaction',1385, NULL,NULL,1 UNION ALL 
        SELECT 1389, 'documentdesigner', 'Document Designer', 'documentdesigner', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1390, 'actions', 'Actions:', 'documentdesigner.actions', '+action',1389, NULL,NULL,1 UNION ALL 
        SELECT 1391, 'securityoptions', 'Security Options', 'documentdesigner.actions.securityoptions', '+subaction',1390, NULL,NULL,1 UNION ALL 
        SELECT 1392, 'versionoptions', 'Version Options', 'documentdesigner.actions.versionoptions', '+subaction',1390, NULL,NULL,1 UNION ALL 
        SELECT 1393, 'downloadplugin', 'Download Word Plugin', 'documentdesigner.actions.downloadplugin', '+subaction',1390, NULL,NULL,1 UNION ALL 
        SELECT 1394, 'createtemplate', 'Create Template', 'documentdesigner.actions.createtemplate', '+subaction',1390, NULL,NULL,1 UNION ALL 
        SELECT 1395, 'createsnippet', 'Create Snippet', 'documentdesigner.actions.createsubtemplate', '+subaction',1390, NULL,NULL,1 UNION ALL 
        SELECT 1396, 'importaddfee', 'Add Fee', 'home.uploads.datauploader.importaddfee', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1399, 'clientreports', 'Reports', 'adviserworkplace.clients.reports', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 1401, 'importUpdatePlanDetailsInvestmentRetirement', 'Import Update Plan Details Investment Retirement', 'home.uploads.datauploader.importUpdatePlanDetailsInvestmentRetirement', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1402, 'importUpdatePlanDetailsProtection', 'Import Update Plan Details Protection', 'home.uploads.datauploader.importUpdatePlanDetailsProtection', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1403, 'linktasks', 'Link Tasks', 'opportunity.add.linktasks', '+subaction',819, NULL,NULL,1 UNION ALL 
        SELECT 1404, 'bulkpfpclientactivation', 'Bulk Pfp Client Activation', 'home.uploads.datauploader.bulkpfpclientactivation', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1405, 'addplansplittemplate', 'Add Plan Split Template', 'plan.actions.addplansplittemplate', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1406, 'importAddSplitTemplateGroup', 'Import Add Split Template Group', 'home.uploads.datauploader.importAddSplitTemplateGroup', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1407, 'addclientquick', 'Quick Add Client', 'adviserworkplace.clients.addclientquick', '-action',324, NULL,NULL,1 UNION ALL 
        SELECT 1408, 'workflow', 'Workflow', 'administration.workflow', '-system',494, NULL,NULL,1 UNION ALL 
        SELECT 1409, 'templates', 'Templates', 'administration.workflow.templates', '-function',1408, NULL,NULL,1 UNION ALL 
        SELECT 1410, 'templates', 'Templates', 'administration.workflow.templates.templates', '-liogroup',1409, NULL,NULL,1 UNION ALL 
        SELECT 1411, 'templatecategory', 'Template Category', 'administration.workflow.templates.templatecategories', '-liogroup',1409, NULL,NULL,1 UNION ALL 
        SELECT 1412, 'addnewworkflowtemplate', 'Add New Workflow Template', 'administration.workflow.addnewworkflowtemplate', '-action',1408, NULL,NULL,1 UNION ALL 
        SELECT 1413, 'templates', 'Templates', 'administration.workflow.templates.templates', '-liogroup',1409, NULL,NULL,1 UNION ALL 
        SELECT 1414, 'changemigrationref', 'Change Migration Ref', 'group.actions.changemigrationref', '+subaction',645, NULL,NULL,1 UNION ALL 
        SELECT 1415, 'workflow', 'Workflow', 'workflow', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1416, 'actions', 'Actions:', 'workflow.actions', '+action',1415, NULL,NULL,1 UNION ALL 
        SELECT 1417, 'addworkflowstep', 'Add Step', 'workflow.actions.addworkflowstep', '+subaction',1416, NULL,NULL,1 UNION ALL 
        SELECT 1418, 'changemigrationref', 'Change Migration Ref', 'adviser.actions.changemigrationref', '+subaction',832, NULL,NULL,1 UNION ALL 
        SELECT 1419, 'markaspaid', 'Mark as Paid', 'fee.actions.markaspaid', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1420, 'addworkflow', 'Add Workflow', 'client.add.addworkflow', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1421, 'addworkflow', 'Add Workflow', 'lead.add.addworkflow', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1422, 'addworkflow', 'Add Workflow', 'advicecase.add.addworkflow', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1423, 'addworkflow', 'Add Workflow', 'adviser.actions.addworkflow', '+subaction',832, NULL,NULL,1 UNION ALL 
        SELECT 1424, 'addworkflow', 'Add Workflow', 'plan.actions.addworkflow', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1425, 'endworkflow', 'End Workflow', 'client.add.abortworkflow', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1426, 'endworkflow', 'End Workflow', 'lead.add.abortworkflow', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1427, 'endworkflow', 'End Workflow', 'advicecase.add.abortworkflow', '+subaction',926, NULL,NULL,1 UNION ALL 
        SELECT 1428, 'endworkflow', 'End Workflow', 'adviser.actions.abortworkflow', '+subaction',832, NULL,NULL,1 UNION ALL 
        SELECT 1429, 'endworkflow', 'End Workflow', 'plan.actions.abortworkflow', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1430, 'changestatus', 'Change Status', 'workflow.actions.changestatus', '+subaction',1416, NULL,NULL,1 UNION ALL 
        SELECT 1431, 'productrisksetup', 'Import Product Risk Setup', 'home.uploads.datauploader.productrisksetup', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1432, 'adviserrisksetup', 'Import Adviser Risk Setup', 'home.uploads.datauploader.adviserrisksetup', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1433, 'adviserriskrating', 'Import Adviser Risk Rating', 'home.uploads.datauploader.adviserriskrating', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1435, 'communication', 'Communication', 'adviserworkplace.communication', '-system',323, NULL,NULL,1 UNION ALL 
        SELECT 1436, 'marketing', 'Marketing', 'adviserworkplace.communication.marketing', '-function',1435, NULL,NULL,1 UNION ALL 
        SELECT 1437, 'marketing', 'Marketing', 'marketing', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1438, 'actions', 'Actions', 'marketing.actions', '+action',1437, NULL,NULL,1 UNION ALL 
        SELECT 1439, 'createtemplate', 'Create Email Template', 'marketing.actions.createtemplate', '+subaction',1438, NULL,NULL,1 UNION ALL 
        SELECT 1440, 'createmarketing', 'Create Email Campaign', 'marketing.actions.createmarketing', '+subaction',1438, NULL,NULL,1 UNION ALL 
        SELECT 1441, 'updateschememember', 'Update Scheme Member', 'home.uploads.datauploader.updateschememember', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1442, 'protectionplanner', 'Protection Planner', 'adviserworkplace.clients.planning.researchtools.protectionplanner', '-widget',1362, NULL,NULL,1 UNION ALL 
        SELECT 1443, 'getnewquote', 'Get New Quote', 'adviserworkplace.clients.planning.researchtools.getnewquote', '-widget',1362, NULL,NULL,1 UNION ALL 
        SELECT 1444, 'lists', 'Lists', 'adviserworkplace.communication.lists', '-function',1435, NULL,NULL,1 UNION ALL 
        SELECT 1445, 'pfp', 'PFP', 'adviserworkplace.clients.pfp', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 1446, 'createpfptemplate', 'Create PFP Template', 'marketing.actions.createpfptemplate', '+subaction',1438, NULL,NULL,1 UNION ALL 
        SELECT 1447, 'createpfpmarketing', 'Create PFP Campaign', 'marketing.actions.createpfpmarketing', '+subaction',1438, NULL,NULL,1 UNION ALL 
        SELECT 1448, 'UpdateServicingAdviserAndSplits', 'Update Servicing Adviser and Splits', 'home.uploads.datauploader.updateservicingadviserandsplits', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1449, 'pensionfreedomplanner', 'Pension Freedom Planner', 'adviserworkplace.clients.planning.researchtools.pensionfreedomplanner', '-widget',1362, NULL,NULL,1 UNION ALL 
        SELECT 1450, 'insertplanwithdrawals', 'Insert Plan Withdrawals', 'home.uploads.datauploader.insertplanwithdrawals', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1451, 'lifecycledesigner', 'Life Cycle Designer', 'compliance.administration.lifecycle.lifecycledesigner', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1452, 'actions', 'Actions:', 'compliance.administration.lifecycle.lifecycledesigner.actions', '+action',1451, NULL,NULL,1 UNION ALL 
        SELECT 1453, 'lifecyclereport', 'Life Cycle Report', 'compliance.administration.lifecycle.lifecycledesigner.actions.lifecyclereport', '+subaction',1452, NULL,NULL,1 UNION ALL 
        SELECT 1454, 'incomestatementschedule', 'Income Statement Schedule', 'administration.automation.incomestatementschedule', '-function',901, NULL,NULL,1 UNION ALL 
        SELECT 1455, 'addplans', 'Add Plans', 'home.uploads.datauploader.addplans', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1456, 'composeemail', 'Compose Email', 'client.add.composeemail', '+subaction',575, '/nio/ComposeEmail/${sysId}/ComposeEmail',NULL,1 UNION ALL 
        SELECT 1457, 'ClientPreferences', 'Update Client Preferences', 'home.uploads.datauploader.clientpreferencesupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1458, 'communication', 'Communication', 'administration.communication', '-system',494, NULL,NULL,1 UNION ALL 
        SELECT 1459, 'email', 'Email', 'administration.communication.email', '-function',1458, NULL,NULL,1 UNION ALL 
        SELECT 1460, 'orphancalls', 'Orphan Calls', 'organiser.tasks.orphancalls', '-function',972, '/organiser/tasks/orphancalls',NULL,1 UNION ALL 
        SELECT 1461, 'mytime', 'My Time', 'organiser.mytime', '-system',970, '/organiser/mytime',NULL,1 UNION ALL 
        SELECT 1462, 'timesheet', 'Timesheet', 'organiser.mytime.timesheet', '-function',1461, '/organiser/mytime/timesheet',NULL,1 UNION ALL 
        SELECT 1463, 'addtime', 'Add Time', 'organiser.mytime.actions.addtime', '-action',1461, NULL,NULL,1 UNION ALL 
        SELECT 1464, 'changeplantypeupload', 'Change Plan Type', 'home.uploads.datauploader.changeplantypeupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1465, 'clientmergeupload', 'Client Merge', 'home.uploads.datauploader.clientmergeupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1466, 'editrecurrence', 'Edit Recurrence', 'task.actions.editrecurrence', '+subaction',608, 'dialog:/organiser/tasks/editrecurrence.asp',NULL,1 UNION ALL 
        SELECT 1467, 'editbillingrate', 'Edit Billing Rate', 'task.actions.editbillingrate', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1468, 'addbeneficiary', 'Add Beneficiary', 'plan.actions.addbeneficiary', '+subaction',601, 'dialog:/PlanManagement/ManagePlans/AddBeneficiary/addbeneficiary.asp',NULL,1 UNION ALL 
        SELECT 1469, 'alluserdelegation', 'Delegation - All Users', 'administration.applicationsupport.alluserdelegation', '-action',553, NULL,NULL,1 UNION ALL 
        SELECT 1470, 'supportuserdelegation', 'Delegation - Support Users', 'administration.applicationsupport.supportuserdelegation', '-action',553, NULL,NULL,1 UNION ALL 
        SELECT 1471, 'categorisefund', 'Categorise Funds', 'home.uploads.datauploader.categorisefund', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1473, 'addadviseradjustments', 'Add Adviser Adjustments', 'home.uploads.datauploader.addadviseradjustments', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1474, 'deleteopportunity', 'Delete Opportunity', 'opportunity.add.deleteopportunity', '+subaction',819, NULL,NULL,1 UNION ALL 
        SELECT 1476, 'deletetask', 'Delete Task', 'task.actions.deletetask', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1477, 'mortgagesummaryview', 'Mortgage Summary View', 'plan.actions.mortgagesummaryview', '+subaction',601, 'dialog:/PlanManagement/ManagePlans/SummaryView/mortgagesummaryview.asp',NULL,1 UNION ALL 
        SELECT 1479, 'corporatetrustclientdetailsupload', 'Update Corporate / Trust Client Details', 'home.uploads.datauploader.corporatetrustclientdetailsupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1480, 'updateclientrelationshipsupload', 'Update Client Relationships', 'home.uploads.datauploader.updateclientrelationshipsupload', '-action',1307, NULL,NULL,1 UNION ALL 
        SELECT 1481, 'modifytasknotes', 'Modify a Task Note', 'task.actions.modifytasknotes', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1482, 'pfpadministration', 'PFP Administration', 'pfpadministration', '-application',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1483, 'support', 'Support', 'toplevelnavigation.support', '-action',891, 'openWindow(''/administration/applicationsupport/helpdesk.asp'', ''support'', 200, 500, false, false, false, false);',NULL,1 UNION ALL 
        SELECT 1484, 'help', 'Help', 'toplevelnavigation.help', '-action',891, 'openWindow(''/documents/help/new/default.htm'',''help'',600,900,true,true,true,false);',NULL,1 UNION ALL 
        SELECT 1485, 'createplan', 'Create Plan', 'opportunity.add.createplan', '+subaction',819, 'dialog_status:/PlanManagement/ManagePlans/AddPlan/addPlan.asp?type=mortgage',NULL,1 UNION ALL 
        SELECT 1486, 'pdf', 'Open As PDF', 'client.generate.pdf', '+subaction',587, '',NULL,1 UNION ALL 
        SELECT 1487, 'lifecycledesigner', 'Lifecycle Designer', 'compliance.administration.lifecycledesigner', '-action',478, '/PlanManagement/ManagePlans/Lifecycle/lifecycle.asp',NULL,1 UNION ALL 
        SELECT 1488, 'linktoadvice', 'Link to Service', 'casefile.actions.linktoadvice', '+subaction',793, 'dialog:/clientmanagement/contacts/advicecases/advicecases.asp',NULL,1 UNION ALL 
        SELECT 1489, 'exporttoobp', 'Export To OBP', 'client.add.exporttoobp', '+subaction',575, '/nio/ExportToOBP/${sysId}/ExportClientData',NULL,1 UNION ALL 
        SELECT 1490, 'pfpadministration', 'PFP', 'administration.organisation.pfp', '-function',508, NULL,NULL,1 UNION ALL 
        SELECT 1491, 'pfp', 'PFP Client Activation', 'adviserworkplace.clients.pfp', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 1492, 'assigntouser', 'Manage User Licences', 'administration.organisation.pfp.licencemanagement.assigntouser', '-action',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1493, 'allocatetogroup', 'Manage Group Licences', 'administration.organisation.pfp.licencemanagement.allocatetogroup', '-action',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1494, 'fundproposal', 'Fund Proposal', 'plan.actions.fundproposal', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1495, 'pfpmanagedocuments', 'Manage Documents', 'administration.organisation.pfp.licencemanagement.managedocuments', '-action',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1496, 'pfplicencemanagement', 'Licence Management', 'administration.organisation.pfp.licencemanagement', '-group',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1497, 'pfpsettings', 'Settings', 'administration.organisation.pfp.settings', '-group',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1498, 'pfplicencemanagement', 'PFP', 'administration.organisation.pfplicencemanagement', '-function',508, NULL,NULL,1 UNION ALL 
        SELECT 1499, 'pfpintegrations', 'Integrations', 'administration.organisation.pfp.integrations', '-group',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1500, 'pfpcorporate', 'PFP Corporate Client', 'adviserworkplace.clients.pfpcorporate', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 1501, 'themes', 'PFP Corporate Client Themes', 'adviserworkplace.clients.pfpcorporate.themes', '-group',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1502, 'createtemplate', 'Create Template', 'marketing.actions.createtemplate', '+subaction',1438, NULL,NULL,1 UNION ALL 
        SELECT 1503, 'createmarketing', 'Create Marketing', 'marketing.actions.createmarketing', '+subaction',1438, NULL,NULL,1 UNION ALL 
        SELECT 1504, 'modifyfeenotes', 'Modify a Fee Note', 'fee.actions.modifyfeenotes', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1505, 'modifyownfeenotes', 'Modify Own Fee Note', 'fee.actions.modifyownfeenotes', '+subaction',589, NULL,NULL,1 UNION ALL 
        SELECT 1506, 'modifyownclientnotes', 'Modify Own Client Note', 'client.add.modifyownclientnotes', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1507, 'modifyclientnotes', 'Modify a Client Note', 'client.add.modifyclientnotes', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1508, 'modifyowntasknotes', 'Modify Own Task Note', 'task.actions.modifyowntasknotes', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1509, 'modifyschemenotes', 'Modify a Scheme Note', 'scheme.actions.modifyschemenotes', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1510, 'modifyownschemenotes', 'Modify Own Scheme Note', 'scheme.actions.modifyownschemenotes', '+subaction',1167, NULL,NULL,1 UNION ALL 
        SELECT 1511, 'modifyopportunitynotes', 'Modify an Opportunity Note', 'opportunity.add.modifyopportunitynotes', '+subaction',819, NULL,NULL,1 UNION ALL 
        SELECT 1512, 'modifyownopportunitynotes', 'Modify Own Opportunity Note', 'opportunity.add.modifyownopportunitynotes', '+subaction',819, NULL,NULL,1 UNION ALL 
        SELECT 1513, 'modifyleadnotes', 'Modify a Lead Note', 'lead.add.modifyleadnotes', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1514, 'modifyownleadnotes', 'Modify Own Lead Note', 'lead.add.modifyownleadnotes', '+subaction',667, NULL,NULL,1 UNION ALL 
        SELECT 1515, 'modifyownplannotes', 'Modify Own Plan Note', 'plan.actions.modifyownplannotes', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1516, 'modifyplannotes', 'Modify a Plan Note', 'plan.actions.modifyplannotes', '+subaction',601, NULL,NULL,1 UNION ALL 
        SELECT 1517, 'callrecording', 'Call Recording', 'callrecording', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1518, 'actions', 'Actions:', 'callrecording.actions', '+action',1517, NULL,NULL,1 UNION ALL 
        SELECT 1519, 'deletecallrecording', 'Delete Call Recording', 'callrecording.actions.deletecallrecording', '+subaction',1518, NULL,NULL,1 UNION ALL 
        SELECT 1520, 'restrictedclientaccess', 'Restricted Client Access', 'adviserworkplace.clients.restrictedclientaccess', '-function',324, NULL,NULL,1 UNION ALL 
        SELECT 1521, 'deleteclient', 'Delete Client', 'client.add.deleteclient', '+subaction',575, NULL,NULL,1 UNION ALL 
        SELECT 1522, 'deleterecommendation', 'Delete Recommendation', 'recommendationactions.add.deleterecommendation', '+subaction',1378, NULL,NULL,1 UNION ALL 
        SELECT 1526, 'getnewillustration', 'Get New Illustration', 'client.add.getnewillustration', '+subaction',575, 'dialog_status:/quotes/getnewExWebquote.asp',NULL,1 UNION ALL 
        SELECT 1529, 'email', 'Email', 'Email', '+entity',NULL, '',NULL,1 UNION ALL 
        SELECT 1530, 'actions', 'Actions:', 'email.actions', '+action',1529, '',NULL,1 UNION ALL 
        SELECT 1531, 'fundanalysis', 'Fund Analysis', 'adviserworkplace.fundanalysis.fundanalysis', '-system',1150, NULL,NULL,1 UNION ALL 
        SELECT 1532, 'fundpanel', 'Fund Panel', 'adviserworkplace.fundanalysis.fundpanel', '-system',1150, NULL,NULL,1 UNION ALL 
        SELECT 1533, 'modelportfolio', 'Model Portfolio', 'adviserworkplace.fundanalysis.modelportfolio', '-system',1150, NULL,NULL,1 UNION ALL 
        SELECT 1534, 'rebalance', 'Rebalance', 'adviserworkplace.fundanalysis.rebalance', '-system',1150, NULL,NULL,1 UNION ALL 
        SELECT 1535, 'deletecontact', 'Delete Client', 'client.add.deletecontact', '+subaction',575, 'dialog_status:/clientmanagement/contacts/managecontacts/deletecontact.asp',NULL,1 UNION ALL 
        SELECT 1536, 'deleteemail', 'Delete Email', 'task.actions.deleteemail', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1537, 'addemaillink', 'Add Link', 'task.actions.addemaillink', '+subaction',608, NULL,NULL,1 UNION ALL 
        SELECT 1538, 'editemailsubject', 'Edit Email Subject', 'email.actions.editsubject', '+subaction',1530, NULL,NULL,1 UNION ALL 
        SELECT 1539, 'orphanemails', 'Orphan Emails', 'organiser.tasks.orphanemails', '-function',972, '/organiser/tasks/orphanemails',NULL,1 UNION ALL 
        SELECT 1540, 'expectation', 'Expectation', 'expectation', '+entity',NULL, NULL,NULL,1 UNION ALL 
        SELECT 1541, 'actions', 'Actions', 'expectation.actions', '+action',1540, NULL,NULL,1 UNION ALL 
        SELECT 1542, 'adjustexpectation', 'Adjust expectation', 'expectation.actions.adjustexpectation', '+subaction',1541, NULL,NULL,1 UNION ALL 
        SELECT 1543, 'autoadjustments', 'Auto Adjustments', 'commissions.administration.autoadjustments', '-function',431, NULL,NULL,1 UNION ALL 
        SELECT 1544, 'editautoadjustmentrule', 'Edit Auto Adjustment Rules', 'expectation.actions.editautoadjustmentrules', '+subaction',1541, NULL,NULL,1 UNION ALL 
        SELECT 1545, 'ageddebt', 'Aged Debt', 'aged.debt', '-system',380, NULL,NULL,1 UNION ALL 
        SELECT 1546, 'advice', 'Advice', 'compliance.administration.advice', '-function',478, '',NULL,1 UNION ALL 
        SELECT 1547, 'expectations', 'Expectations', 'adviserworkplace.clients.expectations', '-function',324, NULL,NULL,1 
 
        SET IDENTITY_INSERT TSystem OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F2F613D0-BFE3-487A-8747-D7C2903702F6', 
         'Initial load (994 total rows, file 1 of 1) for table TSystem',
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
-- #Rows Exported: 994
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
