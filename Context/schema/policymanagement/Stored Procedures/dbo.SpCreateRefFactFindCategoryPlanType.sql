SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRefFactFindCategoryPlanType]
	@StampUser varchar (255),
	@Category varchar(24)  = NULL, 
	@RefFactFindCategoryId bigint = NULL, 
	@RefPlanTypeId bigint = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @RefFactFindCategoryPlanTypeId bigint
			
	
	INSERT INTO TRefFactFindCategoryPlanType (
		Category, 
		RefFactFindCategoryId, 
		RefPlanTypeId, 
		ConcurrencyId)
		
	VALUES(
		@Category, 
		@RefFactFindCategoryId, 
		@RefPlanTypeId,
		1)

	SELECT @RefFactFindCategoryPlanTypeId = SCOPE_IDENTITY()

	INSERT INTO TRefFactFindCategoryPlanTypeAudit (
		Category, 
		RefFactFindCategoryId, 
		RefPlanTypeId, 
		ConcurrencyId,
		RefFactFindCategoryPlanTypeId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		Category, 
		RefFactFindCategoryId, 
		RefPlanTypeId, 
		ConcurrencyId,
		RefFactFindCategoryPlanTypeId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TRefFactFindCategoryPlanType
	WHERE RefFactFindCategoryPlanTypeId = @RefFactFindCategoryPlanTypeId

	EXEC SpRetrieveRefFactFindCategoryPlanTypeById @RefFactFindCategoryPlanTypeId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
