CREATE TABLE [dbo].[TOrigoApplicationNumberMapping](
	[ApplicationNumber] [uniqueidentifier] NOT NULL,
	[CorrelationId] [uniqueidentifier] NOT NULL
)
GO
ALTER TABLE [dbo].[TOrigoApplicationNumberMapping] ADD CONSTRAINT [PK_TOrigoApplicationNumberMapping] PRIMARY KEY NONCLUSTERED  ([ApplicationNumber]) WITH (FILLFACTOR=80)
GO


