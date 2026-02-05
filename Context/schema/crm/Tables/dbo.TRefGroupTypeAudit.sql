CREATE TABLE [dbo].[TRefGroupTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[Name] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[ParentGroupTypeId] [int] NULL,
[PaymentEntityId] [int] NULL,
[CompanyFg] [tinyint] NULL,
[ArchiveFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefGroupTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefGroupT_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefGroupTypeAudit] ADD CONSTRAINT [PK_TRefGroupTypeAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefGroupTypeAudit_RefGroupTypeId_ConcurrencyId] ON [dbo].[TRefGroupTypeAudit] ([RefGroupTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
