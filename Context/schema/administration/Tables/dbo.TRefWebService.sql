CREATE TABLE [dbo].[TRefWebService]
(
[RefWebServiceId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[URL] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[ClassName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[MethodName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[NamedDataSource] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DenyAccess] [bit] NOT NULL CONSTRAINT [DF_TRefWebService_DenyAccess] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefWebService_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefWebService] ADD CONSTRAINT [PK_TRefWebService] PRIMARY KEY NONCLUSTERED  ([RefWebServiceId]) WITH (FILLFACTOR=80)
GO
