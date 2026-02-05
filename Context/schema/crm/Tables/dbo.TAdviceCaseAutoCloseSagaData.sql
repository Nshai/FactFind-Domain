CREATE TABLE [dbo].[TAdviceCaseAutoCloseSagaData]
(
[AdviceCaseAutoCloseSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2058) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2058) COLLATE Latin1_General_CI_AS NOT NULL,
[AdviceCaseAutoCloseStatusRuleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CloseAdviseCaseDays] [int] NOT NULL,
[AppliedToRule] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseAutoCloseSagaData] ADD CONSTRAINT [PK_TAdviceCaseAutoCloseSagaData] PRIMARY KEY CLUSTERED  ([AdviceCaseAutoCloseSagaDataId])
GO
