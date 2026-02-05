CREATE TABLE [dbo].[TSecureMessageUserAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SecureMessageUserId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[Name] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSecureMessageUserAudit] ADD CONSTRAINT [PK_TSecureMessageUserAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
