SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_FixDuplicateStatusHistory]
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @StampDateTime datetime = GETDATE()
-------------------------------------------------------------
-- Example data..
-------------------------------------------------------------
-- StatusHistoryId|PolicyBusinessId|StatusId|CurrentStatusFg
-- 10|22|1098|0
-- 11|22|1090|0
-- 12|22|1091|1  <- This is a sequential pair by statusid
-- 13|22|1091|1  <- We'll delete this record

-- 30|23|1098|0
-- 31|23|1090|0
-- 32|23|1091|1  <- We'll update this so it's not current
-- 33|23|1092|1  <- We'll keep this as current

-------------------------------------------------------------
-- Find plans that have duplicated current status
-------------------------------------------------------------
SELECT PolicyBusinessId AS Id
INTO #PlanList
FROM TStatusHistory
WHERE CurrentStatusFg = 1
GROUP BY PolicyBusinessId
HAVING COUNT(1) > 1

-------------------------------------------------------------
-- Get some extra details about the status for these plans
-------------------------------------------------------------
SELECT 
	PolicyBusinessId AS Id,
	MIN(StatusHistoryId) AS FirstId,
	MAX(StatusHistoryId) AS LastId,
	COUNT(1) AS NumberOfDuplicates,
	COUNT(DISTINCT StatusId) AS NumberOfStatuses
INTO #Plans
FROM 
	TStatusHistory S
	JOIN #PlanList P ON P.Id = S.PolicyBusinessId
WHERE CurrentStatusFg = 1
GROUP BY PolicyBusinessId

-------------------------------------------------------------
-- Find plans that only have duplicates for a single status
-------------------------------------------------------------
SELECT Id, FirstId, LastId
INTO #PlansWithOneStatus
FROM #Plans
WHERE NumberOfStatuses = 1

-------------------------------------------------------------
-- Remove any plans if there's a break between duplicates
-------------------------------------------------------------
DELETE A
FROM
	#PlansWithOneStatus A
	JOIN TStatusHistory S ON S.PolicyBusinessId = A.Id
WHERE
	S.StatusHistoryId BETWEEN A.FirstId AND A.LastId
	AND S.CurrentStatusFG = 0

-------------------------------------------------------------
-- Delete status history records for these plans
-- We'll just keep the first status history record
-------------------------------------------------------------
DELETE S
OUTPUT deleted.PolicyBusinessId, deleted.StatusId, deleted.StatusReasonId, deleted.ChangedToDate, deleted.ChangedByUserId, deleted.DateOfChange, deleted.LifeCycleStepFG, deleted.CurrentStatusFG, deleted.ConcurrencyId, deleted.StatusHistoryId, 'D', @StampDateTime, 0, deleted.PlanMigrationRef
INTO TStatusHistoryAudit (PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId, DateOfChange, LifeCycleStepFG, CurrentStatusFG, ConcurrencyId, StatusHistoryId, StampAction, StampDateTime, StampUser, PlanMigrationRef)
FROM
	TStatusHistory S
	JOIN #PlansWithOneStatus P ON P.Id = S.PolicyBusinessId
WHERE
	S.CurrentStatusFG = 1
	AND S.StatusHistoryId != P.FirstId

-------------------------------------------------------------
-- Find remaining plans that we need to update, these
-- will have duplicates across more that one status
-------------------------------------------------------------
DELETE A
FROM
	#Plans A
	JOIN #PlansWithOneStatus B ON B.Id = A.Id

-------------------------------------------------------------
-- Now update Status History
-- We'll leave the latest status history as current
-------------------------------------------------------------
UPDATE S
SET CurrentStatusFG = 0
OUTPUT deleted.PolicyBusinessId, deleted.StatusId, deleted.StatusReasonId, deleted.ChangedToDate, deleted.ChangedByUserId, deleted.DateOfChange, deleted.LifeCycleStepFG, deleted.CurrentStatusFG, deleted.ConcurrencyId, deleted.StatusHistoryId, 'U', @StampDateTime, 0, deleted.PlanMigrationRef
INTO TStatusHistoryAudit (PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId, DateOfChange, LifeCycleStepFG, CurrentStatusFG, ConcurrencyId, StatusHistoryId, StampAction, StampDateTime, StampUser, PlanMigrationRef)
FROM
	TStatusHistory S
	JOIN #Plans P ON P.Id = S.PolicyBusinessId
WHERE
	S.CurrentStatusFG = 1
	AND S.StatusHistoryId != P.LastId
GO
