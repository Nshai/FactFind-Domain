SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateDpGuid]
	@StampUser varchar (255),
	@EntityId bigint, 
	@DpGuidTypeId bigint, 
	@Guid uniqueidentifier = null
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	IF @Guid IS NULL SELECT @Guid = NewId()	
	DECLARE @DpGuidId bigint
			
	
	INSERT INTO TDpGuid (
		EntityId, 
		DpGuidTypeId, 
		Guid, 
		ConcurrencyId)
		
	VALUES(
		@EntityId, 
		@DpGuidTypeId, 
		@Guid,
		1)

	SELECT @DpGuidId = SCOPE_IDENTITY()

	INSERT INTO TDpGuidAudit (
		EntityId, 
		DpGuidTypeId, 
		Guid, 
		ConcurrencyId,
		DpGuidId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		EntityId, 
		DpGuidTypeId, 
		Guid, 
		ConcurrencyId,
		DpGuidId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TDpGuid
	WHERE DpGuidId = @DpGuidId

	EXEC SpRetrieveDpGuidById @DpGuidId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
