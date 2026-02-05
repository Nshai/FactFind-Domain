SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomUpdatePolicyBusinessFundUnits]
@PolicyBusinessFundId bigint

as 

DECLARE @LastDate datetime
DECLARE @TotalUnits money

set @LastDate = (select max(transactiondate) from tpolicybusinessfundtransaction where PolicyBusinessFundId = @PolicyBusinessFundId)
set @TotalUnits = (select sum(UnitQuantity) from tpolicybusinessfundtransaction where PolicyBusinessFundId = @PolicyBusinessFundId)

UPDATE TPolicyBusinessFund
set LastUnitChangeDate = @LastDate,
CurrentUnitQuantity = @TotalUnits
WHERE PolicyBusinessFundId = @PolicyBusinessFundId
GO
