SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spListBudgetMiscellaneousQuery] 
	@ClientId BIGINT
AS

SELECT
    bm.BudgetMiscellaneousId,
	bm.CRMContactId AS BudgetMiscellaneousForClienId,
	bm.AssetsNonDisclosure,
	bm.AnyAssets,
	bm.AnyLiabilities,
	bm.AssetLiabilityNotes,
	bm.BudgetNotes,
	bm.LiabilitiesNonDisclosure,
	bm.LiabilitiesRepayment,
	bm.LiabilitiesWhyNot,
	bm.LiabilityNotes,
	bm.RepaymentDetails,
	bm.Tax,
	bm.TotalEarnings
FROM TBudgetMiscellaneous bm
WHERE bm.CRMContactId = @ClientId

GO