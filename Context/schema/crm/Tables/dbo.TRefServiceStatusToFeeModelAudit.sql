CREATE TABLE [dbo].[TRefServiceStatusToFeeModelAudit]
(
[Audit] [int] NOT NULL IDENTITY(1, 1),
[RefServiceStatusId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
[IsDefault] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefServiceStatusToFeeModelAudit_ConcurrencyId] DEFAULT ((1)),
[RefServiceStatusToFeeModelId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefServiceStatusToFeeModelAudit] ADD CONSTRAINT [PK_TRefServiceStatusToFeeModelAudit] PRIMARY KEY CLUSTERED  ([Audit])
GO
