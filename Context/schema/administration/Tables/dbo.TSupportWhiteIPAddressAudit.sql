CREATE TABLE [dbo].[TSupportWhiteIPAddressAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SupportWhiteIPAddressId] [bigint] NOT NULL,
[IPAddressRangeStart] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[IPAddressRangeEnd] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTSupportWhiteIPAddress_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSupportWhiteIPAddressAudit] ADD CONSTRAINT [PK_TSupportWhiteIPAddressAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
