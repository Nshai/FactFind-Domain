CREATE TABLE [dbo].[TAtrRefMatrixDuration]
(
[AtrRefMatrixDurationId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Starting] [tinyint] NULL,
[Ending] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefMatrixDuration_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRefMatrixDuration] ADD CONSTRAINT [PK_TAtrRefMatrixDuration] PRIMARY KEY NONCLUSTERED  ([AtrRefMatrixDurationId]) WITH (FILLFACTOR=80)
GO
