CREATE TABLE [dbo].[TRefClientSegment]
(
[RefClientSegmentId] [int] NOT NULL IDENTITY(1, 1),
[ClientSegmentName] [varchar] (50) NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefClientSegment_IsArchived] DEFAULT ((0)),
[GroupId] [int] NULL,
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TRefClientSegment_IsPropagated] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefClientSegment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefClientSegment] ADD CONSTRAINT [PK_TRefClientSegment] PRIMARY KEY CLUSTERED  ([RefClientSegmentId])
GO
CREATE NONCLUSTERED INDEX IX_TRefClientSegment_IndigoClientId_IsArchived_GroupId ON [dbo].[TRefClientSegment] ([IndigoClientId],[IsArchived],[GroupId])
GO