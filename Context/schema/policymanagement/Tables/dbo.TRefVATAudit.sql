CREATE TABLE [dbo].[TRefVATAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[VATName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[VATRate] [float] NULL,
[IsDefault] [bit] NULL,
[IsArchived] [bit] NULL,
[ConcurrencyId] [int] NULL,
[RefVATId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefVATAud_StampDateTime_1__72] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefVATAudit] ADD CONSTRAINT [PK_TRefVATAudit_2__72] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefVATAudit_RefVATId_ConcurrencyId] ON [dbo].[TRefVATAudit] ([RefVATId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
