CREATE TABLE [dbo].[TRefUnderwriting]
(
[RefUnderwritingId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (500) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefUnderwriting] ADD CONSTRAINT [PK_TRefUnderwriting] PRIMARY KEY CLUSTERED  ([RefUnderwritingId])
GO
