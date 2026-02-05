CREATE TABLE [dbo].[TRefYesNoClosedResponseAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [Name] [varchar] (15) NOT NULL,
    [ConcurrencyId] [int] NOT NULL,
    [RefYesNoClosedResponseId] [tinyint] NOT NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefYesNoClosedResponseAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL
)
GO

ALTER TABLE [dbo].[TRefYesNoClosedResponseAudit] ADD CONSTRAINT [PK_TRefYesNoClosedResponseAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO
