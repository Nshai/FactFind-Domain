SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrievePlanPurposesForPlanType] @IndigoClientId bigint, @PlanType varchar(255), @RegionCode varchar(2) = 'GB'
AS

declare @RefPlanTypeId bigint

SELECT @RefPlanTypeId=rpt.RefPlanTypeId FROM PolicyManagement..TRefPlanType rpt
		INNER JOIN PolicyManagement..TRefPlanType2ProdSubType rpt2pst ON rpt2pst.RefPlanTypeId = rpt.RefPlanTypeId
		WHERE PlanTypeName=@PlanType AND rpt2pst.RegionCode = @RegionCode

IF @RefPlanTypeId IS NULL
BEGIN
	-- search for bracket
	IF CHARINDEX('(', @PlanType) > 0
	BEGIN
		-- Get plan type part
		SET @PlanType = RTRIM(LEFT(@PlanType, CHARINDEX('(', @PlanType)-1))
		-- try again
		SELECT @RefPlanTypeId=rpt.RefPlanTypeId FROM PolicyManagement..TRefPlanType rpt
		INNER JOIN PolicyManagement..TRefPlanType2ProdSubType rpt2pst ON rpt2pst.RefPlanTypeId = rpt.RefPlanTypeId
		WHERE PlanTypeName=@PlanType AND rpt2pst.RegionCode = @RegionCode
	END
END


IF ISNULL(@RefPlanTypeId,0)>0
BEGIN
	select 
		1 as tag,
		null as parent,
		null as [PlanPurposes!1!],
		null as [PlanPurpose!2!id],
		null as [PlanPurpose!2!value]
		union all
	select
		2 as Tag ,
		1 as parent,
		null,
		A.PlanPurposeId as [PlanPurpose!2!id], 
		A.Descriptor as [PlanPurpose!2!value]
	from policymanagement..TPlanPurpose A
	inner join policymanagement..TPlanTypePurpose B on B.PlanPurposeId=A.PlanPurposeId
	where A.IndigoClientId=@IndigoClientId and B.RefPlanTypeId=@RefPlanTypeId
	order by [PlanPurpose!2!id]
	for xml explicit
END
GO
