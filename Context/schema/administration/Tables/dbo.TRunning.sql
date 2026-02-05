CREATE TABLE [dbo].[TRunning]
(
[RunningId] [int] NOT NULL IDENTITY(1, 1),
[RebuildKeys] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
