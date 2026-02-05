CREATE TABLE [dbo].[TQuotationBasisAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuotationBasisType] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[MinValue] [decimal] (19, 2) NOT NULL,
[MaxValue] [decimal] (19, 2) NOT NULL,
[RateOfIncrease] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[QuotationBasisId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuotationBasisAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuotationBasisAudit] ADD CONSTRAINT [PK_TQuotationBasisAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
