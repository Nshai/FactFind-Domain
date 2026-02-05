CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TNeedsAndPrioritiesQuestionsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NULL,
[RefPersonalCategoryId] [int] NULL,
[RefCorporateCategoryId] [int] NULL,
[RefTrustCategoryId] [int] NULL,
[IsForProfile] [bit] NULL,
[IsTextArea] [bit] NULL,
[NeedsAndPrioritiesSubCategoryId] [int] NULL,
[ControlTypeId] [tinyint] NULL,
[PlaceHolderText] [nvarchar](1000) NULL,
[HelpText] [nvarchar](1000) NULL,
[ErrorText] [nvarchar](1000) NULL,
[Pattern] [varchar](200) NULL,
[IsRequired] [bit] NULL
)
GO
ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionAudit] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
