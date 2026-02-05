SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValProviderIndigoClientFrequency]
	@StampUser varchar (255),
	@RefProdProviderId bigint, 
	@IndigoClientId bigint, 
	@AllowDaily tinyint, 
	@AllowWeekly tinyint, 
	@AllowFortnightly tinyint, 
	@AllowMonthly tinyint, 
	@AllowBiAnnually tinyint, 
	@AllowQuarterly tinyint, 
	@AllowHalfYearly tinyint, 
	@AllowAnnually tinyint	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ValProviderIndigoClientFrequencyId bigint
			
	
	INSERT INTO TValProviderIndigoClientFrequency (
		RefProdProviderId, 
		IndigoClientId, 
		AllowDaily, 
		AllowWeekly, 
		AllowFortnightly, 
		AllowMonthly, 
		AllowBiAnnually, 
		AllowQuarterly, 
		AllowHalfYearly, 
		AllowAnnually, 
		ConcurrencyId)
		
	VALUES(
		@RefProdProviderId, 
		@IndigoClientId, 
		@AllowDaily, 
		@AllowWeekly, 
		@AllowFortnightly, 
		@AllowMonthly, 
		@AllowBiAnnually, 
		@AllowQuarterly, 
		@AllowHalfYearly, 
		@AllowAnnually,
		1)

	SELECT @ValProviderIndigoClientFrequencyId = SCOPE_IDENTITY()
	
	INSERT INTO TValProviderIndigoClientFrequencyAudit (
		RefProdProviderId, 
		IndigoClientId, 
		AllowDaily, 
		AllowWeekly, 
		AllowFortnightly, 
		AllowMonthly, 
		AllowBiAnnually, 
		AllowQuarterly, 
		AllowHalfYearly, 
		AllowAnnually, 
		ConcurrencyId,
		ValProviderIndigoClientFrequencyId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		RefProdProviderId, 
		IndigoClientId, 
		AllowDaily, 
		AllowWeekly, 
		AllowFortnightly, 
		AllowMonthly, 
		AllowBiAnnually, 
		AllowQuarterly, 
		AllowHalfYearly, 
		AllowAnnually, 
		ConcurrencyId,
		ValProviderIndigoClientFrequencyId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TValProviderIndigoClientFrequency
	WHERE ValProviderIndigoClientFrequencyId = @ValProviderIndigoClientFrequencyId
	EXEC SpRetrieveValProviderIndigoClientFrequencyById @ValProviderIndigoClientFrequencyId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
