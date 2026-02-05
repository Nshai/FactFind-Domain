SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateNonFeedFund]
@StampUser varchar (255),
@FundTypeId int,
@FundTypeName varchar (50),
@FundName varchar (1000),
@CompanyId bigint = NULL,
@CompanyName varchar (255) = NULL,
@CategoryId bigint = NULL,
@CategoryName varchar (50) = NULL,
@Sedol varchar (50) = NULL,
@MexId varchar (50) = NULL,
@IndigoClientId bigint,
@CurrentPrice float = NULL,
@PriceDate datetime = NULL,
@PriceUpdatedByUser varchar (255) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @NonFeedFundId bigint

  INSERT INTO TNonFeedFund (
    FundTypeId, 
    FundTypeName, 
    FundName, 
    CompanyId, 
    CompanyName, 
    CategoryId, 
    CategoryName, 
    Sedol, 
    MexId, 
    IndigoClientId, 
    CurrentPrice, 
    PriceDate, 
    PriceUpdatedByUser, 
    ConcurrencyId ) 
  VALUES (
    @FundTypeId, 
    @FundTypeName, 
    @FundName, 
    @CompanyId, 
    @CompanyName, 
    @CategoryId, 
    @CategoryName, 
    @Sedol, 
    @MexId, 
    @IndigoClientId, 
    @CurrentPrice, 
    @PriceDate, 
    @PriceUpdatedByUser, 
    1) 

  SELECT @NonFeedFundId = SCOPE_IDENTITY()
  INSERT INTO TNonFeedFundAudit (
    FundTypeId, 
    FundTypeName, 
    FundName, 
    CompanyId, 
    CompanyName, 
    CategoryId, 
    CategoryName, 
    Sedol, 
    MexId, 
    IndigoClientId, 
    CurrentPrice, 
    PriceDate, 
    PriceUpdatedByUser, 
    ConcurrencyId,
    NonFeedFundId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.FundTypeId, 
    T1.FundTypeName, 
    T1.FundName, 
    T1.CompanyId, 
    T1.CompanyName, 
    T1.CategoryId, 
    T1.CategoryName, 
    T1.Sedol, 
    T1.MexId, 
    T1.IndigoClientId, 
    T1.CurrentPrice, 
    T1.PriceDate, 
    T1.PriceUpdatedByUser, 
    T1.ConcurrencyId,
    T1.NonFeedFundId,
    'C',
    GetDate(),
    @StampUser

  FROM TNonFeedFund T1
 WHERE T1.NonFeedFundId=@NonFeedFundId
  EXEC SpRetrieveNonFeedFundById @NonFeedFundId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
