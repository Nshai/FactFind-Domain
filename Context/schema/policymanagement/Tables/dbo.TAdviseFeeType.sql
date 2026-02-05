CREATE TABLE [dbo].[TAdviseFeeType]
(
[AdviseFeeTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeType_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseFeeType_ConcurrencyId] DEFAULT ((1)),
[IsRecurring] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeType_IsRecurring] DEFAULT ((0)),
[GroupId] [int] NULL CONSTRAINT [DF_TAdviseFeeType_GroupId] DEFAULT (NULL),
[RefAdviseFeeTypeId] [int] NOT NULL CONSTRAINT [DF_TAdviseFeeType_RefAdviseFeeTypeId] DEFAULT ((1)),
[IsSystemDefined] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeType_IsSystemDefined] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAdviseFeeType] ADD CONSTRAINT [PK_TAdviseFeeType] PRIMARY KEY CLUSTERED  ([AdviseFeeTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseFeeType_GroupId] ON [dbo].[TAdviseFeeType] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseFeeType_TenantId] ON [dbo].[TAdviseFeeType] ([TenantId])
GO
