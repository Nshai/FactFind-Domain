CREATE TABLE [dbo].[TRefAsuPhiCoverTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefAsuPhiCoverTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAsuPhiCoverTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAsuPhiCoverTypeAudit] ADD CONSTRAINT [PK_TRefAsuPhiCoverTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
