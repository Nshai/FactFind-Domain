CREATE TABLE [dbo].[TApplicationAccountAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AdditionalReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password2] [varbinary] (4000) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TApplicationAccountAudit_ConcurrencyId] DEFAULT ((1)),
[ApplicationAccountId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TApplicationAccountAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GroupName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Token] [varchar](MAX) NULL,
[TokenExpiryDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TApplicationAccountAudit] ADD CONSTRAINT [PK_TApplicationAccountAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TApplicationAccountAudit_ApplicationAccountId_ConcurrencyId] ON [dbo].[TApplicationAccountAudit] ([ApplicationAccountId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
