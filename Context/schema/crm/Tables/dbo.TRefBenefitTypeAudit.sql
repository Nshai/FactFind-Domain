CREATE TABLE [dbo].[TRefBenefitTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefBenefitTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefBenefi_StampDateTime_1__57] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBenefitTypeAudit] ADD CONSTRAINT [PK_TRefBenefitTypeAudit_2__57] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefBenefitTypeAudit_RefBenefitTypeId_ConcurrencyId] ON [dbo].[TRefBenefitTypeAudit] ([RefBenefitTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
