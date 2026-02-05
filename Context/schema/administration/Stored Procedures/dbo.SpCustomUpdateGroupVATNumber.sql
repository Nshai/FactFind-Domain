SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomUpdateGroupVATNumber]
	@GroupId bigint,
	@StampUser varchar(255),
	@VatRegNbr varchar(50),
	@SaveOption int
	

AS

BEGIN

/* Save Options:
	1 - This group only
	2 - All groups below this group
	3 - All Groups
*/


DECLARE @IndigoClientId bigint

SET @IndigoClientId = (select IndigoClientId FROM TGroup WHERE GroupId = @GroupId)

IF @SaveOption = 1 --this group only
BEGIN
	--audit
	INSERT INTO TGroupAudit (Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,ConcurrencyId,GroupId,StampAction,StampDateTime,StampUser)
	SELECT Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,ConcurrencyId,GroupId,'U',getdate(), @StampUser
	FROM TGroup 
	WHERE GroupId = @GroupId

	--update
	UPDATE TGroup
	SET VatRegNbr = @VatRegNbr
	WHERE GroupId = @GroupId
END

IF @SaveOption = 2 --all groups below @GroupId
BEGIN
	--build a temp table containing all groups below this one - try 6 levels
	declare @Group TABLE (GroupId bigint PRIMARY KEY, Identifier varchar(64))

	-- this group
	INSERT INTO @Group
	SELECT g1.GroupId, g1.Identifier FROM Administration..TGroup g1 WHERE g1.GroupId = @GroupId
	
	-- all groups with @GroupId as the parent
	INSERT INTO @Group
	select g2.groupid, g2.identifier 
	from tgroup g1
	left join tgroup g2 on g1.groupid = g2.parentid
	where g1.groupid = @GroupId
	AND g2.GroupId IS NOT NULL
	GROUP BY g2.GroupiD, g2.Identifier

	--etc
	INSERT INTO @Group
	select g3.groupid, g3.identifier
	from tgroup g1
	left join tgroup g2 on g1.groupid = g2.parentid
	left join tgroup g3 on g2.groupid = g3.parentid
	where g1.groupid = @GroupId
	AND g3.GroupId IS NOT NULL
	GROUP BY g3.GroupiD, g3.Identifier

	INSERT INTO @Group
	select g4.groupid, g4.identifier
	from tgroup g1
	left join tgroup g2 on g1.groupid = g2.parentid
	left join tgroup g3 on g2.groupid = g3.parentid
	left join tgroup g4 on g3.groupid = g4.parentid
	where g1.groupid = @GroupId
	AND g4.GroupId IS NOT NULL
	GROUP BY g4.GroupiD, g4.Identifier

	INSERT INTO @Group
	select g5.groupid, g5.identifier
	from tgroup g1
	left join tgroup g2 on g1.groupid = g2.parentid
	left join tgroup g3 on g2.groupid = g3.parentid
	left join tgroup g4 on g3.groupid = g4.parentid
	left join tgroup g5 on g4.groupid = g5.parentid
	where g1.groupid = @GroupId
	AND g5.GroupId IS NOT NULL
	GROUP BY g5.GroupiD, g5.Identifier

	INSERT INTO @Group
	select g6.groupid, g6.identifier
	from tgroup g1
	left join tgroup g2 on g1.groupid = g2.parentid
	left join tgroup g3 on g2.groupid = g3.parentid
	left join tgroup g4 on g3.groupid = g4.parentid
	left join tgroup g5 on g4.groupid = g5.parentid
	left join tgroup g6 on g5.groupid = g6.parentid
	where g1.groupid = @GroupId
	AND g6.GroupId IS NOT NULL
	GROUP BY g6.GroupiD, g6.Identifier

	--audit
	INSERT INTO TGroupAudit (Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,ConcurrencyId,GroupId,StampAction,StampDateTime,StampUser)
	SELECT g.Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,ConcurrencyId,g.GroupId,'U',getdate(), @StampUser
	FROM TGroup g
	JOIN @Group t on t.GroupId = g.GroupId 

	--update
	UPDATE g
	SET g.VatRegNbr = @VatRegNbr
	FROM TGroup g
	JOIN @Group t on t.GroupId = g.GroupId
END

IF @SaveOption = 3 -- all groups for this organisation
BEGIN

	--audit
	INSERT INTO TGroupAudit (Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,ConcurrencyId,GroupId,StampAction,StampDateTime,StampUser)
	SELECT Identifier,GroupingId,IndigoClientId,CRMContactId,ParentId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,ConcurrencyId,GroupId,'U',getdate(), @StampUser
	FROM TGroup g
	WHERE IndigoClientId = @IndigoClientId

	--update
	UPDATE g
	SET g.VatRegNbr = @VatRegNbr
	FROM TGroup g
	WHERE IndigoClientId = @IndigoClientId

END

END





GO
