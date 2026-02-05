SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION  dbo.FnCustomGetPlanTypeForPlanDetailId(@PolicyDetailId bigint)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @PlanType varchar(255)

	Select @PlanType = PlanTypeName
	From PolicyManagement..TPolicyDetail PolicyDetail With(NoLock)
	Inner Join PolicyManagement..TPlanDescription PlanDescription With(NoLock)
		on PolicyDetail.PlanDescriptionId = PlanDescription.PlanDescriptionId
	Inner Join PolicyManagement..TRefPlanType2ProdSubType RefPlanType2ProdSubType With(NoLock) 
		on PlanDescription.RefPlanType2ProdSubTypeId = RefPlanType2ProdSubType.RefPlanType2ProdSubTypeId
	Inner Join PolicyManagement..TRefPlanType PlanType With(NoLock)
		on RefPlanType2ProdSubType.RefPlanTypeId = PlanType.RefPlanTypeId
	Where PolicyDetailId = @PolicyDetailId

	RETURN (@PlanType)
END




GO
