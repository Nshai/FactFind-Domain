CREATE TABLE [dbo].[TIntroducerGroup]
(
[IntroducerGroupId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerGroup_ConcurrencyId] DEFAULT ((1)),
MigrationRef varchar(255) null
)
GO
ALTER TABLE [dbo].[TIntroducerGroup] ADD CONSTRAINT [PK_TIntroducerGroup] PRIMARY KEY CLUSTERED  ([IntroducerGroupId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerGroup_GroupId] ON [dbo].[TIntroducerGroup] ([GroupId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerGroup_IntroducerId] ON [dbo].[TIntroducerGroup] ([IntroducerId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerGroup_IntroducerId_GroupId] ON [dbo].[TIntroducerGroup] ([IntroducerId], [GroupId]) WITH (FILLFACTOR=80)
GO
create index IX_TIntroducerGroup_MigrationRef on TIntroducerGroup(MigrationRef) 
go 
