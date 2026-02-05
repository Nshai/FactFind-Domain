CREATE TABLE [dbo].[TSavingsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[Income] [money] NULL,
[PurchasedOn] [datetime] NULL,
[IsJoint] [bit] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[SavingsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSavingsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSavingsAudit] ADD CONSTRAINT [PK_TSavingsAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSavingsAudit_Savings_ConcurrencyId] ON [dbo].[TSavingsAudit] ([SavingsId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
