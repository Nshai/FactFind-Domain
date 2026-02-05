CREATE TABLE [dbo].[TInsuranceClaimAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefInsuranceClaimTypeId] [int] NOT NULL,
[Value] [money] NOT NULL,
[DateOfClaim] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[InsuranceClaimId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInsuranceClaimAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInsuranceClaimAudit] ADD CONSTRAINT [PK_TInsuranceClaimAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
