SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRefRelationshipTypeLink]
@StampUser varchar (255),
@RefRelTypeId bigint,
@RefRelCorrespondTypeId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @RefRelationshipTypeLinkId bigint

  INSERT INTO TRefRelationshipTypeLink (
    RefRelTypeId, 
    RefRelCorrespondTypeId, 
    ConcurrencyId ) 
  VALUES (
    @RefRelTypeId, 
    @RefRelCorrespondTypeId, 
    1) 

  SELECT @RefRelationshipTypeLinkId = SCOPE_IDENTITY()
  INSERT INTO TRefRelationshipTypeLinkAudit (
    RefRelTypeId, 
    RefRelCorrespondTypeId, 
    ConcurrencyId,
    RefRelationshipTypeLinkId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.RefRelTypeId, 
    T1.RefRelCorrespondTypeId, 
    T1.ConcurrencyId,
    T1.RefRelationshipTypeLinkId,
    'C',
    GetDate(),
    @StampUser

  FROM TRefRelationshipTypeLink T1
 WHERE T1.RefRelationshipTypeLinkId=@RefRelationshipTypeLinkId
  EXEC SpRetrieveRefRelationshipTypeLinkById @RefRelationshipTypeLinkId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)








GO
