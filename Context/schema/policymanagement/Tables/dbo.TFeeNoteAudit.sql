CREATE TABLE [dbo].[TFeeNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedBy] [int] NULL,
[LastEdited] [datetime] NOT NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[FeeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeNoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeNoteAudit] ADD CONSTRAINT [PK_TFeeNoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
