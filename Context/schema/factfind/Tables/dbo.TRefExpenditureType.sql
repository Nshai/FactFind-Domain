CREATE TABLE [dbo].[TRefExpenditureType]
(
[RefExpenditureTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefExpenditureType_ConcurrencyId] DEFAULT ((1)),
[RefExpenditureGroupId] [tinyint] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Attributes] [nvarchar] (MAX) NULL
)
GO
ALTER TABLE [dbo].[TRefExpenditureType] ADD CONSTRAINT [PK_TRefExpenditureType] PRIMARY KEY NONCLUSTERED  ([RefExpenditureTypeId])
GO
