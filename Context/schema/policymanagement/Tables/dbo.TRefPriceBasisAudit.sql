CREATE TABLE [dbo].[TRefPriceBasisAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PriceBasis] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL CONSTRAINT [DF_TRefPriceBasisAudit_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPriceBasisAudit_ConcurrencyId] DEFAULT ((1)),
[RefPriceBasisId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPriceBasisAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPriceBasisAudit] ADD CONSTRAINT [PK_TRefPriceBasisAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefPriceBasisAudit_RefPriceBasisId_ConcurrencyId] ON [dbo].[TRefPriceBasisAudit] ([RefPriceBasisId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
