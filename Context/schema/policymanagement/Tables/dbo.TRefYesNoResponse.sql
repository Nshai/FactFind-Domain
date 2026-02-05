CREATE TABLE [dbo].[TRefYesNoResponse]
(
[RefYesNoResponseId] [tinyint] NOT NULL IDENTITY(0, 1),
[Value] [varchar] (15) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefYesNoResponse] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefYesNoResponse] ADD CONSTRAINT [PK_TRefYesNoResponse] PRIMARY KEY CLUSTERED  ([RefYesNoResponseId])
GO
