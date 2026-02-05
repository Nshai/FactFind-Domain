SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRelationship]
	@StampUser varchar (255),
	@RelationshipId bigint,
	@StampAction char(1)
AS

INSERT INTO TRelationshipAudit 
            (RefRelTypeId, 
             RefRelCorrespondTypeId, 
             CRMContactFromId, 
             CRMContactToId, 
             ExternalContact, 
             ExternalURL, 
             OtherRelationship, 
             IsPartnerFg, 
             IsFamilyFg, 
             IsPointOfContactFg, 
             IncludeInPfp, 
			 ReceivedAccessType, 
	         ReceivedAccessAt, 
             ReceivedAccessByUserId, 
             GivenAccessType, 
             GivenAccessAt, 
             GivenAccessByUserId, 
             ConcurrencyId, 
             RelationshipId, 
             StampAction, 
             StampDateTime, 
             StampUser, 
             StartedAt) 
SELECT RefRelTypeId, 
       RefRelCorrespondTypeId, 
       CRMContactFromId, 
       CRMContactToId, 
       ExternalContact, 
       ExternalURL, 
       OtherRelationship, 
       IsPartnerFg, 
       IsFamilyFg, 
       IsPointOfContactFg, 
       IncludeInPfp, 
       ReceivedAccessType, 
	   ReceivedAccessAt, 
       ReceivedAccessByUserId, 
       GivenAccessType, 
       GivenAccessAt, 
       GivenAccessByUserId, 
       ConcurrencyId, 
       RelationshipId, 
       @StampAction, 
       Getdate(), 
       @StampUser,
       StartedAt
FROM   TRelationship 
WHERE  RelationshipId = @RelationshipId 

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
