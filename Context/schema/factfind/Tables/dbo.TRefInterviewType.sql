CREATE TABLE [dbo].[TRefInterviewType]
(
[RefInterviewTypeId] [int] NOT NULL IDENTITY(1, 1),
[InterviewType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefInterviewType] ADD CONSTRAINT [PK_TRefInterviewType] PRIMARY KEY CLUSTERED  ([RefInterviewTypeId])
GO
