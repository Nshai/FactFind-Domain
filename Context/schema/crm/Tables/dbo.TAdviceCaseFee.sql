CREATE TABLE [dbo].[TAdviceCaseFee]
(
[AdviceCaseFeeId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[FeeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseFee_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseFee] ADD CONSTRAINT [PK_TAdviceCaseFee] PRIMARY KEY CLUSTERED  ([AdviceCaseFeeId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviceCaseFee_AdviceCaseId] ON [dbo].[TAdviceCaseFee] ([AdviceCaseId]) INCLUDE ([FeeId])
GO