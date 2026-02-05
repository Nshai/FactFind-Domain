CREATE TABLE [dbo].[TRefInterest]
(
[RefInterestId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Interest] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OpportunityTypeId] [int] NULL,
[OpportunityCreationFg] [bit] NOT NULL CONSTRAINT [DF_TRefInterest_OpportunityCreationFg] DEFAULT ((0)),
[Probability] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_TRefInterest_Probability] DEFAULT ((0)),
[LeadVersionFG] [bit] NOT NULL CONSTRAINT [DF_TRefInterest_LeadVersionFG] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefInterest_ConcurrencyId] DEFAULT ((1)),
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TRefInterest_ArchiveFG] DEFAULT ((0)),
[Ordinal] [int] NULL,
[SystemFG] [bit] NOT NULL CONSTRAINT [DF_TRefInterest_SystemFG] DEFAULT ((0)),
[DefaultFG] [bit] NULL CONSTRAINT [DF_TRefInterest_DefaultFG] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefInterest] ADD CONSTRAINT [PK_TRefInterest] PRIMARY KEY NONCLUSTERED  ([RefInterestId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_IndigoClientId] ON [dbo].[TRefInterest] ([IndigoClientId], [OpportunityTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefInterest_IndigoClientId] ON [dbo].[TRefInterest] ([IndigoClientId], [OpportunityTypeId])
GO
