CREATE TABLE [dbo].[TRefEmploymentStatus]
(
[RefEmploymentStatusId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmploymentStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEmploymentStatus] ADD CONSTRAINT [PK_TRefEmploymentStatus] PRIMARY KEY CLUSTERED  ([RefEmploymentStatusId])
GO
