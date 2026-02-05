SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateIndigoClientSib]
	@IndigoClientId bigint,
	@Sib varchar(255),
	@GroupId bigint = 0,
	@IsAgencyCode bit = 0
AS
BEGIN
DECLARE @Guid uniqueidentifier, @FSARegNbr varchar(255)
SET NOCOUNT ON

SET @FSARegNbr = (
	SELECT FSARegNbr
	FROM Administration..TGroup
	WHERE GroupId = @GroupId
)

IF @IsAgencyCode = 0 AND @Sib <> @FSARegNbr
BEGIN
	SELECT 'This FCA ref ' + @Sib + ' does not match the group FCA ref ' + @FSARegNbr as Message
	RETURN(0)
END

IF EXISTS(SELECT * from Administration..TIndigoClientSib WHERE Sib=@Sib)
BEGIN
	SELECT 'SIB Already Exists - ' + @Sib as Message
	RETURN(0)
END

IF EXISTS(SELECT * from Administration..TIndigoClientSibCombined WHERE Sib=@Sib)
BEGIN
	SELECT 'SIB Already Exists - ' + @Sib as Message
	RETURN(0)
END

IF @GroupId < 1
BEGIN
	SELECT @GroupId = GroupId
	FROM
		Administration..TGroup
	WHERE
		IndigoClientId = @IndigoClientId
		AND LegalEntity = 1

	IF @@ROWCOUNT > 1
	BEGIN
		SELECT 'More than one Legal Entity exists for this Indigo Client, please specify a Group Id' as Message
		RETURN(0)
	END
END

IF @GroupId >= 1
BEGIN
	SELECT @GroupId = GroupId
	FROM
		Administration..TGroup
	WHERE
		GroupId = @GroupId
		AND IndigoClientId = @IndigoClientId

	IF @@ROWCOUNT < 1
	BEGIN
		SELECT 'Group does not exist on target tenant, please select a valid group' as Message
		RETURN(0)
	END
END

SET @Guid = NEWID()

INSERT INTO TIndigoClientSib (IndigoClientId, GroupId, Sib, IsAgencyCode, Guid)
VALUES (@IndigoClientId, @GroupId, @Sib, @IsAgencyCode, @Guid)

INSERT INTO TIndigoClientSibAudit (
	IndigoClientId, GroupId, Sib, IsAgencyCode, Guid, ConcurrencyId, IndigoClientSibId, StampAction, StampDateTime, StampUser)
SELECT
	IndigoClientId, GroupId, Sib, IsAgencyCode, Guid, ConcurrencyId, IndigoClientSibId, 'C', GETDATE(), 0
FROM
	TIndigoClientSib
WHERE
	Guid = @Guid

INSERT INTO TIndigoClientSibCombined (
	Guid, IndigoClientSibId, IndigoClientGuid, IndigoClientId, GroupId, Sib, IsAgencyCode, ConcurrencyId)
SELECT
	S.Guid, S.IndigoClientSibId, I.Guid, S.IndigoClientId,S.GroupId, S.Sib, S.IsAgencyCode, S.ConcurrencyId
FROM
	TIndigoClientSib S
	JOIN TIndigoClient I ON I.IndigoClientId = ABS(S.IndigoClientId)
WHERE
	S.Guid = @Guid

SELECT 'Done' as Message
END

GO
