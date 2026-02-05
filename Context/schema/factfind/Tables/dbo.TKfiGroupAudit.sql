CREATE TABLE [dbo].[TKfiGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[QuoteId] [int] NOT NULL,
[GenerationDate] [datetime] NOT NULL CONSTRAINT [DF_TKfiGroupAudit_GenerationDate] DEFAULT (getdate()),
[EmailClient] [bit] NOT NULL CONSTRAINT [DF_TKfiGroupAudit_EmailClient] DEFAULT ((0)),
[GenerateAdviserSummary] [bit] NOT NULL CONSTRAINT [DF_TKfiGroupAudit_GenerateAdviserSummary] DEFAULT ((0)),
[AdviserSummaryDocVersionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TKfiGroupAudit_ConcurrencyId] DEFAULT ((1)),
[KfiGroupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TKfiGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TKfiGroupAudit] ADD CONSTRAINT [PK_TKfiGroupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TKfiGroupAudit_KfiGroupId_ConcurrencyId] ON [dbo].[TKfiGroupAudit] ([KfiGroupId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
