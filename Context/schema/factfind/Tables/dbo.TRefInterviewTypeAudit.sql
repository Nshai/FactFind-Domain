CREATE TABLE [dbo].[TRefInterviewTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefInterviewTypeId] [int] NOT NULL,
[InterviewType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInterviewTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefInterviewTypeAudit] ADD CONSTRAINT [PK_TRefInterviewTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
