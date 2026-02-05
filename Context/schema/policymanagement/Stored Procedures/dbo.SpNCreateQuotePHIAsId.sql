SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateQuotePHIAsId]
	@StampUser varchar (255), 
	@QuoteItemId bigint, 
	@Premium decimal (10, 2) = Null, 
	@PremiumIncrease decimal (10, 2) = Null, 
	@CoverPeriod int = Null, 
	@DeferredPeriod int = Null, 
	@Benefit decimal (10, 2) = Null, 
	@Salary decimal (10, 2) = Null, 
	@ConcurrencyId int = 1
AS

Declare @QuotePHIId Bigint

Insert Into dbo.TQuotePHI
(QuoteItemId, Premium, PremiumIncrease, CoverPeriod, DeferredPeriod, Benefit, Salary, ConcurrencyId)
Values(@QuoteItemId, @Premium, @PremiumIncrease, @CoverPeriod, @DeferredPeriod, @Benefit, @Salary, @ConcurrencyId)

Select @QuotePHIId = SCOPE_IDENTITY()
Insert Into dbo.TQuotePHIAudit
(QuotePHIId, QuoteItemId, Premium, PremiumIncrease, CoverPeriod, DeferredPeriod, 
Benefit, Salary, ConcurrencyId, StampAction, StampDateTime, StampUser)
Select [QuotePHI].QuotePHIId, [QuotePHI].QuoteItemId, [QuotePHI].Premium, [QuotePHI].PremiumIncrease, [QuotePHI].CoverPeriod, [QuotePHI].DeferredPeriod, 
[QuotePHI].Benefit, [QuotePHI].Salary, [QuotePHI].ConcurrencyId, 'C', getdate(), @StampUser
From TQuotePHI [QuotePHI]
Where QuotePHIId = @QuotePHIId

Select @QuotePHIId
GO
