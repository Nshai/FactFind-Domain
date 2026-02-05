SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpCustomGetNeedsAndPrioritiesSubCategories]	
	@PartyId bigint,
	@RelatedPartyId bigint,
	@TenantId bigint

AS	
	declare @IsPersonalClient bit

	-- Joint FactFind cannot have a mix of Personal and Corporate clients.
	-- Therefore it's assumed that @PartyId and @RelatedPartyId both are of the same type. (either both are personal clients, or both corporate clients)


	Select @IsPersonalClient =
				 CASE 
						WHEN PersonId IS NOT NULL THEN  1
						ELSE  0
				 END
	from crm..TCRMContact c where c.CRMContactId = @PartyId

	SELECT   distinct SC.NeedsAndPrioritiesSubCategoryId as SubCategoryId,
					  SC.Name                            as SubCategoryName,
					  @PartyId      as PartyId,
					  @RelatedPartyId  as RelatedPartyId,
					  SC.Ordinal                         as Ordinal,
					  case @IsPersonalClient
							WHEN 1 THEN npQuestion.RefPersonalCategoryId
							ELSE npQuestion.RefCorporateCategoryId
					  END as CategoryId					  
	FROM     FactFind.dbo.TNeedsAndPrioritiesAnswer npAnswer 
					 inner join Administration.dbo.TNeedsAndPrioritiesQuestion npQuestion on npAnswer.QuestionId = npQuestion.NeedsAndPrioritiesQuestionId
					 inner join Administration.dbo.TNeedsAndPrioritiesSubCategory SC   on npQuestion.NeedsAndPrioritiesSubCategoryId = SC.NeedsAndPrioritiesSubCategoryId
	WHERE    npAnswer.CRMContactId = @PartyId and npQuestion.TenantId = @TenantId
	ORDER BY SC.Ordinal asc


GO
