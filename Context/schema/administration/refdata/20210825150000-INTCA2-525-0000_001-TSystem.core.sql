USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '7CA53AB0-BB8A-47FB-AD55-8C90B8698C8C',
    @Comments = 'INTCA2-525 Add missing System Paths'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Add missing System Paths to TSystem
--   Update SystemType from '-liogroup' to '-view'  in TSystem
--   Add new System Paths for license types
--   Update TRefLicenseTypeToSystem

-- Expected row counts: ~ 10000 row(s) affected
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

            -- BEGIN DATA INSERT/UPDATE/DELETE

                -- DELETE duplicated SystemTypes for licenses

                DECLARE @CurrentDateTime datetime = GETUTCDATE()
                DECLARE @StampUser int = 0

                DECLARE @SystemIdsTmp TABLE (SystemId int, ParentId int)

                DELETE FROM TRefLicenseTypeToSystem
                OUTPUT deleted.RefLicenseTypeId, deleted.SystemId, 1, deleted.RefLicenseTypeToSystemId, 'D', @CurrentDateTime, @StampUser
                INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
                WHERE RefLicenseTypeToSystemId NOT IN
                (
                    SELECT MIN(RefLicenseTypeToSystemId)
                    FROM TRefLicenseTypeToSystem
                    GROUP BY RefLicenseTypeId,
                             SystemId
                );

                -- CHANGE SystemType for liogroup

                UPDATE TSystem
                SET SystemType = '-view', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemType = '-liogroup' AND SystemPath NOT IN (
                    'adviserworkplace.accounts.details.summary',
                    'adviserworkplace.clients.details.summary',
                    'adviserworkplace.clients.documents.documents',
                    'adviserworkplace.clients.fees.details',
                    'adviserworkplace.clients.plans.summary',
                    'adviserworkplace.leads.details.summary',
                    'adviserworkplace.leads.documents.documents',
                    'adviserworkplace.sales.incomeearned.selectincomeearned',
                    'adviserworkplace.clients.scheme.basicDetails'
                )

                -- ADD new SystemPaths to TSystem & assigned those to all licenses

                INSERT INTO TSystem (Identifier, Description, SystemPath, SystemType, ParentId, Url, ConcurrencyId)
                OUTPUT inserted.SystemId, inserted.ParentId
                INTO @SystemIdsTmp (SystemId, ParentId)
                VALUES 
                       ('contractenquiry', 'Contract Enquiry', 'mysetup.portals.contractenquiry', '-view', 790, NULL, 1),
                       -- Adwiser Workplace -> Accounts -> Details
                       ('personal', 'Personal', 'adviserworkplace.accounts.details.personal', '-view', 1182, NULL, 1),
                       ('company', 'Company', 'adviserworkplace.accounts.details.company', '-view', 1182, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Activities
                       ('activityhistory', 'Activity History', 'adviserworkplace.clients.tasks.activityhistory', '-liogroup', 361, NULL, 1),
                       ('emails', 'Emails', 'adviserworkplace.clients.tasks.emails', '-view', 361, NULL, 1),
                       ('timehistory', 'Time History', 'adviserworkplace.clients.tasks.timehistory', '-view', 361, NULL, 1),
                       ('tasksandappts', 'Tasks & Appts', 'adviserworkplace.clients.tasks.tasksandappts', '-view', 361, NULL, 1),
                       ('calls', 'Calls', 'adviserworkplace.clients.tasks.calls', '-view', 361, NULL, 1),
                       ('workflows', 'Workflows', 'adviserworkplace.clients.tasks.workflows', '-view', 361, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Details
                       ('bankac', 'Bank a/c', 'adviserworkplace.clients.details.bankac', '-view', 325, NULL, 1),
                       ('clientsharing', 'Client Sharing', 'adviserworkplace.clients.details.clientsharing', '-view', 325, NULL, 1),
                       ('dpa', 'DPA', 'adviserworkplace.clients.details.dpa', '-view', 325, NULL, 1),
                       ('marketing', 'Marketing', 'adviserworkplace.clients.details.marketing', '-view', 325, NULL, 1),
                       ('servicehistory', 'Service History', 'adviserworkplace.clients.details.servicehistory', '-view', 325, NULL, 1),
                       ('id', 'Id', 'adviserworkplace.clients.details.id', '-view', 325, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Documents
                       ('binders', 'Binders', 'adviserworkplace.clients.documents.binders', '-view', 364, NULL, 1),
                       ('documentqueue', 'Document Queue', 'adviserworkplace.clients.documents.documentqueue', '-view', 364, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Opportunities
                       ('opportunities', 'Opportunities', 'adviserworkplace.clients.opportunities.opportunities', '-liogroup', 826, NULL, 1),
                       ('goals', 'Goals', 'adviserworkplace.clients.opportunities.goals', '-view', 826, NULL, 1),
                       ('goalsandobjectives', 'Goals & Objectives', 'adviserworkplace.clients.opportunities.goalsandobjectives', '-view', 826, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Plans
                       ('beneficiaries', 'Beneficiaries', 'adviserworkplace.clients.plans.beneficiaries', '-view', 336, NULL, 1),
                       ('commissionprocfees', 'Commission & Proc Fees', 'adviserworkplace.clients.plans.commissionprocfees', '-view', 336, NULL, 1),
                       ('eventhistory', 'Event History', 'adviserworkplace.clients.plans.eventhistory', '-view', 336, NULL, 1),
                       ('expectations', 'Expectations', 'adviserworkplace.clients.plans.expectations', '-view', 336, NULL, 1),
                       ('fees', 'Fees', 'adviserworkplace.clients.plans.fees', '-view', 336, NULL, 1),
                       ('members', 'Members', 'adviserworkplace.clients.plans.members', '-view', 336, NULL, 1),
                       ('solicitor', 'Solicitor', 'adviserworkplace.clients.plans.solicitor', '-view', 336, NULL, 1),
                       ('subplans', 'Sub Plans', 'adviserworkplace.clients.plans.subplans', '-view', 336, NULL, 1),
                       ('viewtoups', 'Top Ups', 'adviserworkplace.clients.plans.viewtoups', '-view', 336, NULL, 1),
                       ('accrualsexpectations', 'Accruals Expectations', 'adviserworkplace.clients.plans.accrualsexpectations', '-view', 336, NULL, 1),
                       ('schemecategory', 'Category', 'adviserworkplace.clients.plans.schemecategory', '-view', 336, NULL, 1),
                       ('recommendations', 'Recommendations', 'adviserworkplace.clients.plans.recommendations', '-view', 336, NULL, 1),
                       -- Adwiser Workplace -> Clients -> PFP
                       ('inbox', 'Inbox', 'adviserworkplace.clients.pfp.inbox', '-liogroup', 1445, NULL, 1),
                       ('sentitems', 'Sent Items', 'adviserworkplace.clients.pfp.sentitems', '-view', 1445, NULL, 1),
                       ('insights', 'Insights', 'adviserworkplace.clients.pfp.insights', '-view', 1445, NULL, 1),
                       ('pfpchanges', 'PFP Changes', 'adviserworkplace.clients.pfp.pfpchanges', '-view', 1445, NULL, 1),
                       ('pfpsettings', 'PFP Settings', 'adviserworkplace.clients.pfp.pfpsettings', '-view', 1445, NULL, 1),
                       ('goals', 'Goals', 'adviserworkplace.clients.pfp.goals', '-view', 1445, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Quotes & Apps
                       ('quotesandillustrations', 'Quotes & Illustrations', 'adviserworkplace.clients.quotesandapps.quotesandillustrations', '-view', 861, NULL, 1),
                       ('quotesandapps', 'Quotes & Apps', 'adviserworkplace.clients.quotesandapps.quotesandapps', '-liogroup', 861, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Tools
                       ('calculators', 'Calculators', 'adviserworkplace.clients.tools.calculators', '-view', 661, NULL, 1),
                       ('portfolios', 'Portfolios', 'adviserworkplace.clients.tools.portfolios', '-view', 661, NULL, 1),
                       ('fundanalysis', 'Fund Analysis', 'adviserworkplace.clients.tools.fundanalysis', '-view', 661, NULL, 1),
                       ('financialplanningsessions', 'Financial Planning Sessions', 'adviserworkplace.clients.tools.financialplanningsessions', '-view', 661, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Service Case
                       ('summary', 'Summary', 'adviserworkplace.clients.advicecases.summary', '-liogroup', 982, NULL, 1),
                       ('linkedplans', 'Linked Plans', 'adviserworkplace.clients.advicecases.linkedplans', '-view', 982, NULL, 1),
                       ('linkedfeesandretainers', 'Linked Fees and Retainers', 'adviserworkplace.clients.advicecases.linkedfeesandretainers', '-view', 982, NULL, 1),
                       ('recommendations', 'Recommendations', 'adviserworkplace.clients.advicecases.recommendations', '-view', 982, NULL, 1),
                       ('activities', 'Activities', 'adviserworkplace.clients.advicecases.activities', '-view', 982, NULL, 1),
                       ('documents', 'Documents', 'adviserworkplace.clients.advicecases.documents', '-view', 982, NULL, 1),
                       ('statushistory', 'Status History', 'adviserworkplace.clients.advicecases.statushistory', '-view', 982, NULL, 1),
                       -- -- Adwiser Workplace -> Clients -> Fees
                       ('relatedplans', 'Related Plans', 'adviserworkplace.clients.fees.relatedplans', '-view', 353, NULL, 1),
                       ('relatedtasks', 'Related Tasks', 'adviserworkplace.clients.fees.relatedtasks', '-view', 353, NULL, 1),
                       ('notes', 'Notes', 'adviserworkplace.clients.fees.notes', '-view', 353, NULL, 1),
                       ('expectations', 'Expectations', 'adviserworkplace.clients.fees.expectations', '-view', 353, NULL, 1),
                       ('history', 'History', 'adviserworkplace.clients.fees.history', '-view', 353, NULL, 1),
                       -- Adwiser Workplace -> Leads -> Details
                       ('splits', 'Lead Splits', 'adviserworkplace.leads.details.splits', '-view', 666, NULL, 1),
                       ('adviserhistory', 'Adviser History', 'adviserworkplace.leads.details.adviserhistory', '-view', 666, NULL, 1),
                       ('dpa', 'DPA', 'adviserworkplace.leads.details.dpa', '-view', 666, NULL, 1),
                       ('marketing', 'Marketing', 'adviserworkplace.leads.details.marketing', '-view', 666, NULL, 1),
                       -- Adwiser Workplace -> Leads -> Documents
                       ('documentqueue', 'Document Queue', 'adviserworkplace.leads.documents.documentqueue', '-view', 687, NULL, 1),
                       -- Adwiser Workplace -> Leads -> Opportunities
                       ('opportunity', 'Opportunities', 'adviserworkplace.leads.opportunity.opportunity', '-liogroup', 1223, NULL, 1),
                       ('goalsandobjectives', 'Goals & Objectives', 'adviserworkplace.leads.opportunity.goalsandobjectives', '-view', 1223, NULL, 1),
                       -- Adwiser Workplace -> Leads -> Activities
                       ('taskandappts', 'Tasks & Appts', 'adviserworkplace.leads.tasks.taskandappts', '-view', 684, NULL, 1),
                       ('workflows', 'Workflows', 'adviserworkplace.leads.tasks.workflows', '-view', 684, NULL, 1),
                       ('emails', 'Emails', 'adviserworkplace.leads.tasks.emails', '-view', 684, NULL, 1),
                       ('activityhistory', 'Activity History', 'adviserworkplace.leads.tasks.activityhistory', '-liogroup', 684, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Opportunities
                       ('opportunity', 'Opportunity', 'adviserworkplace.clients.opportunities.opportunity', '-view', 826, NULL, 1),
                       ('linkedgoalsandobjectives', 'Linked Goals & Objectives', 'adviserworkplace.clients.opportunities.linkedgoalsandobjectives', '-view', 826, NULL, 1),
                       ('mortgage', 'Mortgage', 'adviserworkplace.clients.opportunities.mortgage', '-view', 826, NULL, 1),
                       ('statushistory', 'Status History', 'adviserworkplace.clients.opportunities.statushistory', '-view', 826, NULL, 1),
                       ('linkedplans', 'Linked Plans', 'adviserworkplace.clients.opportunities.linkedplans', '-view', 826, NULL, 1),
                       ('linkedfees', 'Linked Fees', 'adviserworkplace.clients.opportunities.linkedfees', '-view', 826, NULL, 1),
                       ('linkedgoals', 'Linked Goals', 'adviserworkplace.clients.opportunities.linkedgoals', '-view', 826, NULL, 1),
                       ('linkedbinders', 'Linked Binders', 'adviserworkplace.clients.opportunities.linkedbinders', '-view', 826, NULL, 1),
                       ('notes', 'Notes', 'adviserworkplace.clients.opportunities.notes', '-view', 826, NULL, 1),
                       ('tasks', 'Tasks', 'adviserworkplace.clients.opportunities.tasks', '-view', 826, NULL, 1),
                       ('feesandcharges', 'Fees & Charges', 'adviserworkplace.clients.plans.feesandcharges', '-view', 336, NULL, 1),
                       ('statushistory', 'Status History', 'adviserworkplace.leads.opportunity.statushistory', '-view', 1223, NULL, 1),
                       ('notes', 'Notes', 'adviserworkplace.leads.opportunity.notes', '-view', 1223, NULL, 1),
                       ('linkedgoalsandobjectives', 'Linked Goals & Objectives', 'adviserworkplace.leads.opportunity.linkedgoalsandobjectives', '-view', 1223, NULL, 1),
                       ('mortgage', 'Mortgage', 'adviserworkplace.leads.opportunity.mortgage', '-view', 1223, NULL, 1),
                       ('tasks', 'Tasks', 'adviserworkplace.leads.opportunity.tasks', '-view', 1223, NULL, 1),
                       ('categories', 'Categories', 'adviserworkplace.clients.scheme.categories', '-view', 350, NULL, 1),
                       ('commission', 'Commission', 'adviserworkplace.clients.scheme.commission', '-view', 350, NULL, 1),
                       ('tasks', 'Tasks', 'adviserworkplace.clients.scheme.tasks', '-view', 350, NULL, 1),
                       ('valuation', 'Valuation', 'adviserworkplace.clients.scheme.valuation', '-view', 350, NULL, 1),
                       ('leavers', 'Leavers', 'adviserworkplace.clients.scheme.leavers', '-view', 350, NULL, 1),
                       ('fees', 'Fees', 'adviserworkplace.clients.scheme.fees', '-view', 350, NULL, 1),
                       ('notes', 'Notes', 'adviserworkplace.clients.scheme.notes', '-view', 350, NULL, 1),
                       ('claimshistory', 'Claims History', 'adviserworkplace.clients.scheme.claimshistory', '-view', 350, NULL, 1),
                       -- Adwiser Workplace -> Clients -> Fact Find
                       ('profile', 'Profile', 'adviserworkplace.clients.factfind.profile', '-view', 1342, NULL, 1),
                       ('employment', 'Employment', 'adviserworkplace.clients.factfind.employment', '-view', 1342, NULL, 1),
                       ('assetsandliabilities', 'Assets And Liabilities', 'adviserworkplace.clients.factfind.assetsandliabilities', '-view', 1342, NULL, 1),
                       ('budget', 'Budget', 'adviserworkplace.clients.factfind.budget', '-view', 1342, NULL, 1),
                       ('mortgage', 'Mortgage', 'adviserworkplace.clients.factfind.mortgage', '-view', 1342, NULL, 1),
                       ('protection', 'Protection', 'adviserworkplace.clients.factfind.protection', '-view', 1342, NULL, 1),
                       ('retirement', 'Retirement', 'adviserworkplace.clients.factfind.retirement', '-view', 1342, NULL, 1),
                       ('investment', 'Investment', 'adviserworkplace.clients.factfind.investment', '-view', 1342, NULL, 1),
                       ('estateplanning', 'Estateplanning', 'adviserworkplace.clients.factfind.estateplanning', '-view', 1342, NULL, 1),
                       ('otherplans', 'Other Plans', 'adviserworkplace.clients.factfind.otherplans', '-view', 1342, NULL, 1),
                       ('summary', 'Summary', 'adviserworkplace.clients.factfind.summary', '-view', 1342, NULL, 1);


                INSERT INTO TSystemAudit(SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser)
                SELECT SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, 'C', @CurrentDateTime, @StampUser 
                FROM TSystem
                WHERE SystemId IN (SELECT SystemId FROM @SystemIdsTmp)

                DELETE FROM @SystemIdsTmp
                WHERE SystemId IN (SELECT SystemId FROM TSystem WHERE SystemType = '-liogroup')

                INSERT INTO TRefLicenseTypeToSystem (RefLicenseTypeId, SystemId, ConcurrencyId)
                OUTPUT inserted.RefLicenseTypeId, inserted.SystemId, 1, inserted.RefLicenseTypeToSystemId, 'C', @CurrentDateTime, @StampUser
                INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
                SELECT l.RefLicenseTypeId, s.SystemId, 1
                    FROM TRefLicenseType l 
                        CROSS JOIN @SystemIdsTmp s
                        INNER JOIN TRefLicenseTypeToSystem lts ON s.ParentId = lts.SystemId AND l.RefLicenseTypeId = lts.RefLicenseTypeId

                -- Update Existing TSystem

                UPDATE TSystem
                SET Description = 'Service Case', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.advicecases';

                UPDATE TSystem
                SET Description = 'Addresses', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.leads.details.address';

                UPDATE TSystem
                SET Description = 'Contact', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.leads.details.contact';

                UPDATE TSystem
                SET Identifier = 'activities', Description = 'Activities', SystemPath = 'adviserworkplace.clients.plans.activities', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.activityhistory';

                UPDATE TSystem
                SET Identifier = 'commission', Description = 'Commission', SystemPath = 'adviserworkplace.clients.plans.commission', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.commissions';

                UPDATE TSystem
                SET Identifier = 'commission', Description = 'History', SystemPath = 'adviserworkplace.clients.plans.history', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.planhistory';

                UPDATE TSystem
                SET Identifier = 'fundsholdings', Description = 'Funds/Holdings', SystemPath = 'adviserworkplace.clients.plans.fundsholdings', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.fund';

                UPDATE TSystem
                SET Identifier = 'purpose', Description = 'Purpose', SystemPath = 'adviserworkplace.clients.plans.purpose', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.planpurpose';

                UPDATE TSystem
                SET Identifier = 'switch', Description = 'Switch', SystemPath = 'adviserworkplace.clients.plans.switch', ConcurrencyId = ConcurrencyId + 1, SystemType = '-view'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.switchdetails';

                UPDATE TSystem
                SET Description = 'Activities', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.leads.tasks';

                UPDATE TSystem
                SET SystemPath = 'adviserworkplace.clients.details.trusteesandbeneficiaries', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.details.relationships' AND Description = 'Trustees & Beneficiaries';

                UPDATE TSystem
                SET SystemPath = 'adviserworkplace.clients.fees.retainerdetails', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.fees.details' AND Description = 'Retainer Details';

                UPDATE TSystem
                SET SystemPath = 'adviserworkplace.clients.fees.creditnotedetails', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.fees.details' AND Description = 'Credit Note Details';

                UPDATE TSystem
                SET SystemPath = 'adviserworkplace.leads.details.trusteesandbeneficiaries', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.leads.details.relationships' AND Description = 'Trustees & Beneficiaries';

                UPDATE TSystem
                SET Description = 'Documents', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.leads.documents.documents';

                UPDATE TSystem
                SET Description = 'Summary'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.summary';

                UPDATE TSystem
                SET Description = 'Splits'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.splits';

                UPDATE TSystem
                SET Description = 'Withdrawals'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.withdrawal';

                UPDATE TSystem
                SET Description = 'Contributions'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.contribution';

                UPDATE TSystem
                SET Description = 'Pensions'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.pension';

                UPDATE TSystem
                SET Description = 'Valuations'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.valuation';

                UPDATE TSystem
                SET Description = 'Benefits'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.benefit';

                UPDATE TSystem
                SET Description = 'Documents'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.documents';

                UPDATE TSystem
                SET Description = 'Mortgage'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.mortgage';
                
                UPDATE TSystem
                SET Description = 'Notes'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.notes';
                
                UPDATE TSystem
                SET Description = 'Tasks'
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.plantaskview';

                -- ADD EXISTING System Paths to all licenses

                DELETE FROM @SystemIdsTmp

                INSERT INTO @SystemIdsTmp
                    SELECT SystemId, ParentId FROM TSystem
                    WHERE SystemPath IN (
                       -- Adwiser Workplace -> Accounts -> Details
                       'adviserworkplace.accounts.details.address',
                       'adviserworkplace.accounts.details.contact',
                       'adviserworkplace.accounts.details.relationships',
                       'adviserworkplace.accounts.details.notes',
                       -- Adwiser Workplace -> Clients -> Activities
                       'adviserworkplace.clients.tasks.documents',
                       -- Adwiser Workplace -> Clients -> Details
                       'adviserworkplace.clients.details.personal',
                       'adviserworkplace.clients.details.corporate',
                       'adviserworkplace.clients.details.trust',
                       'adviserworkplace.clients.details.address',
                       'adviserworkplace.clients.details.contact',
                       'adviserworkplace.clients.details.splits',
                       'adviserworkplace.clients.details.notes',
                       -- Adwiser Workplace -> Clients -> Plans
                       'adviserworkplace.clients.plans.activities',
                       'adviserworkplace.clients.plans.commission',
                       'adviserworkplace.clients.plans.documents',
                       'adviserworkplace.clients.plans.history',
                       'adviserworkplace.clients.plans.fundsholdings',
                       'adviserworkplace.clients.plans.notes',
                       'adviserworkplace.clients.plans.pension',
                       'adviserworkplace.clients.plans.mortgage',
                       'adviserworkplace.clients.plans.purpose',
                       'adviserworkplace.clients.plans.splits',
                       'adviserworkplace.clients.plans.switch',
                       'adviserworkplace.clients.plans.valuation',
                       'adviserworkplace.clients.plans.withdrawal',
                       'adviserworkplace.clients.plans.contribution',
                       'adviserworkplace.clients.plans.pension',
                       -- Adwiser Workplace -> Clients -> Fees
                       'adviserworkplace.clients.fees.splits',
                       'adviserworkplace.clients.fees.documents',
                       -- Adwiser Workplace -> Leads -> Details
                       'adviserworkplace.leads.details.personal',
                       'adviserworkplace.leads.details.corporate',
                       'adviserworkplace.leads.details.trust',
                       'adviserworkplace.leads.details.address',
                       'adviserworkplace.leads.details.contact',
                       'adviserworkplace.leads.details.relationships',
                       'adviserworkplace.leads.details.leadstatushistory',
                       'adviserworkplace.leads.details.notes',
                       -- Adwiser Workplace -> Leads -> Activities
                       'adviserworkplace.leads.tasks.documents',
                       -- Adwiser Workplace -> Sales -> Fees & Commission
                       'adviserworkplace.sales.incomeearned.splittemplate'
                       );

                INSERT INTO TRefLicenseTypeToSystem (RefLicenseTypeId, SystemId, ConcurrencyId)
                OUTPUT inserted.RefLicenseTypeId, inserted.SystemId, 1, inserted.RefLicenseTypeToSystemId, 'C', @CurrentDateTime, @StampUser
                INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
                SELECT result.RefLicenseTypeId, result.SystemId, 1
                    FROM (SELECT l.RefLicenseTypeId, s.SystemId
                          FROM TRefLicenseType l 
                          CROSS JOIN @SystemIdsTmp s
                          INNER JOIN TRefLicenseTypeToSystem lts ON s.ParentId = lts.SystemId AND l.RefLicenseTypeId = lts.RefLicenseTypeId
                          EXCEPT
                          SELECT RefLicenseTypeId, SystemId FROM TRefLicenseTypeToSystem
                    ) AS result

            -- END DATA INSERT/UPDATE/DELETE

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

        DECLARE @ErrorSeverity INT
        DECLARE @ErrorState INT
        DECLARE @ErrorLine INT
        DECLARE @ErrorNumber INT

        SELECT @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE()

        /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
