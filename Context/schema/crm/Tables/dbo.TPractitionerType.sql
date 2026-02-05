CREATE TABLE [dbo].[TPractitionerType]
(
[PractitionerTypeId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Description] [varchar] (255) NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TPractitionerType_CreatedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitionerType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPractitionerType] ADD CONSTRAINT [PK_TPractitionerType] PRIMARY KEY CLUSTERED  ([PractitionerTypeId])
GO
CREATE INDEX ix_TPractitionerType_IndigoClientId ON [dbo].[TPractitionerType] (IndigoClientId)
GO