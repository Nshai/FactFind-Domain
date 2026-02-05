CREATE TABLE [dbo].[TRefDeferredReason]
(
[RefDeferredReasonId] [int] NOT NULL IDENTITY(1, 1),
[DeferredReason] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefDeferredReason] ADD CONSTRAINT [PK_TRefDeferredReason] PRIMARY KEY CLUSTERED  ([RefDeferredReasonId])
GO
