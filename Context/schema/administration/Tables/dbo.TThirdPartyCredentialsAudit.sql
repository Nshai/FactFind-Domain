CREATE TABLE [dbo].[TThirdPartyCredentialsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[ThirdPartyId] [int] NULL,
[UserDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UserName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password2] [varbinary] (4000) NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TThirdPartyCredentialsAudit_ConcurrencyId] DEFAULT ((1)),
[ThirdPartyCredentialsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TThirdPartyCredentialsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TThirdPartyCredentialsAudit] ADD CONSTRAINT [PK_TThirdPartyCredentialsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TThirdPartyCredentialsAudit_ThirdPartyCredentialsId_ConcurrencyId] ON [dbo].[TThirdPartyCredentialsAudit] ([ThirdPartyCredentialsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
