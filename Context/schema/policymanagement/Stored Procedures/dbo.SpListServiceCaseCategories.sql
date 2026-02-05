SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpListServiceCaseCategories]
@GroupId int,
@TenantId int,
@IsHidden bit,
@GroupIds dbo.[tvp_bigint] READONLY
AS

BEGIN
	IF (EXISTS(SELECT 1 FROM @GroupIds) AND @IsHidden = 0)
		BEGIN
		SELECT
		   [AdviseCategoryId] AS ServiceCaseCategoryId
		  ,[Name] AS ServiceCaseCategoryName
		  ,[IsArchived]
		  ,[ConcurrencyId]
		  ,[GroupId] AS ServiceCaseCategoryGroupId
		  ,[IsPropagated]
		FROM TAdviseCategory
		WHERE 
		((GroupId IN (SELECT VALUE FROM @GroupIds) AND IsPropagated = 1) OR (GroupId IS NULL AND IsPropagated = 1) OR GroupId = @GroupId) AND IsArchived = 0 AND TenantId = @TenantId
	
		END
	ELSE IF (EXISTS(SELECT 1 FROM @GroupIds) AND @IsHidden = 1)
	BEGIN 
		SELECT
		   [AdviseCategoryId] AS ServiceCaseCategoryId
		  ,[Name] AS ServiceCaseCategoryName
		  ,[IsArchived]
		  ,[ConcurrencyId]
		  ,[GroupId] AS ServiceCaseCategoryGroupId
		  ,[IsPropagated]
		FROM TAdviseCategory
		WHERE 
		GroupId IN (SELECT VALUE FROM @GroupIds) AND TenantId = @TenantId
	END
	ELSE
		BEGIN 
		SELECT
		   [AdviseCategoryId] AS ServiceCaseCategoryId
		  ,[Name] AS ServiceCaseCategoryName
		  ,[IsArchived]
		  ,[ConcurrencyId]
		  ,[GroupId] AS ServiceCaseCategoryGroupId
		  ,[IsPropagated]
		FROM TAdviseCategory
		WHERE GroupId IS NULL AND IsArchived = 0 AND TenantId = @TenantId
		END
END
GO
