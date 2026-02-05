SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNAuditExtraRiskQuestionAnswer] 
@ExtraRiskQuestionAnswerId bigint,
@StampUser varchar(255),
@StampAction char (1)

as

insert into TExtraRiskQuestionAnswerAudit
(RefRiskQuestionId,
CRMContactId,
Answer,
ConcurrencyId,
ExtraRiskQuestionAnswerId,
StampAction,
StampDateTime,
StampUser,
Comment)
select 
RefRiskQuestionId,
CRMContactId,
Answer,
ConcurrencyId,
ExtraRiskQuestionAnswerId,
@StampAction,
getdate(),
@StampUser,
Comment
from TExtraRiskQuestionAnswer
where	ExtraRiskQuestionAnswerId = @ExtraRiskQuestionAnswerId

GO
