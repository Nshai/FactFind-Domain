CREATE TABLE [dbo].[TRequirement]
(
[RequirementId] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (100) NOT NULL,
[PrimaryPartyId] [int] NOT NULL,
[SecondaryPartyId] [int] NULL,
[TenantId] [int] NOT NULL,
[MortgageOpportunityId] [int] NULL,
[ObjectiveId] [int] NULL 
)
GO
ALTER TABLE [dbo].[TRequirement] ADD CONSTRAINT [PK_TRequirement] PRIMARY KEY NONCLUSTERED  ([RequirementId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRequirement_Type_TenantId] ON [dbo].[TRequirement] ([Type], [TenantId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRequirement_MortgageOpportunityId] ON [dbo].[TRequirement] ([MortgageOpportunityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRequirement_ObjectiveId] ON [dbo].[TRequirement] ([ObjectiveId])
GO
ALTER TABLE [dbo].[TRequirement] ADD CONSTRAINT [FK_TRequirement_MortgageOpportunityId] FOREIGN KEY ([MortgageOpportunityId]) REFERENCES [dbo].[TMortgageOpportunity] ([MortgageOpportunityId])
GO
ALTER TABLE [dbo].[TRequirement] WITH CHECK ADD CONSTRAINT [FK_TRequirement_PrimaryPartyId] FOREIGN KEY ([PrimaryPartyId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TRequirement] WITH CHECK ADD CONSTRAINT [FK_TRequirement_SecondaryPartyId] FOREIGN KEY ([SecondaryPartyId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
