SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomUpdatePolicyBusinessFundUnits]
	(
		@PolicyBusinessFundId bigint
	)

AS

begin

DECLARE @LastDate datetime
DECLARE @TotalUnits money

set @LastDate = (select max(transactiondate) from tpolicybusinessfundtransaction where PolicyBusinessFundId = @PolicyBusinessFundId)
set @TotalUnits = (select sum(UnitQuantity) from tpolicybusinessfundtransaction where PolicyBusinessFundId = @PolicyBusinessFundId)

UPDATE TPolicyBusinessFund
set LastUnitChangeDate = @LastDate, CurrentUnitQuantity = @TotalUnits
WHERE PolicyBusinessFundId = @PolicyBusinessFundId

SELECT 1

end
GO
