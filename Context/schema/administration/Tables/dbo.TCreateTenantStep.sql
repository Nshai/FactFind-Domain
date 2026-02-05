SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE dbo.TCreateTenantStep(
	Id bigint IDENTITY(1,1) NOT NULL,
	SourceTenantId bigint NULL,
	NewTenantId bigint NULL,
	StepName nvarchar(max) NOT NULL,
	StartedAt datetime NULL,
	FinishedAt datetime NULL,
	NumberOfExecutions int NULL,
	ExecutedBy sysname NOT NULL,
	StepPayload nvarchar(max) NULL
)
GO

ALTER TABLE dbo.TCreateTenantStep ADD  CONSTRAINT DF_TCreateTenantStep_StartedAt  DEFAULT (getdate()) FOR StartedAt
GO

ALTER TABLE dbo.TCreateTenantStep ADD  CONSTRAINT DF_TCreateTenantStep_NumberOfExecutions  DEFAULT ((0)) FOR NumberOfExecutions
GO

ALTER TABLE dbo.TCreateTenantStep ADD  CONSTRAINT DF_TCreateTenantStep_ExecutedBy  DEFAULT (suser_name()) FOR ExecutedBy
GO

CREATE UNIQUE CLUSTERED INDEX PK_TCreateTenantStep ON dbo.TCreateTenantStep([Id] ASC)
CREATE NONCLUSTERED INDEX IX_TCreateTenantStep_SourceTenantId ON dbo.TCreateTenantStep(SourceTenantId ASC)
CREATE NONCLUSTERED INDEX IX_TCreateTenantStep_NewTenantId ON dbo.TCreateTenantStep(NewTenantId ASC)

GO
