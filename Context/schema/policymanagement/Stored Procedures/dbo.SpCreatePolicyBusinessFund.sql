SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreatePolicyBusinessFund]
@StampUser varchar (255),
@PolicyBusinessId bigint,
@FundId bigint,
@FundTypeId int = NULL,
@FundName varchar (255) = NULL,
@CategoryId bigint = NULL,
@CategoryName varchar (50) = NULL,
@CurrentUnitQuantity money = NULL,
@LastUnitChangeDate datetime = NULL,
@CurrentPrice money = NULL,
@LastPriceChangeDate datetime = NULL,
@PriceUpdatedByUser varchar (255) = NULL,
@FromFeedFg bit = 0,
@FundIndigoClientId bigint = NULL,
@InvestmentTypeId bigint = NULL,
@RiskRating int = NULL,
@EquityFg bit = 0
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PolicyBusinessFundId bigint

  INSERT INTO TPolicyBusinessFund (
    PolicyBusinessId, 
    FundId, 
    FundTypeId, 
    FundName, 
    CategoryId, 
    CategoryName, 
    CurrentUnitQuantity, 
    LastUnitChangeDate, 
    CurrentPrice, 
    LastPriceChangeDate, 
    PriceUpdatedByUser, 
    FromFeedFg, 
    FundIndigoClientId, 
    InvestmentTypeId, 
    RiskRating, 
    EquityFg, 
    ConcurrencyId ) 
  VALUES (
    @PolicyBusinessId, 
    @FundId, 
    @FundTypeId, 
    @FundName, 
    @CategoryId, 
    @CategoryName, 
    @CurrentUnitQuantity, 
    @LastUnitChangeDate, 
    @CurrentPrice, 
    @LastPriceChangeDate, 
    @PriceUpdatedByUser, 
    @FromFeedFg, 
    @FundIndigoClientId, 
    @InvestmentTypeId, 
    @RiskRating, 
    @EquityFg, 
    1) 

  SELECT @PolicyBusinessFundId = SCOPE_IDENTITY()
  INSERT INTO TPolicyBusinessFundAudit (
    PolicyBusinessId, 
    FundId, 
    FundTypeId, 
    FundName, 
    CategoryId, 
    CategoryName, 
    CurrentUnitQuantity, 
    LastUnitChangeDate, 
    CurrentPrice, 
    LastPriceChangeDate, 
    PriceUpdatedByUser, 
    FromFeedFg, 
    FundIndigoClientId, 
    InvestmentTypeId, 
    RiskRating, 
    EquityFg, 
    ConcurrencyId,
    PolicyBusinessFundId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PolicyBusinessId, 
    T1.FundId, 
    T1.FundTypeId, 
    T1.FundName, 
    T1.CategoryId, 
    T1.CategoryName, 
    T1.CurrentUnitQuantity, 
    T1.LastUnitChangeDate, 
    T1.CurrentPrice, 
    T1.LastPriceChangeDate, 
    T1.PriceUpdatedByUser, 
    T1.FromFeedFg, 
    T1.FundIndigoClientId, 
    T1.InvestmentTypeId, 
    T1.RiskRating, 
    T1.EquityFg, 
    T1.ConcurrencyId,
    T1.PolicyBusinessFundId,
    'C',
    GetDate(),
    @StampUser

  FROM TPolicyBusinessFund T1
 WHERE T1.PolicyBusinessFundId=@PolicyBusinessFundId
  EXEC SpRetrievePolicyBusinessFundById @PolicyBusinessFundId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
