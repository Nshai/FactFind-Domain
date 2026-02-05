CREATE TABLE [dbo].[TQueryEngineSQLLog]
(
[QueryEngineSQLLogId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[StartDateTime] [datetime] NOT NULL,
[EndDateTime] [datetime] NULL,
[QueryTypeId] [int] NOT NULL,
[QueryResultReference] [varchar] (100) ,
[SqlScript] [varchar] (max) ,
[SqlParameters] [varchar] (max) ,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQueryEngineSQLLog_ConcurrencyId] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TQueryEngineSQLLog] ADD CONSTRAINT [PK_TQueryEngineSQLLog] PRIMARY KEY CLUSTERED  ([QueryEngineSQLLogId]) ON [PRIMARY]
GO
