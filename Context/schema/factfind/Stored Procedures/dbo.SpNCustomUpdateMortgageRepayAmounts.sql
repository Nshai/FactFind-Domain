SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateMortgageRepayAmounts]
	@StampUser varchar(50),
	@PolicyBusinessId bigint,
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null	   
AS
DECLARE @IsMortgageUser bit, @ExtId bigint
-- Only update fields for mortgage users
SET @IsMortgageUser = Administration.dbo.FnIsMortgageUser(@StampUser)
IF @IsMortgageUser = 0
	RETURN;
	
-- Get ext Id
SELECT @ExtId = PolicyBusinessExtId FROM PolicyManagement..TPolicyBusinessExt WHERE PolicyBusinessId = @PolicyBusinessId	
		
-- Audit
EXEC PolicyManagement..SpNAuditPolicyBusinessExt @StampUser, @ExtId, 'U'		
	
-- Update
UPDATE PolicyManagement..TPolicyBusinessExt
SET 
	MortgageRepayPercentage = @MortgageRepayPercentage,
	MortgageRepayAmount = @MortgageRepayAmount,
	ConcurrencyId = ConcurrencyId + 1
WHERE
	PolicyBusinessExtId = @ExtId
GO
