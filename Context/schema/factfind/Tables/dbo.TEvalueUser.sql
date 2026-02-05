CREATE TABLE [dbo].[TEvalueUser]
(
[EvalueUserId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[UserXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueUser_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueUser] ADD CONSTRAINT [PK_TEvalueUser] PRIMARY KEY NONCLUSTERED  ([EvalueUserId])
GO
