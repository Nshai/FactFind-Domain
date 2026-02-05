CREATE TABLE [dbo].[TPropositionType]
(
[PropositionTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PropositionTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TPropositionType_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropositionType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPropositionType] ADD CONSTRAINT [PK_TPropositionType] PRIMARY KEY CLUSTERED  ([PropositionTypeId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IX_TPropositionType] ON [dbo].[TPropositionType] ([PropositionTypeId], [TenantId], [PropositionTypeName])
GO
