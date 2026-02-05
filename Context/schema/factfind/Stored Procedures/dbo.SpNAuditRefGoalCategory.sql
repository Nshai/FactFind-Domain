SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditRefGoalCategory]
	@StampUser varchar (255),
	@RefGoalCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO 
	[TRefGoalCategoryAudit] 
	( Name 
	, RefGoalCategoryId
	, ConcurrencyId 
	, StampAction
	, StampDateTime
	, StampUser
	,Ordinal)
SELECT  
	Name 
	, RefGoalCategoryId
	, ConcurrencyId
	, @StampAction
	, GetDate()
	, @StampUser
	,Ordinal
FROM 
	TRefGoalCategory
WHERE 
	RefGoalCategoryId = @RefGoalCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
