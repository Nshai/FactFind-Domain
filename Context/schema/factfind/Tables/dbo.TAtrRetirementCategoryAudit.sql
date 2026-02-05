CREATE TABLE [dbo].[TAtrRetirementCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[AtrCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRetirementCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRetirementCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRetirementCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRetirementCategoryAudit] ADD CONSTRAINT [PK_TAtrRetirementCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRetirementCategoryAudit_AtrRetirementCategoryId_ConcurrencyId] ON [dbo].[TAtrRetirementCategoryAudit] ([AtrRetirementCategoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
