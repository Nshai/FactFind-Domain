CREATE TABLE [dbo].[TIntroducerExtendedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerExtendedAudit_ConcurrencyId] DEFAULT ((1)),
[IntroducerExtendedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntroducerExtendedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntroducerExtendedAudit] ADD CONSTRAINT [PK_TIntroducerExtendedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TIntroducerExtendedAudit_IntroducerExtendedId_ConcurrencyId] ON [dbo].[TIntroducerExtendedAudit] ([IntroducerExtendedId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
