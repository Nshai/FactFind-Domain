CREATE TABLE [dbo].[TLifeCycleTransitionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleStepId] [int] NOT NULL,
[ToLifeCycleStepId] [int] NOT NULL,
[OrderNumber] [int] NULL,
[Type] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[HideStep] [bit] NULL,
[AddToCommissionsFg] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCycle_ConcurrencyId_2__56] DEFAULT ((1)),
[LifeCycleTransitionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLifeCycle_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLifeCycleTransitionAudit] ADD CONSTRAINT [PK_TLifeCycleTransitionAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TLifeCycleTransitionAudit_LifeCycleTransitionId_ConcurrencyId] ON [dbo].[TLifeCycleTransitionAudit] ([LifeCycleTransitionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
