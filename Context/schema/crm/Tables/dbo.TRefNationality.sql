CREATE TABLE [dbo].[TRefNationality]
(
[RefNationalityId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNationality_ConcurrencyId] DEFAULT ((1)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefNationality_IsArchived] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefNationality] ADD CONSTRAINT [PK_TRefNationality] PRIMARY KEY CLUSTERED  ([RefNationalityId])
GO
