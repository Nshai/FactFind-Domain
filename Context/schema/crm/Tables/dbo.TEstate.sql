CREATE TABLE [dbo].[TEstate]
(
[EstateId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32)  NOT NULL,
[Selected] [bit] NOT NULL CONSTRAINT [DF_TEstate_Gifts] DEFAULT ((0)),
[Joint] [bit] NOT NULL CONSTRAINT [DF_TEstate_Joint] DEFAULT ((0)),
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [char] (10)  NOT NULL CONSTRAINT [DF_TEstate_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEstate] ADD CONSTRAINT [PK_TEstate_EstateId] PRIMARY KEY CLUSTERED  ([EstateId])
GO
ALTER TABLE [dbo].[TEstate] WITH CHECK ADD CONSTRAINT [FK_TEstate_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
