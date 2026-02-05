CREATE TABLE [dbo].[TIntroducerBranchGroup]
(
[IntroducerBranchGroupId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerBranchId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerBranchGroup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIntroducerBranchGroup] ADD CONSTRAINT [PK_TIntroducerBranchGroup] PRIMARY KEY NONCLUSTERED  ([IntroducerBranchGroupId])
GO
