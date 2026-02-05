SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VAttribute]

AS


Select A.*, B.AttributeList2AttributeId
From TAttribute a
Inner Join TAttributeList2Attribute b On A.AttributeId=b.AttributeId
GO
