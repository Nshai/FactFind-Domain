SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomSaveStochasticIllustrationResults]

@objectiveid bigint,
@term bigint,
@input bigint,
@lower bigint,
@mid bigint,
@upper bigint

as

delete from TStochasticIllustrationResult
where	ObjectiveId = @objectiveid and
		term = @term

insert into TStochasticIllustrationResult
(
ObjectiveId,
Term,
InputValue,
LowerReturn,
MidReturn,
UpperReturn,
ConcurrencyId
)
select
@objectiveid,
@term,
@input,
@lower,
@mid,
@upper,
1

GO
