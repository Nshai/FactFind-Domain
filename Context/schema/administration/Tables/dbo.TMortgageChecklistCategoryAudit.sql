CREATE TABLE [dbo].[TMortgageChecklistCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MortgageChecklistCategoryId] [int] NOT NULL,
[MortgageChecklistCategoryName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[Ordinal] [int] NULL,
[SystemFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageChecklistCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageChecklistCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageChecklistCategoryAudit] ADD CONSTRAINT [PK_TMortgageChecklistCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
