CREATE TABLE [dbo].[TRefPaymentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ActiveFG] [tinyint] NULL CONSTRAINT [DF_TRefPaymen_ActiveFG_1__56] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefPaymentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPaymen_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPaymentTypeAudit] ADD CONSTRAINT [PK_TRefPaymentTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefPaymentTypeAudit_RefPaymentTypeId_ConcurrencyId] ON [dbo].[TRefPaymentTypeAudit] ([RefPaymentTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
