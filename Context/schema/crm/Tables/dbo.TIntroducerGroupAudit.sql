CREATE TABLE [dbo].[TIntroducerGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerGroupAudit_ConcurrencyId] DEFAULT ((1)),
[IntroducerGroupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntroducerGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
MigrationRef varchar(255) null
)
GO
ALTER TABLE [dbo].[TIntroducerGroupAudit] ADD CONSTRAINT [PK_TIntroducerGroupAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
