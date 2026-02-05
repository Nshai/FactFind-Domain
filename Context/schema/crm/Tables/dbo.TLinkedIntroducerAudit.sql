CREATE TABLE [dbo].[TLinkedIntroducerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LinkedIntroducerId] [int] NOT NULL,
[CorporateIntroducerId] [int] NOT NULL,
[PersonIntroducerId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLinkedIntroducerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLinkedIntroducerAudit] ADD CONSTRAINT [PK_TLinkedIntroducerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
