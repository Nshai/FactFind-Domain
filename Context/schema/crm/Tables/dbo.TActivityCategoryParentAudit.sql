CREATE TABLE [dbo].[TActivityCategoryParentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategoryParentAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityCategoryParentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCategoryParentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF__TActivity__IsArc__61E72FB9] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActivityCategoryParentAudit] ADD CONSTRAINT [PK_TActivityCategoryParentAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
