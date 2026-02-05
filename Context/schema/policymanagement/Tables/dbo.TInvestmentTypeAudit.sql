CREATE TABLE [dbo].[TInvestmentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[InvestmentCategoryId] [int] NOT NULL,
[DefaultRiskRating] [int] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentTypeAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[InvestmentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentTypeAudit] ADD CONSTRAINT [PK_TInvestmentTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
