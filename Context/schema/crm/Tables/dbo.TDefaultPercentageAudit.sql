CREATE TABLE [dbo].[TDefaultPercentageAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Percentage] [decimal] (10, 2) NULL,
[GroupingId] [int] NULL,
[PaymentEntityId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDefaultPe_ConcurrencyId_1__56] DEFAULT ((1)),
[DefaultPercentageId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDefaultPe_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDefaultPercentageAudit] ADD CONSTRAINT [PK_TDefaultPercentageAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TDefaultPercentageAudit_DefaultPercentageId_ConcurrencyId] ON [dbo].[TDefaultPercentageAudit] ([DefaultPercentageId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
