CREATE TABLE [dbo].[TAwkwardUser]
(
[AwkwardUserId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[IsExempt] [bit] NOT NULL CONSTRAINT [DF_TAwkwardUser_IsExempt] DEFAULT ((0)),
[DateAdded] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAwkwardUser_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAwkwardUser] ADD CONSTRAINT [PK_TAwkwardUser] PRIMARY KEY NONCLUSTERED  ([AwkwardUserId]) WITH (FILLFACTOR=80)
GO
