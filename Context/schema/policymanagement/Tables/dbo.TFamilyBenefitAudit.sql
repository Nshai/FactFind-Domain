CREATE TABLE [dbo].[TFamilyBenefitAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IncomeBenefitFG] [bit] NOT NULL,
[Amount] [money] NULL,
[RefFrequencyId] [int] NULL,
[UntilDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[FamilyBenefitId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFamilyBenefitAudit] ADD CONSTRAINT [PK_TFamilyBenefitAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFamilyBenefitAudit_FamilyBenefitId_ConcurrencyId] ON [dbo].[TFamilyBenefitAudit] ([FamilyBenefitId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
