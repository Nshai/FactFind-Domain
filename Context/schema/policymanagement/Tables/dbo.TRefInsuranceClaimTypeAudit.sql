CREATE TABLE [dbo].[TRefInsuranceClaimTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefInsuranceClaimTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInsuranceClaimTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefInsuranceClaimTypeAudit] ADD CONSTRAINT [PK_TRefInsuranceClaimTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
