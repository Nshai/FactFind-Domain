CREATE TABLE [dbo].[TLoanProfileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ReviewId] [int] NOT NULL,
[LoanProfileQuestionId] [int] NOT NULL,
[C1Answer] [bit] NOT NULL,
[C2Answer] [bit] NOT NULL,
[CJAnswer] [bit] NOT NULL,
[Details] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[LoanProfileId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLoanProfileAudit] ADD CONSTRAINT [PK_TLoanProfileAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
