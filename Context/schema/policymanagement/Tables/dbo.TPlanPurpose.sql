CREATE TABLE [dbo].[TPlanPurpose]
(
[PlanPurposeId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (255) NOT NULL,
[MortgageRelatedfg] [bit] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanPurpose_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPlanPurpose] ADD CONSTRAINT [PK_TPlanPurpose] PRIMARY KEY CLUSTERED  ([PlanPurposeId])
GO
CREATE NONCLUSTERED INDEX IX_TPlanPurpose_MortgageRelatedfg_IndigoClientId ON [dbo].[TPlanPurpose] ([MortgageRelatedfg],[IndigoClientId]) 
GO
CREATE NONCLUSTERED INDEX IX_TPlanPurpose_IndigoClientId ON [dbo].[TPlanPurpose] ([IndigoClientId]) 
GO