CREATE TABLE [dbo].[TIntroducerBranch]
(
[IntroducerBranchId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[BranchName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerBranch_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIntroducerBranch] ADD CONSTRAINT [PK_TIntroducerBranch] PRIMARY KEY CLUSTERED  ([IntroducerBranchId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TIntroducerBranch] ADD CONSTRAINT [FK_TIntroducerBranch_TIntroducer] FOREIGN KEY ([IntroducerId]) REFERENCES [dbo].[TIntroducer] ([IntroducerId])
GO
