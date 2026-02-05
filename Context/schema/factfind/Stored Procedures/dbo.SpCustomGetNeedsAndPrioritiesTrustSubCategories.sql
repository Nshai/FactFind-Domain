SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpCustomGetNeedsAndPrioritiesTrustSubCategories]	
	@PartyId bigint,
	@TenantId bigint
AS	
	SELECT   distinct SC.NeedsAndPrioritiesSubCategoryId as SubCategoryId,
					  SC.Name                            as SubCategoryName,
					  @PartyId							 as PartyId,
					  SC.Ordinal                         as Ordinal,
					  npQuestion.RefTrustCategoryId      as CategoryId				  
	FROM    Administration.dbo.TNeedsAndPrioritiesQuestion npQuestion
		    inner join Administration.dbo.TNeedsAndPrioritiesSubCategory SC   on npQuestion.NeedsAndPrioritiesSubCategoryId = SC.NeedsAndPrioritiesSubCategoryId
	WHERE   npQuestion.RefTrustCategoryId is NOT NULL and npQuestion.TenantId = @TenantId
	ORDER BY SC.Ordinal asc


