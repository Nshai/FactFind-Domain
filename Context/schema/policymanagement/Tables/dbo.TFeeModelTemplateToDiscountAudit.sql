CREATE TABLE [dbo].[TFeeModelTemplateToDiscountAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelTemplateId] [int] NOT NULL,
[DiscountId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeModelTemplateToDiscountId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeModelTemplateToDiscountAudit] ADD CONSTRAINT [PK_TFeeModelTemplateToDiscountAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
