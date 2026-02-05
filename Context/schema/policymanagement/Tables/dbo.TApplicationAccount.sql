CREATE TABLE [dbo].[TApplicationAccount]
(
[ApplicationAccountId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AdditionalReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password2] [varbinary] (4000) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TApplicationAccount_ConcurrencyId] DEFAULT ((1)),
[GroupName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Token] [varchar](MAX) NULL,
[TokenExpiryDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TApplicationAccount] ADD CONSTRAINT [PK_TApplicationAccount] PRIMARY KEY NONCLUSTERED  ([ApplicationAccountId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TApplicationAccount] ON [dbo].[TApplicationAccount] ([ApplicationAccountId]) WITH (FILLFACTOR=80)
GO
