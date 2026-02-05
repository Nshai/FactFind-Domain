CREATE TABLE [dbo].[TRefNeedsAndPrioritiesCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefNeedsAndPrioritiesCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CategoryName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsCorporate] [bit] NOT NULL,
[CategoryType] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefNeedsAndPrioritiesCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefNeedsAndPrioritiesCategoryAudit] ADD CONSTRAINT [PK_TRefNeedsAndPrioritiesCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
