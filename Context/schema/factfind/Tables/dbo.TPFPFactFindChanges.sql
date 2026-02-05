CREATE TABLE [dbo].[TPFPFactFindChanges]
(
[PFPFactFindChangesId] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [int] NOT NULL,
[AdviserId] [int] NOT NULL,
[Changes] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[Timestamp] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TPFPFactFindChanges] ADD CONSTRAINT [PK_TPFPFactFindChanges] PRIMARY KEY CLUSTERED  ([PFPFactFindChangesId])
GO
