SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveNeedsAndPrioritiesQuestions]
	@TenantId bigint,
	@IsCorporate bit = 0
AS
DECLARE @GeneralCategory bigint
DECLARE @CategoryType varchar (25) 

IF @IsCorporate = 0
	SET @CategoryType = 'Personal'
IF @IsCorporate = 1
	SET @CategoryType = 'Corporate'

-- find general category
SELECT @GeneralCategory = RefNeedsAndPrioritiesCategoryId
FROM Administration..TRefNeedsAndPrioritiesCategory
WHERE CategoryName = 'General' and CategoryType = @CategoryType

-- Categories
SELECT RefNeedsAndPrioritiesCategoryId AS Id, CategoryName
FROM Administration..TRefNeedsAndPrioritiesCategory
WHERE CategoryType = @CategoryType
ORDER BY Ordinal

-- Questions
SELECT 
	A.NeedsAndPrioritiesQuestionId AS QuestionId,
	A.Question,
	CASE 
		WHEN A.IsForProfile = 1 THEN 1
		WHEN A.RefPersonalCategoryId = @GeneralCategory AND @IsCorporate = 0 THEN 1
		WHEN A.RefCorporateCategoryId = @GeneralCategory AND @IsCorporate = 1 THEN 1
		ELSE 0
	END AS IsForProfile,			
	A.IsTextArea,
	A.Ordinal,
	-- Corporate or personal category.
	CASE @IsCorporate
		WHEN 0 THEN A.RefPersonalCategoryId
		ELSE A.RefCorporateCategoryId 
	END AS CategoryId,
	SC.[Name] AS SubCategory,
	ISNULL(SC.Ordinal, 0) AS SubCategoryOrdinal,
	ControlTypeId
FROM 
	TNeedsAndPrioritiesQuestion A
	LEFT JOIN TNeedsAndPrioritiesSubCategory SC ON SC.NeedsAndPrioritiesSubCategoryId = A.NeedsAndPrioritiesSubCategoryId
WHERE 
	A.TenantId = @TenantId 
	AND A.IsArchived = 0
	-- Question must belong to personal/corporate category.
	AND NOT (A.RefPersonalCategoryId IS NULL AND @IsCorporate = 0)
	AND NOT (A.RefCorporateCategoryId IS NULL AND @IsCorporate = 1)
ORDER BY CategoryId, SubCategoryOrdinal, SubCategory, A.Ordinal, A.Question
	
-- Answers
SELECT 
	B.NeedsAndPrioritiesQuestionAnswerId AS AnswerId,
	B.NeedsAndPrioritiesQuestionId AS QuestionId,
	B.Answer,
	B.Ordinal
FROM 
	TNeedsAndPrioritiesQuestion A	
	JOIN TNeedsAndPrioritiesQuestionAnswer B ON B.NeedsAndPrioritiesQuestionId = A.NeedsAndPrioritiesQuestionId
WHERE 
	A.TenantId = @TenantId 
	AND A.IsArchived = 0
	AND B.IsArchived = 0
	-- Question must belong to personal/corporate category.
	AND NOT (A.RefPersonalCategoryId IS NULL AND @IsCorporate = 0)
	AND NOT (A.RefCorporateCategoryId IS NULL AND @IsCorporate = 1)
ORDER BY B.Ordinal	
GO
