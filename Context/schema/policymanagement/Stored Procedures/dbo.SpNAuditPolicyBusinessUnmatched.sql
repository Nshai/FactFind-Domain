SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyBusinessUnmatched]
	@StampUser varchar (255),
	@PolicyBusinessUnmatchedId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessUnmatchedAudit 
( 
  PolicyBusinessUnmatchedId,
  PolicyBusinessId, 
  TenantId, 
  AddressLine1, 
  AddressLine2, 
  AddressLine3, 
  AddressLine4, 
  CityTown, 
  Postcode, 
  CountryId, 
  CountyId,
  AdviserName,
  CreatedAt,
  ChangedAt,
  MatchedAt,
  MatchedByUserId,
  StampAction,
  StampDateTime,
  StampUser
 ) 
Select 
  PolicyBusinessUnmatchedId,
  PolicyBusinessId, 
  TenantId, 
  AddressLine1, 
  AddressLine2, 
  AddressLine3, 
  AddressLine4, 
  CityTown, 
  Postcode, 
  CountryId, 
  CountyId,
  AdviserName,
  CreatedAt,
  ChangedAt,
  MatchedAt,
  MatchedByUserId, 
  @StampAction, 
  GetDate(), 
  @StampUser
FROM TPolicyBusinessUnmatched
WHERE PolicyBusinessUnmatchedId = @PolicyBusinessUnmatchedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO