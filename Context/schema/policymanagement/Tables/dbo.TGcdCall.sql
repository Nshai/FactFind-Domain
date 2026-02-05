CREATE TABLE [dbo].[TGcdCall]
(
[GcdCallId] [int] NOT NULL IDENTITY(1, 1),
[RequestDate] [datetime] NOT NULL,
[UserId] [int] NOT NULL,
[UserGuid] [uniqueidentifier] NOT NULL,
[Agency] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Type] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[RequestXML] [xml] NOT NULL,
[ResponseXML] [xml] NULL,
[Error] [varchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGcdCall] ADD CONSTRAINT [PK_TGcdCall] PRIMARY KEY CLUSTERED  ([GcdCallId])
GO
