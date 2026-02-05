SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateOpportunityType]
	@StampUser varchar (255),
	@OpportunityTypeName varchar(255) , 
	@IndigoClientId bigint, 
	@ArchiveFG bit = 0, 
	@SystemFG bit = 0, 
	@InvestmentDefault bit = 0, 
	@RetirementDefault bit = 0	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @OpportunityTypeId bigint
			
	
	INSERT INTO TOpportunityType (
		OpportunityTypeName, 
		IndigoClientId, 
		ArchiveFG, 
		SystemFG, 
		InvestmentDefault, 
		RetirementDefault, 
		ConcurrencyId)
		
	VALUES(
		@OpportunityTypeName, 
		@IndigoClientId, 
		@ArchiveFG, 
		@SystemFG, 
		@InvestmentDefault, 
		@RetirementDefault,
		1)

	SELECT @OpportunityTypeId = SCOPE_IDENTITY()
	
	INSERT INTO TOpportunityTypeAudit (
		OpportunityTypeName, 
		IndigoClientId, 
		ArchiveFG, 
		SystemFG, 
		InvestmentDefault, 
		RetirementDefault, 
		ConcurrencyId,
		OpportunityTypeId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		OpportunityTypeName, 
		IndigoClientId, 
		ArchiveFG, 
		SystemFG, 
		InvestmentDefault, 
		RetirementDefault, 
		ConcurrencyId,
		OpportunityTypeId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TOpportunityType
	WHERE OpportunityTypeId = @OpportunityTypeId
	EXEC SpRetrieveOpportunityTypeById @OpportunityTypeId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
