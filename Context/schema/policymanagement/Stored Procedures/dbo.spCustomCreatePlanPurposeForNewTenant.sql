SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomCreatePlanPurposeForNewTenant]
(
	@NewTenantId BIGINT
	,@SourceIndigoClientId BIGINT
)
AS

BEGIN

DECLARE @StampActionCreate CHAR(1) = 'C', 		@StampDateTime DATETIME = GETDATE(), 		@StampUserSystem CHAR(1) = '0'
INSERT 	TPlanPurpose	(		Descriptor, 		MortgageRelatedfg, 		IndigoClientId	)OUTPUT 	inserted.Descriptor, 	inserted.MortgageRelatedfg, 	inserted.IndigoClientId, 	inserted.ConcurrencyId, 	inserted.PlanPurposeId, 	@StampActionCreate, 	@StampDateTime, 	@StampUserSystemINTO 	TPlanPurposeAudit	(		Descriptor, 		MortgageRelatedfg, 		IndigoClientId, 		ConcurrencyId, 		PlanPurposeId, 		StampAction, 		StampDateTime, 		StampUser	)SELECT 	Src.Descriptor, 	Src.MortgageRelatedfg, 	@NewTenantIdFROM 	TPlanPurpose Src	LEFT JOIN TPlanPurpose Dest ON Dest.Descriptor = Src.Descriptor		AND Dest.MortgageRelatedfg = Src.MortgageRelatedfgWHERE	Src.IndigoClientId = @SourceIndigoClientId	AND Dest.PlanPurposeId IS NULL	INSERT 	TPlanTypePurpose	(		RefPlanTypeId, 		PlanPurposeId, 		DefaultFg, 		RefPlanType2ProdSubTypeId	)OUTPUT 	inserted.RefPlanTypeId, 	inserted.PlanPurposeId, 	inserted.DefaultFg, 	inserted.ConcurrencyId, 	inserted.PlanTypePurposeId, 	inserted.RefPlanType2ProdSubTypeId, 	@StampActionCreate, 	@StampDateTime, 	@StampUserSystemINTO 	TPlanTypePurposeAudit	(		RefPlanTypeId, 		PlanPurposeId, 		DefaultFg, 		ConcurrencyId, 		PlanTypePurposeId, 		RefPlanType2ProdSubTypeId,		StampAction, 		StampDateTime, 		StampUser	)SELECT 	Src.RefPlanTypeId, 	DestinationPlanPurpose.PlanPurposeId, 	Src.DefaultFg, 	Src.RefPlanType2ProdSubTypeIdFROM 	TPlanTypePurpose Src	JOIN TPlanPurpose SourcePlanPurpose ON SourcePlanPurpose.PlanPurposeId = Src.PlanPurposeId	JOIN TPlanPurpose DestinationPlanPurpose ON DestinationPlanPurpose.Descriptor = SourcePlanPurpose.Descriptor		AND DestinationPlanPurpose.IndigoClientId = @NewTenantId	LEFT JOIN TPlanTypePurpose Dest ON Dest.RefPlanType2ProdSubTypeId = Src.RefPlanType2ProdSubTypeIdWHERE	SourcePlanPurpose.IndigoClientId = @SourceIndigoClientId	AND Dest.PlanTypePurposeId IS NULL		END
GO
