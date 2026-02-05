CREATE TABLE [dbo].[TFactFindData_Not_Used]
(
[FactFindDataId] [int] NOT NULL IDENTITY(1, 1),
[FactFindEntityId] [int] NOT NULL,
[CrmContactId] [int] NOT NULL,
[XmlData] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[IsJoint] [bit] NOT NULL CONSTRAINT [DF_TFactFindData_IsJoint] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindData_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFindData_Not_Used] ADD CONSTRAINT [PK_TFactFindData] PRIMARY KEY CLUSTERED  ([FactFindDataId]) WITH (FILLFACTOR=80)
GO
