CREATE TABLE [dbo].[TAdviceCaseProperty]
(
[AdviceCasePropertyId] [bigint] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[Key] [nvarchar](255) NOT NULL,
[Value] [nvarchar](255) NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[LastUpdatedOn] [datetime] NOT NULL
)
ALTER TABLE [dbo].[TAdviceCaseProperty] ADD CONSTRAINT [PK_TAdviceCaseProperty] PRIMARY KEY NONCLUSTERED ([AdviceCasePropertyId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviceCaseProperty_AdviceCaseId] ON [dbo].[TAdviceCaseProperty] ([AdviceCaseId])
GO