CREATE TABLE [dbo].[TRefFeeStatus]
(
[RefFeeStatusId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFeeStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFeeStatus] ADD CONSTRAINT [PK_TRefFeeStatus] PRIMARY KEY CLUSTERED  ([RefFeeStatusId])
GO
