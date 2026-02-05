SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomInsertDefaultDataForIndigoClient]
	@IndigoClientId bigint
AS

	SET NOCOUNT ON

-- insert data for Campaign Management
	Declare @CampaignTypeCount bigint, @CampaignType varchar(255), @CampaignTypeId bigint, @CampaignTypeTotalRows bigint, @CampaignTypeRowCount bigint
	Declare @ExecString varchar(1000), @CurrentId bigint

	--Initial Data
	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Mailshot',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Referral',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Known to Practitioner',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Existing Client',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Client Approach',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Seminar/Exhibition',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Recommendation',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Introducer',0,1
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Lead',0,1
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Advertisement',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Web',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Newspaper',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

	exec CRM.dbo.SpCreateCampaignType '0', @IndigoClientId, 'Other',0
	Select @CurrentId = IDENT_CURRENT('TCampaignType')
	exec crm.dbo.SpCreateCampaign '0', @CurrentId, @IndigoClientId, Null, 'Other',0,1

-- insert data for Opportunity Management

	exec CRM.dbo.SpCreateOpportunityType '0', 'Lump sum investment', @IndigoClientId, 0
	exec CRM.dbo.SpCreateOpportunityType '0', 'Pension plan', @IndigoClientId, 0
	exec CRM.dbo.SpCreateOpportunityType '0', 'Protection', @IndigoClientId
	exec CRM.dbo.SpCreateOpportunityType '0', 'Regular investment', @IndigoClientId
	exec CRM.dbo.SpCreateOpportunityType '0', 'Tax planning', @IndigoClientId
	exec CRM.dbo.SpCreateOpportunityType '0', 'Mortgage', @IndigoClientId, 0, 1
	exec CRM.dbo.SpCreateOpportunityType '0', 'Mortgage(Non-Regulated)', @IndigoClientId, 0, 1
	exec CRM.dbo.SpCreateOpportunityType '0', 'Equity Release', @IndigoClientId, 0, 1
	
	exec CRM.dbo.SpCreateOpportunityStatus '0', 'Lead received', @IndigoClientId, 1, 0
	exec CRM.dbo.SpCreateOpportunityStatus '0', '1st Appointment', @IndigoClientId, 0, 0
	exec CRM.dbo.SpCreateOpportunityStatus '0', '2nd Appointment', @IndigoClientId, 0, 0
	exec CRM.dbo.SpCreateOpportunityStatus '0', 'Sale', @IndigoClientId, 0, 0


-- lets deal with the ref interests


insert into crm..trefinterest (descriptor, interest, opportunitytypeid, opportunitycreationfg, probability, leadversionfg, indigoclientid)
select ri.descriptor, ri.interest, ri.opportunitytypeid, ri.opportunitycreationfg, ri.probability, ri.leadversionfg, @IndigoClientId
from crm..trefinterest ri
where ri.indigoclientid = 1
GO
