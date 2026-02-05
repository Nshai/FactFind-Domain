CREATE TABLE [dbo].[TMortgageProcurementFeeAudit]
(
[Audit] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Amount] [money] NOT NULL,
[RefMortgageProcurementFeeDueType] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[MortgageProcurementFeeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageProcurementFeeAudit] ADD CONSTRAINT [PK_TMortgageProcurementFeeAudit] PRIMARY KEY CLUSTERED  ([Audit])
GO
