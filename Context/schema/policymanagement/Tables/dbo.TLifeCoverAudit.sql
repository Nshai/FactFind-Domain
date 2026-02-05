CREATE TABLE [dbo].[TLifeCoverAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Amount] [money] NULL,
[Term] [int] NULL,
[RefPremiumTypeId] [int] NULL,
[RefPaymentBasisId] [int] NULL,
[RefPaymentTypeId] [int] NULL,
[RefOptionsId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCoverAudit_ConcurrencyId] DEFAULT ((1)),
[LifeCoverId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLifeCoverAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLifeCoverAudit] ADD CONSTRAINT [PK_TLifeCoverAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TLifeCoverAudit_LifeCoverId_ConcurrencyId] ON [dbo].[TLifeCoverAudit] ([LifeCoverId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
