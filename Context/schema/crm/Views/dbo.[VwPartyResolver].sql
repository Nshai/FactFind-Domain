SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE View [dbo].[VwPartyResolver]
AS
select [CRMContactId]
	   ,'Lead' as Type 
	   ,[LeadId] as ResourceId
	   ,[IndigoClientId] as TenantId
from [dbo].[TLead]
where [CRMContactId] is not null
union all
select [CRMContactId]
	   ,'Adviser' as Type 
	   ,[PractitionerId] as ResourceId
	   ,[IndClientId] as TenantId
from [dbo].[TPractitioner]
where [CRMContactId] is not null
union all
select [CRMContactId]
	   ,'Account' as Type 
	   ,[AccountId] as ResourceId
	   ,[IndigoClientId]  as TenantId 
from [dbo].[TAccount]
where [CRMContactId] is not null
union all
select [CRMContactId]
	   ,'User' as Type 
	   ,[UserId] as ResourceId
	   ,[IndigoClientId]  as TenantId 
from Administration.dbo.TUser	
where [CRMContactId] is not null
union all		
select [CRMContactId]
	   ,'Client' as Type 
	   ,[CRMContactId] as ResourceId
	   ,[IndClientId] as TenantId 
from [crm].[dbo].[TCRMContact] 	
where RefCRMContactStatusId = 1
and isnull(InternalContactFG, 0) = 0
union all
select [CRMContactId]
	   ,'Prospect' as Type 
	   ,[CRMContactId] as ResourceId
	   ,[IndClientId] as TenantId 
from [crm].[dbo].[TCRMContact] 	
where RefCRMContactStatusId = 2
and isnull(InternalContactFG, 0) = 0
union all
select [CRMContactId]
	   ,'Group' as Type 
	   ,[GroupId] as ResourceId
	   ,[IndigoClientId] as TenantId 
from Administration.dbo.TGroup  
where [CRMContactId] is not null	
union all
select [CRMContactId]
	   ,'Introducer' as Type 
	   ,[IntroducerId] as ResourceId
	   ,[IndClientId] as TenantId
from [dbo].[TIntroducer]
where [CRMContactId] is not null