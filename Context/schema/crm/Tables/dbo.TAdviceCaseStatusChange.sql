CREATE TABLE [dbo].[TAdviceCaseStatusChange]
(
[AdviceCaseStatusChangeId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AdviceCaseStatusIdFrom] [int] NOT NULL,
[AdviceCaseStatusIdTo] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusChange_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatusChange] ADD CONSTRAINT [PK_TAdviceCaseStatusChange] PRIMARY KEY NONCLUSTERED  ([AdviceCaseStatusChangeId])
GO
