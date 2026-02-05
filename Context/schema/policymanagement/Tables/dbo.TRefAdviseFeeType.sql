CREATE TABLE [dbo].[TRefAdviseFeeType]
(
[RefAdviseFeeTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
IsInitial bit NOT NULL,
IsOneOff bit NOT NULL,
IsRecurring bit NOT NULL
)
GO
ALTER TABLE [dbo].[TRefAdviseFeeType] ADD CONSTRAINT [PK_TRefAdviseFeeType] PRIMARY KEY CLUSTERED  ([RefAdviseFeeTypeId])
GO

ALTER TABLE [dbo].[TRefAdviseFeeType]
ADD CONSTRAINT DF_TRefAdviseFeeType_IsInitial DEFAULT (0)  FOR [IsInitial]
GO

ALTER TABLE [dbo].[TRefAdviseFeeType]
ADD CONSTRAINT DF_TRefAdviseFeeType_IsOneOff DEFAULT (0)  FOR [IsOneOff]
GO

ALTER TABLE [dbo].[TRefAdviseFeeType]
ADD CONSTRAINT DF_TRefAdviseFeeType_IsRecurring DEFAULT (0)  FOR [IsRecurring]
GO


