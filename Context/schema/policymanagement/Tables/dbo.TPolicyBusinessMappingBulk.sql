CREATE TABLE [dbo].[TPolicyBusinessMappingBulk]
(
[PolicyBusinessId] [int] NULL,
[PortfolioReference] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CustomerReference] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PassReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ParentPolicyBusinessId] [int] NULL

)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessMapping_PolicyBusinessId] ON [dbo].[TPolicyBusinessMappingBulk] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessMapping_PortfolioReference] ON [dbo].[TPolicyBusinessMappingBulk] ([PortfolioReference])
GO
