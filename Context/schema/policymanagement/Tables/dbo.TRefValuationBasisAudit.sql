CREATE TABLE [dbo].[TRefValuationBasisAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValuationBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CalculationType] [tinyint] NULL,
[NumMonths] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefValuationBasisId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefValuat_StampDateTime_1__66] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefValuationBasisAudit] ADD CONSTRAINT [PK_TRefValuationBasisAudit_2__66] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefValuationBasisAudit_RefValuationBasisId_ConcurrencyId] ON [dbo].[TRefValuationBasisAudit] ([RefValuationBasisId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
