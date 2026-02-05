SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateMembership]
@StampUser varchar (255),
@UserId bigint,
@RoleId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @MembershipId bigint

  INSERT INTO TMembership (
    UserId, 
    RoleId, 
    ConcurrencyId ) 
  VALUES (
    @UserId, 
    @RoleId, 
    1) 

  SELECT @MembershipId = SCOPE_IDENTITY()
  INSERT INTO TMembershipAudit (
    UserId, 
    RoleId, 
    ConcurrencyId,
    MembershipId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.UserId, 
    T1.RoleId, 
    T1.ConcurrencyId,
    T1.MembershipId,
    'C',
    GetDate(),
    @StampUser

  FROM TMembership T1
 WHERE T1.MembershipId=@MembershipId
  EXEC SpRetrieveMembershipById @MembershipId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
