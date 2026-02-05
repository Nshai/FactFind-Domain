 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValBulkQ 
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement;

-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A81C6E18-F7AC-4690-966E-19FD869BB925'
) RETURN 
 
DELETE PP
FROM        dbo.TValPotentialPlan   PP
LEFT JOIN   dbo.TPolicyBusiness     PB
ON pb.PolicyBusinessId = PP.PolicyBusinessId
WHERE
    pb.IndigoClientId IS NULL -- 3853 rows in 12s

DELETE SP
FROM        dbo.TValScheduledPlan   SP
LEFT JOIN   dbo.TPolicyBusiness     PB
ON pb.PolicyBusinessId = SP.PolicyBusinessId
WHERE
    pb.IndigoClientId IS NULL -- 4456 rows in 7s

DELETE Q
FROM        dbo.TValBulkQ       Q
LEFT JOIN   dbo.TPolicyBusiness PB
ON pb.PolicyBusinessId = Q.PolicyBusinessId
WHERE
    pb.IndigoClientId IS NULL
AND Q.xflag = 0
AND q.PlanUpdateBreaker = 0
AND Q.PlanMatched = 1 -- 743 rows in 1s
 
-- record execution so the script won't run again
INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
VALUES (
    'A81C6E18-F7AC-4690-966E-19FD869BB925', 
    'DEF-2604 - Remove orphan TValBulkQ on PolicyBusinessId for Ascot Lloyd',
    null, 
    getdate() )
 

-----------------------------------------------------------------------------
-- #Rows Deleted: 743 1s
-----------------------------------------------------------------------------