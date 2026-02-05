SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddClientToFactFind]
@StampUser varchar(255),
@FactFindId bigint,
@CRMContactId2 bigint
AS

DECLARE @PriorFactFindId bigint, @ConcurrencyId int

-- Add 'bloody audit' record
INSERT INTO TFactFindAudit(
	FactFindId, CRMContactId1, CRMContactId2, FactFindTypeId, IndigoClientId, ConcurrencyId, StampAction, StampDateTime, StampUser)
SELECT
	FactFindId, CRMContactId1, CRMContactId2, FactFindTypeId, IndigoClientId, ConcurrencyId, 'U', GETDATE(), @StampUser
FROM
	TFactFind
WHERE
	FactFindId = @FactFindId
	
-- Add CrmContactId as client 2 on to this FactFind
UPDATE 
	TFactFind 
SET 
	CRMContactId2 = @CrmContactId2, 
	ConcurrencyId = ConcurrencyId + 1
WHERE 
	FactFindId = @FactFindId

-- Get the Id of any existing FactFind for this client
SELECT 
	@PriorFactFindId = FactFindId,
	@ConcurrencyId = ConcurrencyId
FROM 
	TFactFind 
WHERE 
	CRMContactId1 = @CRMContactId2

IF @PriorFactFindId IS NOT NULL
	EXEC SpNDeleteFactFind @PriorFactFindId, @ConcurrencyId, @StampUser
GO
