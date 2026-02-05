CREATE TABLE [dbo].[TExpectationsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ExpectationsId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[FeeId] [int] NOT NULL,
[Date] [datetime] NULL,
[NetAmount] [decimal] (18, 2) NOT NULL,
[TotalAmount] [decimal] (18, 2) NOT NULL,
[CalculatedAmount] [decimal] (18, 2) NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TExpectationsAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsManual] [bit] NOT NULL CONSTRAINT [DF_TExpectationsAudit_IsManual] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TExpectationsAudit] ADD CONSTRAINT [PK_TExpectationsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TExpectationsAudit_ExpectationsId] ON [dbo].[TExpectationsAudit] ([ExpectationsId]) WITH (FILLFACTOR=80)
GO 
