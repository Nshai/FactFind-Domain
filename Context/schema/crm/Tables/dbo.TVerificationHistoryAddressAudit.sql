CREATE TABLE [dbo].[TVerificationHistoryAddressAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[LookupDate] [datetime] NOT NULL,
[LookupResult] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[VerificationHistoryAddressId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TVerificationHistoryAddressAudit] ADD CONSTRAINT [PK_TVerificationHistoryAddressAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
