SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE View [dbo].[VPartyName]
AS
    select
	c.IndClientId TenantId,
	c.crmcontactid CrmId,
	coalesce(p.FirstName + ' ' + p.LastName, corp.CorporateName, TrustName) PartyName,
	c.IsDeleted
    from CRM.Dbo.TCRMContact c with (nolock)
		left outer join CRM.dbo.TTrust t with (nolock) on t.TrustId = c.TrustId
		left outer join CRM.dbo.TCorporate corp with (nolock) on corp.CorporateId = c.CorporateId
		left outer join CRM.dbo.TPerson p with (nolock) on p.PersonId = c.PersonId
GO
