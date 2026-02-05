CREATE TABLE [dbo].[TQueryResultReferenceStore]
(
[QueryResultReferenceStoreId] [int] NOT NULL IDENTITY(1, 1),
[Reference] [nchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[MIReportId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Data] [varbinary] (max) NOT NULL,
[CreatedTimeStamp] [datetime] NOT NULL CONSTRAINT [DF_TQueryResultReferenceStore_CreatedTimeStamp] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQueryResultReferenceStore_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQueryResultReferenceStore] ADD CONSTRAINT [PK_TQueryResultReferenceStore] PRIMARY KEY CLUSTERED  ([QueryResultReferenceStoreId])
GO
