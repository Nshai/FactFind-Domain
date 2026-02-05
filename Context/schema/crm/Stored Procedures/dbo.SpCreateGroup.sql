SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateGroup]
@StampUser varchar (255),
@IndClientId bigint = NULL,
@RefGroupTypeId bigint = NULL,
@Name varchar (50) = NULL,
@CRMContactId bigint = NULL,
@Reference varchar (50) = NULL,
@ParentGroupId bigint = NULL,
@RetiredFG tinyint = NULL,
@Notes varchar (2000) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @GroupId bigint

  INSERT INTO TGroup (
    IndClientId, 
    RefGroupTypeId, 
    Name, 
    CRMContactId, 
    Reference, 
    ParentGroupId, 
    RetiredFG, 
    Notes, 
    ConcurrencyId ) 
  VALUES (
    @IndClientId, 
    @RefGroupTypeId, 
    @Name, 
    @CRMContactId, 
    @Reference, 
    @ParentGroupId, 
    @RetiredFG, 
    @Notes, 
    1) 

  SELECT @GroupId = SCOPE_IDENTITY()
  INSERT INTO TGroupAudit (
    IndClientId, 
    RefGroupTypeId, 
    Name, 
    CRMContactId, 
    Reference, 
    ParentGroupId, 
    RetiredFG, 
    Notes, 
    ConcurrencyId,
    GroupId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndClientId, 
    T1.RefGroupTypeId, 
    T1.Name, 
    T1.CRMContactId, 
    T1.Reference, 
    T1.ParentGroupId, 
    T1.RetiredFG, 
    T1.Notes, 
    T1.ConcurrencyId,
    T1.GroupId,
    'C',
    GetDate(),
    @StampUser

  FROM TGroup T1
 WHERE T1.GroupId=@GroupId
  EXEC SpRetrieveGroupById @GroupId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)








GO
