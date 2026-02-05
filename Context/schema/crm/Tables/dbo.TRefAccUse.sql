CREATE TABLE [dbo].[TRefAccUse]
(
[RefAccUseId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[AccountUseDesc] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAccUse_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAccUse] ADD CONSTRAINT [PK_TRefAccUse_2__54] PRIMARY KEY NONCLUSTERED  ([RefAccUseId]) WITH (FILLFACTOR=80)
GO
