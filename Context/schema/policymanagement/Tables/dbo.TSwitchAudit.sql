CREATE TABLE [dbo].[TSwitchAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefProdProviderId] [int] NULL,
[RefPlanTypeId] [int] NOT NULL,
[Value] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSwitchAud_ConcurrencyId_1__56] DEFAULT ((1)),
[SwitchId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSwitchAud_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSwitchAudit] ADD CONSTRAINT [PK_TSwitchAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSwitchAudit_SwitchId_ConcurrencyId] ON [dbo].[TSwitchAudit] ([SwitchId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
