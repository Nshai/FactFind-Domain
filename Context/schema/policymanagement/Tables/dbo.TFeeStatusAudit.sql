CREATE TABLE [dbo].[TFeeStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[Status] [varchar] (50)  NOT NULL,
[StatusNotes] [varchar] (250)  NULL,
[StatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeStatusAudit_ConcurrencyId] DEFAULT ((1)),
[FeeStatusId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFeeStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL
)
GO
ALTER TABLE [dbo].[TFeeStatusAudit] ADD CONSTRAINT [PK_TFeeStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFeeStatusAudit_FeeStatusId_ConcurrencyId] ON [dbo].[TFeeStatusAudit] ([FeeStatusId], [ConcurrencyId])
GO
