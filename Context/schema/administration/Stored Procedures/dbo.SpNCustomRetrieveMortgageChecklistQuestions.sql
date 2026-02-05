SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgageChecklistQuestions]
	@TenantId bigint
AS
-- Categories
SELECT MortgageChecklistCategoryId, MortgageChecklistCategoryName, ArchiveFG, Ordinal 
FROM TMortgageChecklistCategory 
WHERE TenantId = @TenantId AND ArchiveFG = 0
ORDER BY Ordinal, MortgageChecklistCategoryName

-- Questions
SELECT MortgageChecklistQuestionId, Question, MortgageChecklistCategoryId, Ordinal, IsArchived, TenantId, ParentQuestionId 
FROM TMortgageChecklistQuestion
WHERE TenantId = @TenantId AND IsArchived = 0
ORDER BY Ordinal, Question
GO
