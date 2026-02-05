CREATE TABLE [dbo].[TIntroducerEmployee]
(
[IntroducerEmployeeId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerEmployee_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIntroducerEmployee] ADD CONSTRAINT [PK_TIntroducerEmployee] PRIMARY KEY NONCLUSTERED  ([IntroducerEmployeeId])
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerEmployee_IntroducerId] ON [dbo].[TIntroducerEmployee] ([IntroducerId])
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerEmployee_TenantId] ON [dbo].[TIntroducerEmployee] ([TenantId])
GO
ALTER TABLE [dbo].[TIntroducerEmployee] ADD CONSTRAINT [FK_TIntroducerEmployee_TIntroducerEmployee] FOREIGN KEY ([IntroducerEmployeeId]) REFERENCES [dbo].[TIntroducerEmployee] ([IntroducerEmployeeId])
GO
