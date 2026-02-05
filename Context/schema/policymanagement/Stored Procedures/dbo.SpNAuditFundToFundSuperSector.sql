SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditFundToFundSuperSector
	@StampUser varchar (255),
	@FundToFundSuperSectorId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TFundToFundSuperSectorAudit]
           ([FundId]
           ,[FundSuperSectorId]
           ,[IsFromFeed]
           ,[IsEquity]
           ,[ConcurrencyId]
           ,[FundToFundSuperSectorId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
 SELECT [FundId]
       ,[FundSuperSectorId]
       ,[IsFromFeed]
       ,[IsEquity]
       ,[ConcurrencyId]
       ,[FundToFundSuperSectorId]
       ,@StampAction
	   ,GetDate()
       ,'0'	
 FROM [PolicyManagement].[dbo].[TFundToFundSuperSector]
 where FundToFundSuperSectorId = @FundToFundSuperSectorId;

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)

GO
