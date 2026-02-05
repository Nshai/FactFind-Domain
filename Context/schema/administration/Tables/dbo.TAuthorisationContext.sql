CREATE TABLE [dbo].[TAuthorisationContext]
(
[AuthorisationContextId] [uniqueidentifier] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Token] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[SagaInfo] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[CreatedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TAuthorisationContext] ADD CONSTRAINT [PK_TAuthorisationContext] PRIMARY KEY CLUSTERED  ([AuthorisationContextId])
GO
