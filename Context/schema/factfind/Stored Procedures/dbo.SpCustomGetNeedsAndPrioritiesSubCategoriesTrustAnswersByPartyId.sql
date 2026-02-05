SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpCustomGetNeedsAndPrioritiesSubCategoriesTrustAnswersByPartyId]	

	@PartyId bigint,
	@TenantId bigint,
	@SubCategoryIdsCsv  VARCHAR(8000),
	@AnswerSplitPattern NVARCHAR(255) = '####'
AS

declare @subCategoryIds TABLE( Id bigint NOT NULL)

insert into @subCategoryIds
Select convert(bigint,Value) from policymanagement..FnSplit(@SubCategoryIdsCsv,',')
;with QuestionAndAnswers (QuestionId, PartyId, Client1Answer, Client1Notes, AnswerId)
as
(
	select main.QuestionId as QuestionId, main.CRMContactId as 'PartyId', Client1Answer,  Client1Notes, main.AnswerId
	from (
		--client 1 answer if drop down type
        SELECT  q.needsandprioritiesquestionid as questionid,
                crmcontactid,
				CASE
				WHEN ans.AnswerOptions IS NOT NULL
                THEN (SELECT STRING_AGG(JSON_VALUE(oj.value, '$.Text'),',') answers FROM OPENJSON(CONCAT('{"Result":',ans.AnswerOptions,'}'),'$.Result') oj)
				ELSE NULL
				END AS Client1Answer,				
				ans.Notes AS Client1Notes,
                ans.answerid
        FROM   administration..tneedsandprioritiesquestion q				
                LEFT JOIN factfind..tneedsandprioritiesanswer ans  ON q.needsandprioritiesquestionid = ans.questionid AND crmcontactid = @PartyId 
                LEFT JOIN administration..tneedsandprioritiesquestionanswer refAns ON ans.answerid = refAns.needsandprioritiesquestionanswerid
        WHERE   q.controltypeid IN ( 7, 8, 9 ) AND q.TenantId = @TenantId and q.IsArchived = 0 AND q.RefTrustCategoryId is NOT NULL
		UNION 
        --client 1 answer if other control types
        SELECT  q.needsandprioritiesquestionid as questionid,
                crmcontactid,
                answervalue    AS Client1Answer,
				ans.Notes      AS Client1Notes,
                NULL           AS AnswerId
        FROM    administration..tneedsandprioritiesquestion q 
                LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid AND crmcontactid = @PartyId  
        WHERE  q.TenantId = @TenantId AND answerid IS NULL AND q.controltypeid IN ( 1, 3, 4, 5, 6, 10 ) and q.IsArchived = 0 AND q.RefTrustCategoryId is NOT NULL
		UNION
		--client 1 answer if notes type
		SELECT  q.needsandprioritiesquestionid as questionid,
            crmcontactid,
            freetextanswer AS Client1Answer,
            NULL           AS Client1Notes,
            NULL           AS AnswerId
        FROM  administration..tneedsandprioritiesquestion q 
        LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid AND crmcontactid = @PartyId  
        WHERE  answerid IS NULL  AND q.controltypeid = 2 AND q.TenantId = @TenantId and q.IsArchived = 0 AND q.RefTrustCategoryId is NOT NULL
	) main
)
select qa.QuestionId,
	   @PartyId as PartyId,
	   qa.Client1Answer, 
	   qa.Client1Notes,
	   q.Question as QuestionText,
	   sub.NeedsAndPrioritiesSubCategoryId as SubCategoryId,
	   sub.Name as SubCategoryName,
	   (
			case 
				when qa.QuestionId is not null then
						  CONVERT(VARCHAR(MAX),
							(SELECT @AnswerSplitPattern +  ans.[Answer] 
								from Administration..TNeedsAndPrioritiesQuestionAnswer ans		
								where NeedsAndPrioritiesQuestionId = qa.QuestionId and ans.IsArchived = 0
								order by ans.Ordinal asc
								for xml path(''), type))
				else null
			end
		) as PossibleAnsweres,
		trustCategory.RefNeedsAndPrioritiesCategoryId AS CategoryId
from QuestionAndAnswers qa 
			inner join administration..TNeedsAndPrioritiesQuestion q 	on qa.QuestionId = q.NeedsAndPrioritiesQuestionId 
			inner join administration..TNeedsAndPrioritiesSubCategory sub on q.NeedsAndPrioritiesSubCategoryId = sub.NeedsAndPrioritiesSubCategoryId
			left outer join Administration..TRefNeedsAndPrioritiesCategory trustCategory on q.RefTrustCategoryId = trustCategory.RefNeedsAndPrioritiesCategoryId
where q.TenantId = @TenantId and q.NeedsAndPrioritiesSubCategoryId in (Select Id from @subCategoryIds )
order by q.Ordinal asc

GO

