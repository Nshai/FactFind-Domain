SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetSupplementryQuestionsByPartyIdAndRelatedPartyId]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint
AS

;with QuestionAndAnswers (QuestionId, PartyId, Client1Answer,Client1Comment,  RelatedPartyId, Client2Answer, Client2Comment, QuestionText, Ordinal)
as
(
	select main.RefRiskQuestionId as QuestionId, main.CRMContactId as 'PartyId', main.Answer 'Client1Answer',  main.Comment 'Client1Comment',
	related.CRMContactId as 'RelatedPartyId', related.Answer 'Client2Answer' ,  related.Comment 'Client2Comment', main.QuestionText, main.Ordinal
	from (
		select a.RefRiskQuestionId, CRMContactId, Answer, Comment, rq.Question QuestionText, rq.Ordinal
		from  TExtraRiskQuestionAnswer a
		inner join administration..TRefRiskQuestion rq on a.RefRiskQuestionId = rq.RefRiskQuestionId
		where CrmContactId = @PartyId and rq.IsArchived = 0

	) main  left outer join 
		 (
		select a.RefRiskQuestionId, CRMContactId, Answer, Comment
		from  TExtraRiskQuestionAnswer a
		inner join administration..TRefRiskQuestion rq on a.RefRiskQuestionId = rq.RefRiskQuestionId
		where CrmContactId = @RelatedPartyId and rq.IsArchived = 0

	) related on main.RefRiskQuestionId = related.RefRiskQuestionId
)

select 
QuestionId, 
PartyId, 
Client1Answer,
Client1Comment,  
RelatedPartyId, 
Client2Answer, 
Client2Comment, 
QuestionText
from QuestionAndAnswers qa 
order by Ordinal asc

GO
