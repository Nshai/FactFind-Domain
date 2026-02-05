SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpCustomGetNeedsAndPrioritiesTrustAnswersByPartyId]	
	@PartyId bigint,
	@TenantId bigint,
	@AnswerSplitPattern NVARCHAR(255) = '####'
AS


WITH questionandanswers (questionid, partyid, client1answer, client1notes, answerid)
     AS (
	 
		SELECT  questionid      AS QuestionId,
                crmcontactid    AS 'PartyId',
                client1answer,
                client1notes,
                answerid
         FROM   (
                --client 1 answer if drop down type
                SELECT q.needsandprioritiesquestionid  as questionid,
                       crmcontactid,
					   CASE
					   WHEN ans.AnswerOptions IS NOT NULL
                       THEN (SELECT STRING_AGG(JSON_VALUE(oj.value, '$.Text'),',') answers FROM OPENJSON(CONCAT('{"Result":',ans.AnswerOptions,'}'),'$.Result') oj)
					   ELSE NULL
					   END AS Client1Answer,
					   ans.Notes AS Client1Notes,
                       ans.answerid
                FROM   administration..tneedsandprioritiesquestion q				
                       LEFT JOIN factfind..tneedsandprioritiesanswer ans  ON q.needsandprioritiesquestionid = ans.questionid  AND crmcontactid = @PartyId  
                       LEFT JOIN administration..tneedsandprioritiesquestionanswer refAns ON ans.answerid = refAns.needsandprioritiesquestionanswerid
                WHERE q.controltypeid IN ( 7, 8, 9 ) AND q.TenantId = @TenantId and q.IsArchived = 0 AND q.RefTrustCategoryId is NOT NULL
                
				UNION

                --client 1 answer if other control types
                SELECT q.needsandprioritiesquestionid  as questionid,
                       crmcontactid,
                       answervalue    AS Client1Answer,
                       ans.Notes      AS Client1Notes,
                       NULL           AS AnswerId
                FROM    administration..tneedsandprioritiesquestion q 
                       LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid AND crmcontactid = @PartyId 
                WHERE   q.TenantId = @TenantId AND answerid IS NULL AND q.controltypeid IN ( 1, 3, 4, 5, 6, 10 ) and q.IsArchived = 0 AND q.RefTrustCategoryId is NOT NULL
                
				 UNION
                
				 --client 1 answer if notes type
				 SELECT q.needsandprioritiesquestionid  as questionid,
                        crmcontactid,
                        freetextanswer AS Client1Answer,
                        NULL           AS Client1Notes,
                        NULL           AS AnswerId
                 FROM  administration..tneedsandprioritiesquestion q 
                       LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid AND crmcontactid = @PartyId 
                 WHERE   answerid IS NULL  AND q.controltypeid = 2 AND q.TenantId = @TenantId and q.IsArchived = 0 AND q.RefTrustCategoryId is NOT NULL
						
				) main)

SELECT qa.questionid,
       @PartyId AS 'PartyId',
       qa.client1answer,
       qa.client1notes,
       q.question                                         AS QuestionText,
       ( CASE
           WHEN qa.questionid IS NOT NULL THEN
           CONVERT(VARCHAR(max), (SELECT @AnswerSplitPattern + ans.[answer]
                                  FROM
           administration..tneedsandprioritiesquestionanswer
           ans
                                  WHERE  needsandprioritiesquestionid =
                                         qa.questionid AND ans.IsArchived = 0
                                  ORDER  BY ans.ordinal ASC
                                  FOR xml path(''), type))
           ELSE NULL
         END )                                            AS PossibleAnsweres,
       trustCategory.RefNeedsAndPrioritiesCategoryId AS CategoryId
FROM   questionandanswers qa
       INNER JOIN administration..tneedsandprioritiesquestion q
               ON qa.questionid = q.needsandprioritiesquestionid
       LEFT OUTER JOIN administration..trefneedsandprioritiescategory trustCategory
                    ON q.RefTrustCategoryId = trustCategory.RefNeedsAndPrioritiesCategoryId
WHERE  tenantid = @TenantId
ORDER  BY q.ordinal

GO