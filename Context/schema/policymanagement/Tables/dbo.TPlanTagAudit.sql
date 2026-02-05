CREATE TABLE [dbo].[TPlanTagAudit]
(
   [AuditId] [int] NOT NULL IDENTITY(1, 1),
   [PlanTagId] [int] NOT NULL,
   [TenantId] [int] NOT NULL,
   [PolicyBusinessId] [int] NOT NULL,
   [Name] [nvarchar](100) NOT NULL,
   [StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
   [StampDateTime] [datetime] NULL,
   [StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO

ALTER TABLE [dbo].[TPlanTagAudit] ADD CONSTRAINT [PK_TPlanTagAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO