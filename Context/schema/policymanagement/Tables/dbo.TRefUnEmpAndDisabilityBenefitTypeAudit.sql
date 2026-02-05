CREATE TABLE [dbo].[TRefUnEmpAndDisabilityBenefitTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefUnEmpAndDisabilityBenefitTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefUnEmpAndDisabilityBenefitTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefUnEmpAndDisabilityBenefitTypeAudit] ADD CONSTRAINT [PK_TRefUnEmpAndDisabilityBenefitTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
