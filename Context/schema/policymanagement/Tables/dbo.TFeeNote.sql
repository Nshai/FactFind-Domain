CREATE TABLE [dbo].[TFeeNote]
(
[FeeNoteId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedBy] [int] NOT NULL,
[LastEdited] [datetime] NOT NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[FeeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeNote_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeNote] ADD CONSTRAINT [PK_TFeeNote_FeeNoteId] PRIMARY KEY CLUSTERED  ([FeeNoteId])
GO
ALTER TABLE [dbo].[TFeeNote] ADD CONSTRAINT [FK_TFeeNote_TFee] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TFeeNote] ADD CONSTRAINT [DF_TFeeNote_UpdatedBy] DEFAULT ((0)) FOR [UpdatedBy]
GO
