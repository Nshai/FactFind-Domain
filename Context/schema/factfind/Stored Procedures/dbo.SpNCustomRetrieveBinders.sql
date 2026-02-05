SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveBinders]
	@CRMContactId bigint,
	@CRMContactId2 bigint
AS
-- NOTE: Union All faster than a single where clause containing OR statements
-- These are Binders for the primary client only
SELECT
	B.BinderId,
	B.[Description]	
FROM
	DocumentManagement..TBinder B
	JOIN DocumentManagement..TRefBinderStatus RBS ON RBS.RefBinderStatusId = B.RefBinderStatusId
WHERE 	
	@CRMContactId2 = 0
	AND RBS.LockedFg = 0
	AND CRMContactId = @CRMContactId AND Owner2PartyId IS NULL

-- These are joint binders (client1/client2)
UNION ALL
SELECT
	B.BinderId,
	B.[Description]	
FROM
	DocumentManagement..TBinder B
	JOIN DocumentManagement..TRefBinderStatus RBS ON RBS.RefBinderStatusId = B.RefBinderStatusId
WHERE 	
	@CRMContactId2 != 0
	AND RBS.LockedFg = 0
	AND CRMContactId = @CRMContactId AND Owner2PartyId = @CRMContactId2

-- These are joint binders (client2/client1)
UNION ALL
SELECT
	B.BinderId,
	B.[Description]	
FROM
	DocumentManagement..TBinder B
	JOIN DocumentManagement..TRefBinderStatus RBS ON RBS.RefBinderStatusId = B.RefBinderStatusId
WHERE 	
	@CRMContactId2 != 0
	AND RBS.LockedFg = 0
	AND CRMContactId = @CRMContactId2 AND Owner2PartyId = @CRMContactId
GO
