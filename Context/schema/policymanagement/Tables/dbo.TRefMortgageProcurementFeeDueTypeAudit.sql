CREATE TABLE [dbo].[TRefMortgageProcurementFeeDueTypeAudit]
(
[Audit] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[RefMortgageProcurementFeeDueTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefMortgageProcurementFeeDueTypeAudit] ADD CONSTRAINT [PK_TRefMortgageProcurementFeeDueTypeAudit] PRIMARY KEY CLUSTERED  ([Audit])
GO
