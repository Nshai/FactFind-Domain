CREATE TABLE [dbo].[TRefChangesTakeEffect]
(
[RefChangesTakeEffectId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefChangesTakeEffect] ADD CONSTRAINT [PK_RefChangesTakeEffect] PRIMARY KEY CLUSTERED  ([RefChangesTakeEffectId])
GO
