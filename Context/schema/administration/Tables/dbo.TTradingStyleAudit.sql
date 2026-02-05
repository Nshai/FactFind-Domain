CREATE TABLE [dbo].[TTradingStyleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTradingStyleAudit_ConcurrencyId] DEFAULT ((1)),
[TradingStyleDescription] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[Email] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[PhoneNumber] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FaxNumber] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProcFeePayableTo] [nvarchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
[TradingStyleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTradingStyleAudit] ADD CONSTRAINT [PK_TTradingStyleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
