CREATE TABLE [dbo].[TEmailQueueAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[OwnerId] [int] NULL,
[QueueDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StatusId] [int] NULL,
[ToAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FromAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CcAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BccAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Body] [text] COLLATE Latin1_General_CI_AS NULL,
[PreMergedFg] [bit] NOT NULL CONSTRAINT [DF_TEmailQueueAudit_PreMergedFg] DEFAULT ((0)),
[Guid] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MergeData] [text] COLLATE Latin1_General_CI_AS NULL,
[AddedDate] [datetime] NOT NULL CONSTRAINT [DF_TEmailQueueAudit_AddedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailQueueAudit_ConcurrencyId] DEFAULT ((1)),
[EmailQueueId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmailQueueAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmailQueueAudit] ADD CONSTRAINT [PK_TEmailQueueAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
