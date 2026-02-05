SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomUpdateFPNote] @FinancialPlanningId bigint, @Note varchar(max)

as

delete from TFinancialPlanningNote where financialplanningid = @financialplanningid

insert into	TFinancialPlanningNote
(
FinancialPlanningId,
Notes
)
select
@FinancialPlanningId,
@Note
GO
