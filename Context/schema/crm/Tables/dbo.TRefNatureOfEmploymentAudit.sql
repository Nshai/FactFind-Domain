CREATE TABLE [dbo].[TRefNatureOfEmploymentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefNatureOfEmploymentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefNature_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefNatureOfEmploymentAudit] ADD CONSTRAINT [PK_TRefNatureOfEmploymentAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefNatureOfEmploymentAudit_RefNatureOfEmploymentId_ConcurrencyId] ON [dbo].[TRefNatureOfEmploymentAudit] ([RefNatureOfEmploymentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
