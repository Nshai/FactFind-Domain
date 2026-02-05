CREATE TABLE [dbo].[TRefEquityLoanSchemeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefEquityLoanSchemeId] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
