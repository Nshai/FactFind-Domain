CREATE TABLE [dbo].[TRefIllnessConditionType]
(
[RefIllnessConditionTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefIllnessConditionType] ADD CONSTRAINT [PK_TRefIllnessConditionType] PRIMARY KEY CLUSTERED  ([RefIllnessConditionTypeId])
GO
