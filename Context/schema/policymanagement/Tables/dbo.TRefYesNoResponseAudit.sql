CREATE TABLE [dbo].[TRefYesNoResponseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Value] [varchar] (15) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefYesNoResponseId] [tinyint] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefYesNoResponseAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefYesNoResponseAudit] ADD CONSTRAINT [PK_TRefYesNoResponseAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
