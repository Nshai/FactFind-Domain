CREATE TABLE [dbo].[TRefDeferredReasonAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefDeferredReasonId] [int] NULL,
[DeferredReason] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefDeferredReasonAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
