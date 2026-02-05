SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyBusinessUnmatchedOwners]
	@StampUser varchar (255),
	@PolicyBusinessUnmatchedOwnersId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessUnmatchedOwnersAudit
( 
  PolicyBusinessUnmatchedOwnersId, 
  PolicyBusinessUnmatchedId, 
  FirstName, 
  LastName, 
  Name, 
  ExternalReference,
  Role,
  Status,
  StampAction,
  StampDateTime,
  StampUser
 ) 
Select 
  PolicyBusinessUnmatchedOwnersId, 
  PolicyBusinessUnmatchedId,  
  FirstName, 
  LastName, 
  Name, 
  ExternalReference,
  Role,
  Status,
  @StampAction, 
  GetDate(), 
  @StampUser
FROM TPolicyBusinessUnmatchedOwners
WHERE PolicyBusinessUnmatchedOwnersId = @PolicyBusinessUnmatchedOwnersId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO