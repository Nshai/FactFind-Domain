SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomRetrieveExtraRiskQuestions] @indigoclientId bigint,
		@CRMContactId bigint,
		@CRMContactId2 bigint

as

--Only return questions is this is a person
declare @isPerson bit

select @isPerson = case 						
						when PersonId is not null then 1 						
							else 0 end 
							from crm..TCRMContact where crmcontactid = @CRMContactId

select *   
from administration..TRefRiskQuestion   
where isarchived = 0 and createdby = @indigoclientId and isnull(@isPerson,1) = 1
order by Ordinal, question asc  

select *
from   TExtraRiskQuestionAnswer
where	crmcontactid = @CRMContactId

select *
from   TExtraRiskQuestionAnswer
where	crmcontactid = @CRMContactId2


GO
