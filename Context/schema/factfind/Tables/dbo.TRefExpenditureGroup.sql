CREATE TABLE [dbo].[TRefExpenditureGroup]
(
[RefExpenditureGroupId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefExpenditureGroup_ConcurrencyId] DEFAULT ((1)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Ordinal] [tinyint] NULL,
[IsConsolidateEnabled] [bit] NOT NULL CONSTRAINT [DF_TRefExpenditureGroup_IsConsolidateEnabled] DEFAULT ((1)),
[TenantId] [int] NULL,
[RegionCode] [nvarchar](2) NULL,
[Attributes] [nvarchar](MAX) NULL
)
GO
ALTER TABLE [dbo].[TRefExpenditureGroup] ADD CONSTRAINT [PK_TRefExpenditureGroup] PRIMARY KEY CLUSTERED  ([RefExpenditureGroupId])
CREATE NONCLUSTERED INDEX [IDX_TRefExpenditureGroup_TenantId] ON [dbo].[TRefExpenditureGroup] ([TenantId])
GO
