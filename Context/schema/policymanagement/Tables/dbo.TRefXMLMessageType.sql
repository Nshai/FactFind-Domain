CREATE TABLE [dbo].[TRefXMLMessageType]
(
[RefXMLMessageTypeId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefXMLMessageType_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefXMLMessageType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefXMLMessageType] ADD CONSTRAINT [PK_TRefXMLMessageType] PRIMARY KEY NONCLUSTERED  ([RefXMLMessageTypeId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefXMLMessageType] ON [dbo].[TRefXMLMessageType] ([RefXMLMessageTypeId]) WITH (FILLFACTOR=80)
GO
