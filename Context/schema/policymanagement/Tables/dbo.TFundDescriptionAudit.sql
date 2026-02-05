CREATE TABLE [dbo].[TFundDescriptionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundDescr_ConcurrencyId_1__56] DEFAULT ((1)),
[FundDescriptionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFundDescr_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundDescriptionAudit] ADD CONSTRAINT [PK_TFundDescriptionAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFundDescriptionAudit_FundDescriptionId_ConcurrencyId] ON [dbo].[TFundDescriptionAudit] ([FundDescriptionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
