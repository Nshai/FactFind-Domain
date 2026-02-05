SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetNeedsAndPrioritiesAnswersByPartyIdAndRelatedPartyId]	

	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint,
	@AnswerSplitPattern NVARCHAR(255) = '####'

AS

--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155
--DECLARE @AnswerSplitPattern NVARCHAR(255) = '####'


-- Joint FactFind cannot have a mix of Personal and Corporate clients.
-- Therefore it's assumed that @PartyId and @RelatedPartyId both are of the same type. (either both are personal clients, or both corporate clients)
DECLARE @IsPersonalClient BIT

SELECT @IsPersonalClient = CASE
                             WHEN personid IS NOT NULL THEN 1
                             ELSE 0
                           END
FROM   crm..tcrmcontact c
WHERE  c.crmcontactid = @PartyId;

WITH questionandanswers (questionid, partyid, client1answer, client1notes,
     relatedpartyid, client2answer, client2notes, answerid)
     AS (
	 
		SELECT main.questionid      AS QuestionId,
                main.crmcontactid    AS 'PartyId',
                client1answer,
                client1notes,
                related.crmcontactid AS 'RelatedPartyId',
                client2answer,
                client2notes,
                COALESCE(main.answerid, related.answerid)
         FROM   (
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
                WHERE  crmcontactid = @PartyId AND q.controltypeid IN ( 7, 8, 9 ) AND q.TenantId = @TenantId and q.IsArchived = 0
                
				UNION

                --client 1 answer if other control types
                SELECT questionid,
                       crmcontactid,
                       answervalue    AS Client1Answer,
                       freetextanswer AS Client1Notes,
                       NULL           AS AnswerId
                FROM    administration..tneedsandprioritiesquestion q 
                       LEFT JOIN factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid
                WHERE  crmcontactid = @PartyId AND q.TenantId = @TenantId AND answerid IS NULL AND q.controltypeid IN ( 1, 3, 4, 5, 6, 9 ) and q.IsArchived = 0
                
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
						
				) main
                
				LEFT OUTER JOIN 
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
								WHERE  crmcontactid = @RelatedPartyId AND q.controltypeid IN ( 7, 8, 9 ) AND q.TenantId = @TenantId and q.IsArchived = 0
                                
								UNION

                                --client 2 answer if other control types
                                SELECT questionid,
                                       crmcontactid,
                                       Isnull(answervalue, freetextanswer) AS Client2Answer,
                                       freetextanswer                      AS Client2Notes,
                                       NULL                                AS AnswerId
                                FROM  administration..tneedsandprioritiesquestion q 
                                       LEFT JOIN  factfind..tneedsandprioritiesanswer ans ON q.needsandprioritiesquestionid = ans.questionid
								WHERE  crmcontactid = @RelatedPartyId AND q.TenantId = @TenantId AND answerid IS NULL AND q.controltypeid IN ( 1, 3, 4, 5, 6, 9 ) and q.IsArchived = 0

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

) related ON main.questionid = related.questionid)


SELECT qa.questionid,
       qa.partyid,
       qa.client1answer,
       qa.client1notes,
       qa.relatedpartyid,
       qa.client2answer,
       qa.client2notes,
       q.question                                         AS QuestionText,
       ( CASE
           WHEN qa.questionid IS NOT NULL THEN
           CONVERT(VARCHAR(max), (SELECT @AnswerSplitPattern + ans.[answer]
                                  FROM
           administration..tneedsandprioritiesquestionanswer
           ans
                                  WHERE  needsandprioritiesquestionid =
                                         qa.questionid
                                  ORDER  BY ans.ordinal ASC
                                  FOR xml path(''), type))
           ELSE NULL
         END )                                            AS PossibleAnsweres,
       Isnull(personalCategory.refneedsandprioritiescategoryid,
       corporateCategory.refneedsandprioritiescategoryid) AS CategoryId
FROM   questionandanswers qa
       INNER JOIN administration..tneedsandprioritiesquestion q
               ON qa.questionid = q.needsandprioritiesquestionid
       LEFT OUTER JOIN administration..trefneedsandprioritiescategory
                       personalCategory
                    ON @IsPersonalClient = 1
                       AND q.refpersonalcategoryid =
                           personalCategory.refneedsandprioritiescategoryid
       LEFT OUTER JOIN administration..trefneedsandprioritiescategory
                       corporateCategory
                    ON @IsPersonalClient = 0
                       AND q.refcorporatecategoryid =
                           corporateCategory.refneedsandprioritiescategoryid
WHERE  tenantid = @TenantId
ORDER  BY q.ordinal

GO 
