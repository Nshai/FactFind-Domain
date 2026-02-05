CREATE TABLE [dbo].[TValScheduleFileDetail]
(
[ValScheduleFileDetailId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[FilePath] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FileNamePattern] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FieldNames] [varchar] (2000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValScheduleFileDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValScheduleFileDetail] ADD CONSTRAINT [PK_TValScheduleFileDetail] PRIMARY KEY NONCLUSTERED  ([ValScheduleFileDetailId]) WITH (FILLFACTOR=80)
GO
