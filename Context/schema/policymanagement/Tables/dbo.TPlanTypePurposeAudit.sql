CREATE TABLE [dbo].[TPlanTypePurposeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NULL,
[PlanPurposeId] [int] NOT NULL,
[DefaultFg] [bit] NULL CONSTRAINT [DF_TPlanTypePurposeAudit_DefaultFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanTypeP_ConcurrencyId_1__56] DEFAULT ((1)),
[PlanTypePurposeId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL CONSTRAINT [DF_TPlanTypePurposeAudit_RefPlanType2ProdSubTypeId]  DEFAULT ((0)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanTypeP_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPlanTypePurposeAudit] ADD CONSTRAINT [PK_TPlanTypePurposeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPlanTypePurposeAudit_PlanTypePurposeId_ConcurrencyId] ON [dbo].[TPlanTypePurposeAudit] ([PlanTypePurposeId], [ConcurrencyId]) WITH (FILLFACTOR=75)
GO
