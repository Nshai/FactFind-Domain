CREATE TABLE [dbo].[TMortgageBenchRequirement]
(
[MortgageBenchRequirementId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageBenchRequirement_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageBenchRequirement] ADD CONSTRAINT [PK_TMortgageBenchRequirement] PRIMARY KEY NONCLUSTERED  ([MortgageBenchRequirementId])
GO
