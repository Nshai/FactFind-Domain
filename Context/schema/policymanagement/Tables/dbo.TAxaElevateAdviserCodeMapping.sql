CREATE TABLE [dbo].[TAxaElevateAdviserCodeMapping](
	[AxaElevateAdviserCodeMappingId] [int] IDENTITY(1,1) NOT NULL,
	[ElevateUserId] [nvarchar](50) NOT NULL,
	[AdviserCode] [nvarchar](50) NOT NULL,
	[FirmFcaNo] [varchar](25) NULL,
	[FirmCode] [varchar](25) NULL
 CONSTRAINT [PK_TAxaElevateAdviserCodeMapping] PRIMARY KEY CLUSTERED 
(
	[AxaElevateAdviserCodeMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
