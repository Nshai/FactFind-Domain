CREATE TABLE [dbo].[TRefPlanValueTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanValueType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL,
[ServiceType] [int] NULL,
[ServiceTypeDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanValueTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefPlanValueTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanValueTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPlanValueTypeAudit] ADD CONSTRAINT [PK_TRefPlanValueTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPlanValueTypeAudit_RefPlanValueTypeId_ConcurrencyId] ON [dbo].[TRefPlanValueTypeAudit] ([RefPlanValueTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
