CREATE TABLE [dbo].[TDataProtectionAct]
(
[DataProtectionActId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDataProtectionAct_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[IsAwareOfRights] [tinyint] NULL,
[HasGivenConsent] [tinyint] NULL,
[IsAwareOfAccess] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[TDataProtectionAct] ADD CONSTRAINT [PK_TDataProtectionAct] PRIMARY KEY NONCLUSTERED  ([DataProtectionActId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDataProtectionAct_CRMContactId] ON [dbo].[TDataProtectionAct] ([CRMContactId])
GO
ALTER TABLE [dbo].[TDataProtectionAct] ADD CONSTRAINT [FK_TDataProtectionAct_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
