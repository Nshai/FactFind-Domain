SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[spNCustomRetrieveFeeCommissionRebateDetailsForProvBreak]
	@ProvBreakId bigint,
	@IndClientId int
AS
		SELECT Fee2Policy.FeeId, Item.ProvBreakId, Item.Amount, Item.AnalysedDate
		FROM commissions..TProvBreak Item
		INNER JOIN PolicyManagement..TPolicyBusiness Policies ON Item.PolicyId = Policies.PolicyBusinessId
		INNER JOIN PolicyManagement..TFee2Policy Fee2Policy ON Policies.PolicyBusinessId = Fee2Policy.PolicyBusinessId
		WHERE Item.ProvBreakId = @ProvBreakId AND Fee2Policy.RebateCommission = 1 AND Item.IndClientId = @IndClientId
GO
