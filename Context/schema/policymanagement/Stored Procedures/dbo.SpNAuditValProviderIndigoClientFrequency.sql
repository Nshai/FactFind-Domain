SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValProviderIndigoClientFrequency]
	@StampUser varchar (255),
	@ValProviderIndigoClientFrequencyId bigint,
	@StampAction char(1)
AS

INSERT INTO TValProviderIndigoClientFrequencyAudit 
( RefProdProviderId, IndigoClientId, AllowDaily, AllowWeekly, 
		AllowFortnightly, AllowMonthly, AllowBiAnnually, AllowQuarterly, 
		AllowHalfYearly, AllowAnnually, ConcurrencyId, 
	ValProviderIndigoClientFrequencyId, StampAction, StampDateTime, StampUser) 
Select RefProdProviderId, IndigoClientId, AllowDaily, AllowWeekly, 
		AllowFortnightly, AllowMonthly, AllowBiAnnually, AllowQuarterly, 
		AllowHalfYearly, AllowAnnually, ConcurrencyId, 
	ValProviderIndigoClientFrequencyId, @StampAction, GetDate(), @StampUser
FROM TValProviderIndigoClientFrequency
WHERE ValProviderIndigoClientFrequencyId = @ValProviderIndigoClientFrequencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
