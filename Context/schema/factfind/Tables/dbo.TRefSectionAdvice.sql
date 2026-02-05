CREATE TABLE [dbo].[TRefSectionAdvice]
(
[RefSectionAdviceId] [int] NOT NULL IDENTITY(1, 1),
[SectionIdentifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Mortgage] [bit] NOT NULL CONSTRAINT [DF__TRefSecti__Mortg__2FC68F97] DEFAULT ((0)),
[Protection] [bit] NOT NULL CONSTRAINT [DF__TRefSecti__Prote__30BAB3D0] DEFAULT ((0)),
[Retirement] [bit] NOT NULL CONSTRAINT [DF__TRefSecti__Retir__31AED809] DEFAULT ((0)),
[Investment] [bit] NOT NULL CONSTRAINT [DF__TRefSecti__Inves__32A2FC42] DEFAULT ((0)),
[Estate] [bit] NOT NULL CONSTRAINT [DF__TRefSecti__Estat__3397207B] DEFAULT ((0)),
[Always] [bit] NOT NULL CONSTRAINT [DF__TRefSecti__Alway__348B44B4] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRefSecti__Concu__357F68ED] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefSectionAdvice] ADD CONSTRAINT [PK__TRefSectionAdvic__2ED26B5E] PRIMARY KEY CLUSTERED  ([RefSectionAdviceId])
GO
