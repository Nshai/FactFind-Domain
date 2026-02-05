CREATE TABLE [dbo].[TIntroducerEmployeeBranch]
(
[IntroducerEmployeeBranchId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerEmployeeId] [int] NULL,
[IntroducerBranchId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerEmployeeBranch_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIntroducerEmployeeBranch] ADD CONSTRAINT [PK_TIntroducerEmployeeBranch] PRIMARY KEY CLUSTERED  ([IntroducerEmployeeBranchId])
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerEmployeeBranch_IntroducerBranchId] ON [dbo].[TIntroducerEmployeeBranch] ([IntroducerBranchId])
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerEmployeeBranch_IntroducerEmployeeId] ON [dbo].[TIntroducerEmployeeBranch] ([IntroducerEmployeeId])
GO
ALTER TABLE [dbo].[TIntroducerEmployeeBranch] ADD CONSTRAINT [FK_TIntroducerEmployeeBranch_TIntroducerBranch] FOREIGN KEY ([IntroducerBranchId]) REFERENCES [dbo].[TIntroducerBranch] ([IntroducerBranchId])
GO
ALTER TABLE [dbo].[TIntroducerEmployeeBranch] ADD CONSTRAINT [FK_TIntroducerEmployeeBranch_TIntroducerEmployee] FOREIGN KEY ([IntroducerEmployeeId]) REFERENCES [dbo].[TIntroducerEmployee] ([IntroducerEmployeeId])
GO
