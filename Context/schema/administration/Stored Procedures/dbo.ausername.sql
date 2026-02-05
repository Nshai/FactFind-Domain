SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ausername]
	@UserName varchar(255) =''
AS

Select UserId, A.Identifier, Password, CRMContactId, A.IndigoClientId, B.Identifier
from administration..tuser A
Inner JOin TIndigoClient B ON A.IndigoClientId = B.IndigoClientId
where A.identifier like '%' + @UserName + '%'
GO
