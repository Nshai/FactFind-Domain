SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].SpNCustomRetrievePlanPurposesWithPlanTypeForTenant 
	@IndigoClientId bigint 
AS


BEGIN
	select 
		1 as tag,
		null as parent,
		null as [PlanPurposes!1!],
		null as [PlanPurpose!2!typeid],		
		null as [PlanPurpose!2!id],
		null as [PlanPurpose!2!description]
		union all
	select
		2 as Tag ,
		1 as parent,
		null,
		B.RefPlanType2ProdSubTypeId ,
		A.PlanPurposeId, 
		A.Descriptor 
	from policymanagement..TPlanPurpose A
	inner join policymanagement..TPlanTypePurpose B on B.PlanPurposeId=A.PlanPurposeId	
	where A.IndigoClientId=@IndigoClientId 
	order by [PlanPurpose!2!typeid], [PlanPurpose!2!description]
	for xml explicit
END

GO
