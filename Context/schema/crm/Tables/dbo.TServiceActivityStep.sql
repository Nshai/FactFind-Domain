CREATE TABLE [dbo].[TServiceActivityStep]
(
   [Id] INT IDENTITY(1,1),
   [ServiceActivityId] INT NOT NULL,
   [Name] VARCHAR(100) NOT NULL,
   [DisplayName] VARCHAR(100) NULL,
   [Href] VARCHAR(200) NULL,
   [Status] VARCHAR(50) NULL,
   [StartedAt] DATETIME NULL,
   [LastUpdatedAt] DATETIME NULL,
   [LastUpdatedBy] INT NULL,
   [CompletedAt] DATETIME NULL,
   [CompletedBy] INT NULL,

CONSTRAINT [PK_TServiceActivityStepId] PRIMARY KEY CLUSTERED  ([Id])
)
GO
ALTER TABLE [dbo].[TServiceActivityStep] ADD CONSTRAINT [FK_TServiceActivityStep_ServiceActivityId] FOREIGN KEY ([ServiceActivityId]) REFERENCES [dbo].[TServiceActivity] ([Id])
GO