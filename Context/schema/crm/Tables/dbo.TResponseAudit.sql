CREATE TABLE [dbo].[TResponseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuestionId] [int] NOT NULL,
[Answer] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[ResponseId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TResponseA_StampDateTime_1__61] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TResponseAudit] ADD CONSTRAINT [PK_TResponseAudit_2__61] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TResponseAudit_ResponseId_ConcurrencyId] ON [dbo].[TResponseAudit] ([ResponseId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
