CREATE TABLE [dbo].[TDpPlanAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AdviserId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[PlanGuid] [uniqueidentifier] NULL,
[PlanXml] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDpPlanAudit_ConcurrencyId] DEFAULT ((1)),
[DpPlanId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDpPlanAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDpPlanAudit] ADD CONSTRAINT [PK_TDpPlanAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
