CREATE TABLE [dbo].[TIntroducerEmployeeBranchAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerEmployeeId] [int] NULL,
[IntroducerBranchId] [int] NULL,
[ConcurrencyId] [int] NULL,
[IntroducerEmployeeBranchId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntroducerEmployeeBranchAudit] ADD CONSTRAINT [PK_TIntroducerEmployeeBranchAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
