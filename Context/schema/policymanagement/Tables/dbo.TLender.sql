CREATE TABLE [dbo].[TLender]
(
[LenderId] [int] NOT NULL IDENTITY(1, 1),
[LenderName] [varchar] (120) COLLATE Latin1_General_CI_AS NOT NULL,
[Url] [varchar] (120) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLender_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLender] ADD CONSTRAINT [PK_TLender] PRIMARY KEY CLUSTERED  ([LenderId])
GO
