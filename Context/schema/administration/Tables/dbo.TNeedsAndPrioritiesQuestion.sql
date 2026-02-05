CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestion]
(
[NeedsAndPrioritiesQuestionId] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TNeedsAndPrioritiesQuestion_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNeedsAndPrioritiesQuestion_ConcurrencyId] DEFAULT ((1)),
[TenantId] [int] NULL,
[RefPersonalCategoryId] [int] NULL,
[RefCorporateCategoryId] [int] NULL,
[RefTrustCategoryId] [int] NULL,
[IsForProfile] [bit] NULL,
[IsTextArea] [bit] NULL,
[NeedsAndPrioritiesSubCategoryId] [int] NULL,
[ControlTypeId] [tinyint] NOT NULL CONSTRAINT [DF_TNeedsAndPrioritiesQuestion_ControlTypeId] DEFAULT ((7)),
[PlaceHolderText] [nvarchar](1000) NULL,
[HelpText] [nvarchar](1000) NULL,
[ErrorText] [nvarchar](1000) NULL,
[Pattern] [varchar](200) NULL,
[IsRequired] [bit] NULL
)
GO
ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestion] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestion] PRIMARY KEY CLUSTERED  ([NeedsAndPrioritiesQuestionId])
GO
CREATE NONCLUSTERED INDEX IX_TNeedsAndPrioritiesQuestion_IsArchived_TenantId ON [dbo].[TNeedsAndPrioritiesQuestion] ([IsArchived],[TenantId])
GO
