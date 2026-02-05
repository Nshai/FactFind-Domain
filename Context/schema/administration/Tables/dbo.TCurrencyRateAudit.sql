CREATE TABLE [dbo].[TCurrencyRateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CurrencyCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Rate] [money] NOT NULL,
[Date] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CurrencyRateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCurrencyRateAudit] ADD CONSTRAINT [PK_TCurrencyRateAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
