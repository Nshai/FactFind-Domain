CREATE TABLE [dbo].[TRefYesNoClosedResponse]
(
    [RefYesNoClosedResponseId] [tinyint] NOT NULL IDENTITY(0, 1),
    [Name] [varchar] (15) NOT NULL,
    [ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefYesNoClosedResponse] DEFAULT ((1))
)
GO

ALTER TABLE [dbo].[TRefYesNoClosedResponse] ADD CONSTRAINT [PK_TRefYesNoClosedResponse] PRIMARY KEY CLUSTERED ([RefYesNoClosedResponseId])
GO
