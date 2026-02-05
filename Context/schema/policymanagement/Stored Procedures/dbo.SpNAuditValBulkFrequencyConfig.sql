SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValBulkFrequencyConfig]
	@StampUser varchar (255),
	@ValBulkFrequencyConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TValBulkFrequencyConfigAudit
     ( [ValuationProviderId]
           ,[AllowDaily]
           ,[AllowWeekly]
           ,[AllowFortnightly]
           ,[AllowMonthly]
           ,[AllowBiAnnually]
           ,[AllowQuarterly]
           ,[AllowHalfYearly]
           ,[AllowAnnually]
           ,[ConcurrencyId], [ValBulkFrequencyConfigId]
		   ,[StampAction],[StampDateTime],[StampUser]) 
Select     [ValuationProviderId]
           ,[AllowDaily]
           ,[AllowWeekly]
           ,[AllowFortnightly]
           ,[AllowMonthly]
           ,[AllowBiAnnually]
           ,[AllowQuarterly]
           ,[AllowHalfYearly]
           ,[AllowAnnually]
           ,[ConcurrencyId], [ValBulkFrequencyConfigId]
		   , @StampAction, GetDate(), @StampUser
FROM TValBulkFrequencyConfig
WHERE ValBulkFrequencyConfigId = @ValBulkFrequencyConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
