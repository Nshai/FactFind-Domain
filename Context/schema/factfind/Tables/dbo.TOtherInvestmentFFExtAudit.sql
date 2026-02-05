CREATE TABLE [dbo].[TOtherInvestmentFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ExistingOtherInvestments] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[OtherInvestmentFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOtherInvestmentFFExtAudit] ADD CONSTRAINT [PK_TOtherInvestmentFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
