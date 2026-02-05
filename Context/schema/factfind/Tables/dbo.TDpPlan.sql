CREATE TABLE [dbo].[TDpPlan]
(
[DpPlanId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AdviserId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[PlanGuid] [uniqueidentifier] NULL,
[PlanXml] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDpPlan_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDpPlan] ADD CONSTRAINT [PK_TDpPlan] PRIMARY KEY NONCLUSTERED  ([DpPlanId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDpPlan_CRMContactId] ON [dbo].[TDpPlan] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
