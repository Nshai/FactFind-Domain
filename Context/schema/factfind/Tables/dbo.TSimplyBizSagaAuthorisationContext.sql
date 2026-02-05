CREATE TABLE [dbo].[TSimplyBizSagaAuthorisationContext]
(
[AuthorisationContextId] [uniqueidentifier] NOT NULL,
[UserId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSimplyBizSagaAuthorisationContext_Id] DEFAULT (newid()),
[TenantId] [int] NOT NULL CONSTRAINT [DF_TSimplyBizSagaAuthorisationContext_TenantId] DEFAULT ((10155))
)
GO
ALTER TABLE [dbo].[TSimplyBizSagaAuthorisationContext] ADD CONSTRAINT [PK_TSimplyBizSagaAuthorisationContext] PRIMARY KEY CLUSTERED  ([Id])
GO
