SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[TraverseHierarchy]
(
	@RootId bigint
)
AS
BEGIN
	DECLARE @GroupId bigint
	DECLARE @GroupName varchar(50)

	--Legal Entity
	SET @GroupName = (SELECT Identifier FROM TGroup WHERE GroupId = @RootId )	

	Insert Into #LegalEntityGroups (GroupId) values (@RootId)

	SET @GroupId = (SELECT MIN(GroupId) FROM TGroup WHERE ParentId = @RootId)

	WHILE @GroupId IS NOT NULL
	BEGIN
		EXEC TraverseHierarchy @GroupId

		SET @GroupId = (SELECT MIN(GroupId) FROM TGroup WHERE ParentId = @RootId AND GroupId > @GroupId)		

	END
END


GO
