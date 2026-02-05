CREATE TABLE [dbo].[TKfiAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[KfiGroupId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[QuoteMortgageSourceId] [int] NOT NULL,
[Status] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[XmlSentId] [int] NULL,
[XmlResponseId] [int] NULL,
[KfiDocVersionId] [int] NULL,
[ComplianceSummaryDocVersionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TKfiAudit_ConcurrencyId] DEFAULT ((1)),
[KfiId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TKfiAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TKfiAudit] ADD CONSTRAINT [PK_TKfiAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TKfiAudit_KfiId_ConcurrencyId] ON [dbo].[TKfiAudit] ([KfiId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
