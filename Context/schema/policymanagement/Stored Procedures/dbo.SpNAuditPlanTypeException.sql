SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPlanTypeException]
	@StampUser varchar (255),
	@PlanTypeExceptionId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanTypeExceptionAudit 
( RefPlanType2ProdSubTypeId, PreSaleSumAssured, PreSaleLumpSumContribution, PreSaleRegularContribution, 
		PreSaleAgeLowerLimit, PreSaleAgeUpperLimit, PostSaleSumAssured, PostSaleLumpSumContribution, 
		PostSaleRegularContribution, PostSaleAgeLowerLimit, PostSaleAgeUpperLimit,
		PlanTypeExceptionName, SumAssured, LumpSumContribution, RegularContribution, AgeLowerLimit, 
		AgeUpperLimit, IsPreSale, IsPostSale, IsArchived,IsPOA,RiskProfileType, Location, AtrTemplateId,
		AdviceCaseStatusId,IsVulnerableCustomer, TenantId, ConcurrencyId, 
	PlanTypeExceptionId, StampAction, StampDateTime, StampUser) 
Select RefPlanType2ProdSubTypeId, PreSaleSumAssured, PreSaleLumpSumContribution, PreSaleRegularContribution, 
		PreSaleAgeLowerLimit, PreSaleAgeUpperLimit, PostSaleSumAssured, PostSaleLumpSumContribution, 
		PostSaleRegularContribution, PostSaleAgeLowerLimit, PostSaleAgeUpperLimit, 
		PlanTypeExceptionName, SumAssured, LumpSumContribution, RegularContribution, AgeLowerLimit, 
		AgeUpperLimit, IsPreSale, IsPostSale, IsArchived,IsPOA,RiskProfileType, Location, AtrTemplateId,
		AdviceCaseStatusId,IsVulnerableCustomer, TenantId, ConcurrencyId, 
	PlanTypeExceptionId, @StampAction, GetDate(), @StampUser
FROM TPlanTypeException
WHERE PlanTypeExceptionId = @PlanTypeExceptionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
