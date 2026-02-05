CREATE TABLE [dbo].[TRefPCLSPaidByAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPCLSPaidById] [int] NOT NULL,
[RefPCLSPaidByName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [int] NULL
)
GO
