CREATE TABLE [dbo].[TClientPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientPla_ConcurrencyId_1__56] DEFAULT ((1)),
[ClientPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientPla_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientPlanTypeAudit] ADD CONSTRAINT [PK_TClientPlanTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TClientPlanTypeAudit_ClientPlanTypeId_ConcurrencyId] ON [dbo].[TClientPlanTypeAudit] ([ClientPlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
