CREATE TABLE [dbo].[TProviderPlanTypeCodeAudit]
(
    [AuditId] int NOT NULL IDENTITY(1, 1),
    [ProviderPlanTypeCodeId] int NOT NULL,
    [RefPlanType2ProdSubTypeId] int NOT NULL,
    [ProdProviderId] int NOT NULL,
    [Code] nvarchar(10) NOT NULL,
    [Abbreviation] nvarchar(50) NULL,
    [StampAction] char (1) NOT NULL,
    [StampDateTime] datetime NULL CONSTRAINT [DF_TProviderPlanTypeCodeAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] varchar (255) NULL
)
GO
ALTER TABLE [dbo].[TProviderPlanTypeCodeAudit] ADD CONSTRAINT [PK_TProviderPlanTypeCodeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProviderPlanTypeCodeAudit_ProviderPlanTypeCodeId_ConcurrencyId] ON [dbo].[TProviderPlanTypeCodeAudit] ([ProviderPlanTypeCodeId])
GO
