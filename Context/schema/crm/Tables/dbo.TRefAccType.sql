CREATE TABLE [dbo].[TRefAccType]
(
[RefAccTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ActiveFG] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAccType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAccType] ADD CONSTRAINT [PK_TRefAccType] PRIMARY KEY NONCLUSTERED  ([RefAccTypeId]) WITH (FILLFACTOR=80)
GO
