CREATE TABLE [dbo].[TFeeModelAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[RefFeeModelStatusId] [int] NOT NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_TFeeModelAudit_IsDefault] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GroupId] [int] NULL,
[IsPropagated] [bit] NULL,
[IsSystemDefined] [bit] NULL,
[IsArchived] [bit] NULL
)
GO
ALTER TABLE [dbo].[TFeeModelAudit] ADD CONSTRAINT [PK_TFeeModelAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
