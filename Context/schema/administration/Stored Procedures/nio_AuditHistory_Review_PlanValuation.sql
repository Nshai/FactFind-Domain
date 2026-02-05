SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AuditHistory_Review_PlanValuation]
	@TenantId int,
	@Id bigint,
	@Database varchar(32),
	@Table varchar(128)
AS

--2020-09-02 KK
--copied from nio_AuditHistory_Review and has tailored it for TPlanValuation
--this is to relay audits in UI on Planvaluation page
--This is a workaround as we wanted to purge all 'C' records from TPlanValuationAudit table to help trimming it

DECLARE @TableId int, @AuditTable sysname,  @MainTable sysname
----------------------------------------------------------------
-- Data checks
----------------------------------------------------------------
SET @Database = REPLACE(@Database, '''', '')
SET @Table = REPLACE(@Table, '''', '')

IF LEN(ISNULL(@Database, '')) = 0
	THROW 50001, 'DB not specified', 1;

IF LEN(ISNULL(@Table, '')) = 0
	THROW 50001, 'Table not specified', 1;

----------------------------------------------------------------
-- Check DB is valid
----------------------------------------------------------------
IF DB_ID(@Database) IS NULL
	THROW 50001, 'Unknown DB', 1;

----------------------------------------------------------------
-- Set up DB, Table name and Id column information
----------------------------------------------------------------
SET @MainTable = 'T' + @Table
SET @AuditTable = 'T' + @Table + 'Audit'

----------------------------------------------------------------
-- Check Table is valid
----------------------------------------------------------------
SET @TableId = OBJECT_ID(@Database + '.dbo.' + @MainTable, 'U');
IF @TableId IS NULL
	THROW 50001, 'Unknown Main Table ', 1;

SET @TableId = OBJECT_ID(@Database + '.dbo.' + @AuditTable, 'U');
IF @TableId IS NULL
	THROW 50001, 'Unknown Audit Table ', 1;
	
----------------------------------------------------------------
-- Retrieve audit data
----------------------------------------------------------------
SELECT
	abs(cast(cast(newid() as varbinary) as int)), --random unique number
	U.Identifier AS UserName,
	U.Email AS UserEmail,
	'C',
	m.whoupdateddatetime
FROM policymanagement..tplanvaluation m
	JOIN administration..TUser U ON m.WhoUpdatedValue = u.userid
WHERE
	m.PlanValuationId = @Id
	AND U.IndigoClientId = @TenantId
union
SELECT
	abs(cast(cast(newid() as varbinary) as int)), --random unique number
	U.Identifier AS UserName,
	U.Email AS UserEmail,
	a.StampAction,
	a.StampDateTime
FROM policymanagement..TPlanValuationAudit a
	JOIN administration..TUser U ON a.StampUser = u.userid
WHERE
	a.PlanValuationId = @Id
	AND U.IndigoClientId = @TenantId
	and a.StampAction <> 'C'
