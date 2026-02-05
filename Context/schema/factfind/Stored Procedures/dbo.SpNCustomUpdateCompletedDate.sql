SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateCompletedDate]
	@StampUser varchar (255),
	@CRMContactId bigint
	
AS

BEGIN
DECLARE @DeclarationId bigint,@RefSystemEvent varchar(255),@CompletedDate datetime
SELECT @RefSystemEvent='Date Fact Find Completed',@CompletedDate=GETDATE()
SELECT @DeclarationId=DeclarationId FROM FactFind..TDeclaration WHERE CRMContactId=@CRMContactId
IF ISNULL(@DeclarationId,0)>0
BEGIN
	EXEC FactFind..SpNAuditDeclaration @StampUser,@DeclarationId,'U'

	UPDATE FactFind..TDeclaration
	SET CompletedDate=@CompletedDate,ConcurrencyId=ConcurrencyId + 1
	WHERE CRMContactId=@CRMContactId
END
ELSE
BEGIN
	INSERT FactFind..TDeclaration(CRMContactId,CompletedDate,ConcurrencyId)
	SELECT @CRMContactId,@CompletedDate,1

	SELECT @DeclarationId=SCOPE_IDENTITY()

	EXEC FactFind..SpNAuditDeclaration @StampUser,@DeclarationId,'C'
END

--Now create the task
EXEC FactFind..SpNCustomManageFactFindEvent @StampUser,@CRMContactId,@RefSystemEvent,@CompletedDate,1

END
GO
