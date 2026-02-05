SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateQuoteBondAsId]
	@StampUser varchar (255), 
	@QuoteItemId bigint, 
	@InvestmentAmount decimal (10, 2) = Null, 
	@Term int = Null, 
	@FinalCIV decimal (10, 2) = Null, 
	@NumFreeSwitches int = Null, 
	@MedGrowthRate decimal (10, 2) = Null, 
	@ConcurrencyId int = 1
AS

Declare @QuoteBondId Bigint

Insert Into dbo.TQuoteBond
(QuoteItemId, InvestmentAmount, Term, FinalCIV, NumFreeSwitches, MedGrowthRate, ConcurrencyId)
Values(@QuoteItemId, @InvestmentAmount, @Term, @FinalCIV, @NumFreeSwitches, @MedGrowthRate, @ConcurrencyId)

Select @QuoteBondId = SCOPE_IDENTITY()
Insert Into dbo.TQuoteBondAudit
(QuoteBondId, QuoteItemId, InvestmentAmount, Term, FinalCIV, NumFreeSwitches, 
MedGrowthRate, ConcurrencyId, StampAction, StampDateTime, StampUser)
Select [QuoteBond].QuoteBondId, [QuoteBond].QuoteItemId, [QuoteBond].InvestmentAmount, [QuoteBond].Term, [QuoteBond].FinalCIV, [QuoteBond].NumFreeSwitches, 
[QuoteBond].MedGrowthRate, [QuoteBond].ConcurrencyId, 'C', getdate(), @StampUser
From TQuoteBond [QuoteBond]
Where QuoteBondId = @QuoteBondId

Select @QuoteBondId
GO
