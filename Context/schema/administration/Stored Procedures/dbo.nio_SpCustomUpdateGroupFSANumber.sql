SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomUpdateGroupFSANumber]
	(
		@GroupId bigint,
		@StampUser varchar(255),
		@FSARegNbr varchar(50),
		@SaveOption int
	)
AS

begin
--*****************************************************************************************************************
--Objective
--		To update Administration..Tgroup records with FSA number depending upon the @SaveOption switch
--			Where in @SaveOption could be either of the following
--				1 - This group only
--				2 - All groups below this group
--				3 - All Groups
--
--Created On : 23/March/2011
--Created By : Krishnan
--
--Revision History
--
--*****************************************************************************************************************

SET NOCOUNT ON
DECLARE @TenantId bigint
DECLARE @GroupsUpdated bigint
DECLARE @ParentId bigint

SELECT @TenantId = IndigoClientId, @ParentId = ParentId FROM TGroup WHERE GroupId = @GroupId

SET @GroupsUpdated = 0

IF @SaveOption = 1 --this group only
	BEGIN
		--audit
		INSERT INTO TGroupAudit 
				(Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,
					FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,FSARegNbr,ConcurrencyId,GroupId,StampAction,StampDateTime,StampUser)
		SELECT 
				Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,
					FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,FSARegNbr,ConcurrencyId,GroupId,'U',getdate(), @StampUser
		FROM TGroup 
		WHERE GroupId = @GroupId

		--update
		UPDATE TGroup
		SET FSARegNbr = @FSARegNbr
		WHERE GroupId = @GroupId

		SET @GroupsUpdated = @@ROWCOUNT
	END

IF @SaveOption = 2 --all groups below @GroupId
	BEGIN

		--build a temp table containing all groups below this one - try 6 levels
		if object_id('tempdb..#HoldGroups') is not null
			drop table #HoldGroups

		create table #HoldGroups
		(
		GId bigint primary key, 
		ParentGId bigint,
		Depth tinyint,
		Descendants varchar(255)
		)

		INSERT Into #HoldGroups (GId, ParentGId)
			SELECT GroupId, ParentId
			FROM Administration..Tgroup
			WHERE IndigoclientId = @TenantId

		UPDATE #HoldGroups SET descendants='/', Depth=0 WHERE ParentGId Is Null

		WHILE EXISTS (SELECT 1 FROM #HoldGroups WHERE Depth Is Null) 
			UPDATE H SET H.depth = PG.Depth + 1,
			H.descendants = PG.descendants + convert(varchar,H.ParentGId) + '/'  
			FROM #HoldGroups AS H
			INNER JOIN #HoldGroups AS PG ON (H.ParentGId=PG.GId) 
			WHERE PG.Depth >= 0 
			AND PG.descendants Is Not Null 
			AND H.Depth Is Null

		--joining down hence got to delete those which aren't to be updated!
		DELETE FROM #HoldGroups where (charindex(convert(varchar,@GroupId),descendants) = 0) and  GId <> @GroupId

		--audit
		INSERT INTO TGroupAudit 
				(Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,
					FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,FSARegNbr,ConcurrencyId,GroupId,StampAction,StampDateTime,StampUser)
		SELECT 
				Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,
					FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,FSARegNbr,ConcurrencyId,GroupId,'U',getdate(), @StampUser
		FROM TGroup g
			JOIN #HoldGroups t on t.GId = g.GroupId and IndigoclientId = @TenantId

		--update
		UPDATE g
			SET g.FSARegNbr = @FSARegNbr
		FROM TGroup g
			JOIN #HoldGroups t on t.GId = g.GroupId and IndigoclientId = @TenantId

		SET @GroupsUpdated = @@ROWCOUNT

	END

IF @SaveOption = 3 -- all groups for this organisation
	BEGIN

		--audit
		INSERT INTO TGroupAudit 
				(Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,
					FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,FSARegNbr,ConcurrencyId,GroupId,StampAction,StampDateTime,StampUser)
		SELECT 
				Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,
					FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,FSARegNbr,ConcurrencyId,GroupId,'U',getdate(), @StampUser
		FROM TGroup g
		WHERE IndigoClientId = @TenantId

		--update
		UPDATE g
		SET g.FSARegNbr = @FSARegNbr
		FROM TGroup g
		WHERE IndigoClientId = @TenantId

		SET @GroupsUpdated = @@ROWCOUNT

	END

IF (@ParentId IS NULL OR @SaveOption = 3)
	BEGIN
	    EXEC SpNAuditIndigoClient '0', @TenantId, 'U'
	
	    UPDATE TIndigoClient
	    SET FSA = tg.FSARegNbr
	    FROM TIndigoClient tic
	    JOIN TGroup tg
	    ON tic.IndigoClientId = tg.IndigoClientId
	    WHERE tg.GroupId = @GroupId
	END

SELECT NumberOfGroupsUpdated = @GroupsUpdated

SET NOCOUNT OFF

END
GO
