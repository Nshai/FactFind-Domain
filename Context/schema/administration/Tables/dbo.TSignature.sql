CREATE TABLE [dbo].[TSignature]
(
[SignatureId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[Name] [varchar] (255)  NOT NULL,
[Value] [text]  NULL,
[DefaultFg] [bit] NOT NULL CONSTRAINT [DF_TSignature_DefaultFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSignature_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSignature] ADD CONSTRAINT [PK_TSignature] PRIMARY KEY CLUSTERED  ([SignatureId])
GO
CREATE NONCLUSTERED INDEX [IX_TSignature_UserIdASC] ON [dbo].[TSignature] ([UserId])
GO
ALTER TABLE [dbo].[TSignature] WITH CHECK ADD CONSTRAINT [FK_TSignature_TUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
