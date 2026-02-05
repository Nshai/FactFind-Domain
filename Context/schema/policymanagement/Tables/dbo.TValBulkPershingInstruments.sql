CREATE TABLE [dbo].[TValBulkPershingInstruments]
(
[ValBulkPershingInstrumentsId] [int] NOT NULL IDENTITY(1, 1),
[InstrumentsXml] [text] COLLATE Latin1_General_CI_AS NOT NULL,
[FileDate] [datetime] NOT NULL,
[ValScheduleId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TValBulkPershingInstruments] ADD CONSTRAINT [PK_TValBulkPershingInstruments] PRIMARY KEY CLUSTERED  ([ValBulkPershingInstrumentsId])
GO
