CREATE TABLE [dbo].[TRefPlanTypeAttributeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[AttributeListId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanTy_ConcurrencyId_3__56] DEFAULT ((1)),
[RefPlanTypeAttributeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanTy_StampDateTime_4__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPlanTypeAttributeAudit] ADD CONSTRAINT [PK_TRefPlanTypeAttributeAudit_5__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefPlanTypeAttributeAudit_RefPlanTypeAttributeId_ConcurrencyId] ON [dbo].[TRefPlanTypeAttributeAudit] ([RefPlanTypeAttributeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
