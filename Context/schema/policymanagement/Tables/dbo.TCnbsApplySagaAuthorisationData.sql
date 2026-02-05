CREATE TABLE [dbo].[TCnbsApplySagaAuthorisationData]
(
[CnbsApplySagaAuthorisationDataId] [uniqueidentifier] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TCnbsApplySagaAuthorisationData_CreatedDate] DEFAULT (getdate()),
[IsDeleted] [bit] NULL,
[ExternalReference] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TCnbsApplySagaAuthorisationData] ADD CONSTRAINT [PK_TCnbsApplySagaAuthorisationData] PRIMARY KEY CLUSTERED  ([CnbsApplySagaAuthorisationDataId])
GO
