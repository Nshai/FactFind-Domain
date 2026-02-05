SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[nio_SpCustomCreateEmailCombined]
@EmailGuid uniqueidentifier = NULL,
@UserGuid uniqueidentifier = NULL
AS

INSERT INTO [Administration].[dbo].[TUserEmailConfigCombined]
           ([EmailGuid]
           ,[UserGuid]
           ,[ConcurrencyId])
       VALUES
           (@EmailGuid,
		    @UserGuid,
            1)
GO
