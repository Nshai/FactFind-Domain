CREATE TABLE [dbo].[TBenefitAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefBenefitTypeId] [int] NOT NULL,
[EmployeeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[BenefitId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBenefitAu_StampDateTime_1__57] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBenefitAudit] ADD CONSTRAINT [PK_TBenefitAudit_2__57] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TBenefitAudit_BenefitId_ConcurrencyId] ON [dbo].[TBenefitAudit] ([BenefitId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
