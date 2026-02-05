CREATE TABLE [dbo].[TInsuranceClaim]
(
[InsuranceClaimId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefInsuranceClaimTypeId] [int] NOT NULL,
[Value] [money] NOT NULL,
[DateOfClaim] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInsuranceClaim_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInsuranceClaim] ADD CONSTRAINT [PK_TInsuranceClaim] PRIMARY KEY CLUSTERED  ([InsuranceClaimId])
GO
ALTER TABLE [dbo].[TInsuranceClaim] WITH CHECK ADD CONSTRAINT [FK_TInsuranceClaim_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
ALTER TABLE [dbo].[TInsuranceClaim] WITH CHECK ADD CONSTRAINT [FK_TInsuranceClaim_TRefInsuranceClaimType] FOREIGN KEY ([RefInsuranceClaimTypeId]) REFERENCES [dbo].[TRefInsuranceClaimType] ([RefInsuranceClaimTypeId])
GO
