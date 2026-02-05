CREATE TABLE [dbo].[IO_EXTRACT_TProvLink]
(
[provlinkid] [bigint] NOT NULL,
[refprodproviderid] [bigint] NULL,
[LinkedToId] [bigint] NULL,
[corporatename] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LinkedToCorporateName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
