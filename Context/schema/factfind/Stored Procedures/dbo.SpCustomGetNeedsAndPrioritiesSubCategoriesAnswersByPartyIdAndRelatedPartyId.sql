SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpCustomGetNeedsAndPrioritiesSubCategoriesAnswersByPartyIdAndRelatedPartyId]	

	@PartyId bigint,

	@RelatedPartyId bigint = null,

	@TenantId bigint,

	@SubCategoryIdsCsv  VARCHAR(8000),

	@AnswerSplitPattern NVARCHAR(255) = '####'

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


declare @subCategoryIds TABLE( Id bigint NOT NULL)



insert into @subCategoryIds

Select convert(bigint,Value) from policymanagement..FnSplit(@SubCategoryIdsCsv,',')


;with QuestionAndAnswers (QuestionId, PartyId, Client1Answer, Client1Notes,  RelatedPartyId, Client2Answer,Client2Notes, AnswerId)

as

(

	select main.QuestionId as QuestionId, main.CRMContactId as 'PartyId', Client1Answer,  Client1Notes,
	
	related.CRMContactId as 'RelatedPartyId', Client2Answer,Client2Notes, COALESCE( main.AnswerId , related.AnswerId) 

	from (

		--client 1 answer if drop down type

        SELECT questionid,

                crmcontactid,

                CASE WHEN  refAns.needsandprioritiesquestionanswerid IS NOT NULL

				THEN refAns.answer      

				ELSE  ans.freetextanswer

				END  AS Client1Answer,

				CASE WHEN  refAns.needsandprioritiesquestionanswerid IS NOT NULL

				THEN ans.freetextanswer      

				ELSE null

				END  AS Client1Notes,

                ans.answerid

        FROM   administration..tneedsandprioritiesquestion q				

                LEFT JOIN factfind..tneedsandprioritiesanswer ans  ON q.needsandprioritiesquestionid = ans.questionid

                LEFT JOIN administration..tneedsandprioritiesquestionanswer refAns ON ans.answerid = refAns.needsandprioritiesquestionanswerid

        WHERE  crmcontactid = @PartyId AND q.controltypeid IN (7, 8, 9) AND q.TenantId = @TenantId and q.IsArchived = 0


		UNION 

        --client 1 answer if other control types

        SELECT questionid,

                crmcontactid,

                answervalue    AS Client1Answer,

                freetextanswer AS Client1Notes,

                NULL           AS AnswerId

        FROM    administration..tneedsandprioritiesquestion q 

                LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid

        WHERE  crmcontactid = @PartyId AND q.TenantId = @TenantId AND answerid IS NULL AND q.controltypeid IN ( 1, 3, 4, 5, 6 ) and q.IsArchived = 0


		UNION

		--client 1 answer if notes type

		SELECT questionid,

            crmcontactid,

            freetextanswer AS Client1Answer,

            NULL           AS Client1Notes,

            NULL           AS AnswerId

        FROM  administration..tneedsandprioritiesquestion q 

            LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid

        WHERE  crmcontactid = @PartyId AND answerid IS NULL  AND q.controltypeid = 2 AND q.TenantId = @TenantId and q.IsArchived = 0

	) main  left outer join 

		 (

			--client 2 answer if drop down type

			SELECT questionid,

					crmcontactid,

					CASE WHEN  refAns.needsandprioritiesquestionanswerid IS NOT NULL

					THEN refAns.answer      

					ELSE  ans.freetextanswer

					END  AS Client2Answer,

					CASE WHEN  refAns.needsandprioritiesquestionanswerid IS NOT NULL

					THEN ans.freetextanswer      

					ELSE null

					END  AS Client2Notes,

					answerid

			FROM   administration..tneedsandprioritiesquestion q

					LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid

					LEFT JOIN administration..tneedsandprioritiesquestionanswer refAns ON ans.answerid = refAns.needsandprioritiesquestionanswerid

			WHERE  crmcontactid = @RelatedPartyId AND q.controltypeid IN (7, 8, 9) AND q.TenantId = @TenantId and q.IsArchived = 0


			UNION

			--client 2 answer if other control types
            SELECT questionid,
                    crmcontactid,
                    Isnull(answervalue, freetextanswer) AS Client2Answer,
                    freetextanswer                      AS Client2Notes,
                    NULL                                AS AnswerId
            FROM  administration..tneedsandprioritiesquestion q 
                    LEFT JOIN  factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid
			WHERE  crmcontactid = @RelatedPartyId AND q.TenantId = @TenantId AND answerid IS NULL AND q.controltypeid IN ( 1, 3, 4, 5, 6 ) and q.IsArchived = 0


			UNION

			--client 2 answer if notes type
			SELECT questionid,
				crmcontactid,
				freetextanswer AS Client2Answer,
				NULL           AS Client2Notes,
				NULL           AS AnswerId
			FROM  administration..tneedsandprioritiesquestion q 
				LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid
			WHERE  crmcontactid = @RelatedPartyId AND q.TenantId = @TenantId AND answerid IS NULL AND q.controltypeid = 2 and q.IsArchived = 0

	) related on main.QuestionId = related.QuestionId

)



select qa.QuestionId, 

	   qa.PartyId, 

	   qa.Client1Answer, 
	   qa.Client1Notes,

	   qa.RelatedPartyId, 

	   qa.Client2Answer, 
	   qa.Client2Notes,

	   q.Question as QuestionText,

	   sub.NeedsAndPrioritiesSubCategoryId as SubCategoryId, 

	   sub.Name as SubCategoryName,

	   (

			case 

				when qa.QuestionId is not null then					

						  CONVERT(VARCHAR(MAX),

							(SELECT @AnswerSplitPattern +  ans.[Answer] 

								from Administration..TNeedsAndPrioritiesQuestionAnswer ans		

								where NeedsAndPrioritiesQuestionId = qa.QuestionId

								order by ans.Ordinal asc

								for xml path(''), type))	

				else null

			end

		) as PossibleAnsweres,
		ISNULL(personalCategory.RefNeedsAndPrioritiesCategoryId, corporateCategory.RefNeedsAndPrioritiesCategoryId) AS CategoryId

from QuestionAndAnswers qa 

			inner join administration..TNeedsAndPrioritiesQuestion q 	on qa.QuestionId = q.NeedsAndPrioritiesQuestionId 
			inner join administration..TNeedsAndPrioritiesSubCategory sub on q.NeedsAndPrioritiesSubCategoryId = sub.NeedsAndPrioritiesSubCategoryId
			left outer join Administration..TRefNeedsAndPrioritiesCategory personalCategory on @IsPersonalClient = 1 and q.RefPersonalCategoryId = personalCategory.RefNeedsAndPrioritiesCategoryId
			left outer join Administration..TRefNeedsAndPrioritiesCategory corporateCategory on @IsPersonalClient = 0 and q.RefCorporateCategoryId = corporateCategory.RefNeedsAndPrioritiesCategoryId

where q.TenantId = @TenantId and q.NeedsAndPrioritiesSubCategoryId in (Select Id from @subCategoryIds )

order by q.Ordinal asc


GO
