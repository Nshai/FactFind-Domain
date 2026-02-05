CREATE TABLE [dbo].[TMultiTieConfig]
(
[MultiTieConfigId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MultiTieName] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMultiTieConfig_ConcurrencyId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF__TMultiTie__IsArc__328DEDA9] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TMultiTieConfig] ADD CONSTRAINT [PK_TMultiTieConfig] PRIMARY KEY CLUSTERED  ([MultiTieConfigId])
GO
