CREATE TABLE [dbo].[TIndigoClientAdviceCaseStatus]
(
[IndigoClientAdviceCaseStatusId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AdviceCaseStatusId] [int] NOT NULL,
[isArchived] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientAdviceCaseStatus_isArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientAdviceCaseStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIndigoClientAdviceCaseStatus] ADD CONSTRAINT [PK_TIndigoClientAdviceCaseStatus] PRIMARY KEY NONCLUSTERED  ([IndigoClientAdviceCaseStatusId])
GO
