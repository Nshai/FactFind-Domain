CREATE TABLE [dbo].[TRefRejectedReason]
(
[RefRejectedReasonId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRejectedReason_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRejectedReason] ADD CONSTRAINT [PK_TRefRejectedReason] PRIMARY KEY CLUSTERED  ([RefRejectedReasonId])
GO
