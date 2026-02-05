CREATE TABLE [dbo].[TMiUserHack]
(
[MiUserHackId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMiUserHack_ConcurrencyId] DEFAULT ((1))
)
GO
