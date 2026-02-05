SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomInsertDefaultSystemSecurityKeys]
@IndigoClientId bigint

AS


-- ###### SETUP SYSTEM SECURITY #######

-- ## Manager
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.plans',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.scheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.fees',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.documents',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.tasks',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.clientadvancedsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.clients.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.sales',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.sales.incomeearned',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.sales.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.sales.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','adviserworkplace.sales.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','client',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','fee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','retainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','creditnote',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','plan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','plan.actions.bussub',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','document',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','proposal',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','proposal.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','proposal.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','proposal.actions.reassigntccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Manager','client.add.addtask',1,0


-- ## Compliance Manager
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.plans',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.scheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.fees',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.documents',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.tasks',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.clientadvancedsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.clients.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.sales',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.sales.incomeearned',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.sales.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.sales.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.sales.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','adviserworkplace.sales.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.filechecking',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.filechecking.file',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.advisers',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.advisers.manage',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.advisers.addadviser',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.advisers.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.tccoaches',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.tccoaches.manage',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.tccoaches.addtccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.tccoaches.tccoachsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.author',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.author.templates',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.author.headings',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.author.paragraphs',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.author.types',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.author.styles',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.administration',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.administration.filechecking',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.administration.advisers',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.administration.tccoaches',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.administration.registers',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','compliance.proposals.Detail',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','client',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','fee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','fee.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','retainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','retainer.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','creditnote',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','plan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','plan.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','plan.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','plan.actions.bussub',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','document',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','proposal',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','proposal.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','proposal.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','proposal.actions.reassigntccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','template',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','paragraph',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','casefile',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','tnccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Compliance Manager','client.add.addtask',1,0

-- ## Adviser
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.plans',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.scheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.fees',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.documents',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.addclient',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.addclientandplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.tasks',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.clientadvancedsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.clients.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.sales',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.sales.incomeearned',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.sales.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.sales.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.sales.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','adviserworkplace.sales.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addscheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addtopup',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addfee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addretainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.adddocument',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addaddress',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addcontact',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addrelationship',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addsplit',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','fee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','fee.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','fee.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','fee.actions.relatetoplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','fee.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','retainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','retainer.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','retainer.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','retainer.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','creditnote',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','plan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','plan.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','plan.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','plan.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','plan.actions.bussub',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','document',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','proposal',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','proposal.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','proposal.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','proposal.actions.reassigntccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Adviser','client.add.addtask',1,0

-- ## Paraplanner
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','retainer.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','retainer.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','retainer.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','retainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','proposal.actions.reassigntccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','proposal.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','proposal.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','proposal',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','plan.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','plan.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','plan.actions.bussub',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','plan.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','plan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','fee.actions.relatetoplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','fee.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','fee.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','fee.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','fee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','document',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','creditnote',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addtopup',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addsplit',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addscheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addretainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addrelationship',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addfee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.adddocument',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addcontact',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addaddress',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.sales.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.sales.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.sales.incomeearned',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.sales.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.sales.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.sales',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.tasks',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.scheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.plans',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.fees',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.documents',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.clientadvancedsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.addclientandplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients.addclient',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace.clients',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','adviserworkplace',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Paraplanner','client.add.addtask',1,0

-- Commissions Manager
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','retainer.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','retainer.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','retainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','proposal.actions.reassigntccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','proposal.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','proposal.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','proposal',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','practitionerquery',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','policypaymenthistory',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','plan.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','plan.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','plan.actions.bussub',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','plan.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','plan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','introducer.actions.addaddress',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','introducer.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','introducer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','importedproviderstatement.actions.makelive',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','importedproviderstatement.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','importedproviderstatement',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','importedbreakdownsummary',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','fee.actions.allocatepayments',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','fee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','document',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','creditnote',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.providerstatements.statementsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.providerstatements.statement',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.providerstatements.electronicimports',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.providerstatements.automatching',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.providerstatements',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.introducers.introducersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.introducers.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.introducers.addintroducer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.introducers',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.commissionqueries.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.cashreceipts.receiptsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.cashreceipts.receipt',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.cashreceipts.importelectroncbankstatement',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.cashreceipts.importcompletediotemplate',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.cashreceipts.downloadblankiotemplate',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.cashreceipts.automatching',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.cashreceipts',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.advisers.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.advisers.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.advisers',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.administration.providers',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.administration.paymentruns',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.administration.payeeconfiguration',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.administration.modifyintroducertypes',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions.administration',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','commissions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','client',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','cashreceiptexp',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','cashreceipt',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','breakdownsummary.actions.breakdownsummary',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','breakdownsummary.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','breakdownsummary',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','breakdownmatch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.sales.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.sales.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.sales.incomeearned',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.sales.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.sales.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.sales',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.tasks',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.scheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.plans',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.fees',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.documents',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients.clientadvancedsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace.clients',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','adviserworkplace',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Commissions Manager','client.add.addtask',1,0

--## TnC Coach
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','retainer.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','retainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','proposal.actions.reassigntccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','proposal.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','proposal.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','proposal',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','plan.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','plan.actions.bussub',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','plan.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','plan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','fee.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','fee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','document',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','creditnote',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','compliance.proposals.Detail',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','compliance.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','compliance',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','client',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.sales.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.sales.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.sales.incomeearned',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.sales.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.sales.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.sales',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.tasks',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.scheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.plans',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.fees',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.documents',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients.clientadvancedsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace.clients',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','adviserworkplace',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'TnC Coach','client.add.addtask',1,0

-- ## Administrator
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','retainer.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','retainer.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','retainer.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','retainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','proposal.actions.reassigntccoach',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','proposal.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','proposal.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','proposal',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','plan.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','plan.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','plan.actions.bussub',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','plan.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','plan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','fee.actions.relatetoplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','fee.actions.querypaymentstatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','fee.actions.changestatus',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','fee.actions',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','fee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','document',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','creditnote',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addtopup',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addsplit',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addscheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addretainer',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addrelationship',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addfee',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.adddocument',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addcontact',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addaddress',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.sales.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.sales.proposals',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.sales.incomeearned',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.sales.commissionqueries',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.sales.advisersearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.sales',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.tasks',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.search',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.scheme',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.plans',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.fees',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.documents',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.details',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.clientadvancedsearch',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.addclientandplan',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients.addclient',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace.clients',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','adviserworkplace',1,0
EXEC TD_SpCustomSetSystemKeyByPathAndIndigoClientId @IndigoClientId, 'Administrator','client.add.addtask',1,0
GO
